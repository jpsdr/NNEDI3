.xmm
.model flat,c

.data

align 16

Ymask qword 2 dup(00FF00FF00FF00FFh)

.code

checkCPU_ASM proc

    public checkCPU_ASM
	
	    push edi
		push ebx
	
		xor edi,edi     ; zero to  begin
		pushfd          ;check for CPUID.
		pop eax
		or eax,00200000h
		push eax
		popfd
		pushfd
		pop eax
		and eax,00200000h
		jz TEST_END
		xor eax,eax   ;check for features register.
		cpuid
		or eax,eax
		jz TEST_END
		mov eax,1
		cpuid
		test edx,00800000h  ;check MMX
		jz TEST_SSE
		or edi,1
TEST_SSE:
		test edx,02000000h  ;check SSE
		jz TEST_SSE2
		or edi,2
		or edi,4
TEST_SSE2:
		test edx,04000000h  ;check SSE2
		jz TEST_AMD
		or edi,8
		test ecx,00000001h  ;check SSE3
		jz TEST_AMD
		or edi,64
		test ecx,00000200h  ;check SSSE3
		jz TEST_AMD
		or edi,128
		test ecx,00080000h  ;check SSE4.1
		jz TEST_AMD
		or edi,256
		test ecx,00100000h  ;check SSE4.2
		jz TEST_AMD
		or edi,512
TEST_AMD:  ;check for vendor feature register (K6/Athlon).
		mov eax,80000000h
		cpuid
		mov ecx,80000001h
		cmp eax,ecx
		jb TEST_END
		mov eax,80000001h
		cpuid
		test edx,80000000h ; check 3DNOW
		jz TEST_3DNOW2
		or edi,16
TEST_3DNOW2:
		test edx,40000000h ; check 3DNOW2
		jz TEST_SSEMMX
		or edi,32
TEST_SSEMMX:
		test edx,00400000h  ;check iSSE
		jz TEST_END
		or edi,2
TEST_END:
		mov eax,edi
		
		pop ebx
		pop edi
		
		ret
		
checkCPU_ASM  endp


checkSSEOSSupport_ASM proc

	public checkSSEOSSupport_ASM
	
	xorps xmm0,xmm0
	
	ret
	
checkSSEOSSupport_ASM endp


checkSSE2OSSupport_ASM proc

	public checkSSE2OSSupport_ASM
	
	xorpd xmm0,xmm0
	
	ret
	
checkSSE2OSSupport_ASM endp


convYUY2to422_MMX proc src:dword,py:dword,pu:dword,pv:dword,pitch1:dword,pitch2Y:dword,pitch2UV:dword,width_:dword,height:dword

	public convYUY2to422_MMX		
	
		push ebx
		push edi
		push esi
		
		mov edi,src
		mov ebx,py
		mov edx,pu
		mov esi,pv
		mov ecx,width_
		shr ecx,1
		movq mm5,qword ptr Ymask
yloop:
		xor eax,eax
		align 16
xloop:
		movq mm0,[edi+eax*4]   ;VYUYVYUY
		movq mm1,[edi+eax*4+8] ;VYUYVYUY
		movq mm2,mm0           ;VYUYVYUY
		movq mm3,mm1           ;VYUYVYUY
		pand mm0,mm5           ;0Y0Y0Y0Y
		psrlw mm2,8 	       ;0V0U0V0U
		pand mm1,mm5           ;0Y0Y0Y0Y
		psrlw mm3,8            ;0V0U0V0U
		packuswb mm0,mm1       ;YYYYYYYY
		packuswb mm2,mm3       ;VUVUVUVU
		movq mm4,mm2           ;VUVUVUVU
		pand mm2,mm5           ;0U0U0U0U
		psrlw mm4,8            ;0V0V0V0V
		packuswb mm2,mm2       ;xxxxUUUU
		packuswb mm4,mm4       ;xxxxVVVV
		movq [ebx+eax*2],mm0   ;store y
		movd dword ptr[edx+eax],mm2     ;store u
		movd dword ptr[esi+eax],mm4     ;store v
		add eax,4
		cmp eax,ecx
		jl xloop
		add edi,pitch1
		add ebx,pitch2Y
		add edx,pitch2UV
		add esi,pitch2UV
		dec height
		jnz yloop
		emms
		
		pop esi
		pop edi
		pop ebx
		
		ret
		
convYUY2to422_MMX endp


convYUY2to422_SSE2 proc src:dword,py:dword,pu:dword,pv:dword,pitch1:dword,pitch2Y:dword,pitch2UV:dword,width_:dword,height:dword

	public convYUY2to422_SSE2		
	
		push ebx
		push edi
		push esi
	
		mov edi,src
		mov ebx,py
		mov edx,pu
		mov esi,pv
		mov ecx,width_
		shr ecx,1
		movdqa xmm3,oword ptr Ymask
yloop_2:
		xor eax,eax
		align 16
xloop_2:
		movdqa xmm0,[edi+eax*4] ;VYUYVYUYVYUYVYUY
		movdqa xmm1,xmm0        ;VYUYVYUYVYUYVYUY
		pand xmm0,xmm3          ;0Y0Y0Y0Y0Y0Y0Y0Y
		psrlw xmm1,8	        ;0V0U0V0U0V0U0V0U
		packuswb xmm0,xmm0      ;xxxxxxxxYYYYYYYY
		packuswb xmm1,xmm1      ;xxxxxxxxVUVUVUVU
		movdqa xmm2,xmm1        ;xxxxxxxxVUVUVUVU
		pand xmm1,xmm3          ;xxxxxxxx0U0U0U0U
		psrlw xmm2,8            ;xxxxxxxx0V0V0V0V
		packuswb xmm1,xmm1      ;xxxxxxxxxxxxUUUU
		packuswb xmm2,xmm2      ;xxxxxxxxxxxxVVVV
		movlpd qword ptr[ebx+eax*2],xmm0 ;store y
		movd dword ptr[edx+eax],xmm1     ;store u
		movd dword ptr[esi+eax],xmm2     ;store v
		add eax,4
		cmp eax,ecx
		jl xloop_2
		add edi,pitch1
		add ebx,pitch2Y
		add edx,pitch2UV
		add esi,pitch2UV
		dec height
		jnz yloop_2
		
		pop esi
		pop edi
		pop ebx
		
		ret
		
convYUY2to422_SSE2 endp


conv422toYUY2_MMX proc py:dword,pu:dword,pv:dword,dst:dword,pitch1Y:dword,pitch1UV:dword,pitch2:dword,width_:dword,height:dword

	public conv422toYUY2_MMX		
	
		push ebx
		push edi
		push esi
	
		mov ebx,py
		mov edx,pu
		mov esi,pv
		mov edi,dst
		mov ecx,width_
		shr ecx,1
yloop_3:
		xor eax,eax
		align 16
xloop_3:
		movq mm0,[ebx+eax*2]   ;YYYYYYYY
		movd mm1,dword ptr[edx+eax]     ;0000UUUU
		movd mm2,dword ptr[esi+eax]     ;0000VVVV
		movq mm3,mm0           ;YYYYYYYY
		punpcklbw mm1,mm2      ;VUVUVUVU
		punpcklbw mm0,mm1      ;VYUYVYUY
		punpckhbw mm3,mm1      ;VYUYVYUY
		movq [edi+eax*4],mm0   ;store
		movq [edi+eax*4+8],mm3 ;store
		add eax,4
		cmp eax,ecx
		jl xloop_3
		add ebx,pitch1Y
		add edx,pitch1UV
		add esi,pitch1UV
		add edi,pitch2
		dec height
		jnz yloop_3
		emms

		pop esi
		pop edi
		pop ebx
		
		ret
		
conv422toYUY2_MMX endp


conv422toYUY2_SSE2 proc py:dword,pu:dword,pv:dword,dst:dword,pitch1Y:dword,pitch1UV:dword,pitch2:dword,width_:dword,height:dword

	public conv422toYUY2_SSE2		
	
		push ebx
		push edi
		push esi
	
		mov ebx,py
		mov edx,pu
		mov esi,pv
		mov edi,dst
		mov ecx,width_
		shr ecx,1
yloop_4:
		xor eax,eax
		align 16
xloop_4:
		movlpd xmm0,qword ptr[ebx+eax*2] ;????????YYYYYYYY
		movd xmm1,dword ptr[edx+eax]     ;000000000000UUUU
		movd xmm2,dword ptr[esi+eax]     ;000000000000VVVV
		punpcklbw xmm1,xmm2     ;00000000VUVUVUVU
		punpcklbw xmm0,xmm1     ;VYUYVYUYVYUYVYUY
		movdqa [edi+eax*4],xmm0 ;store
		add eax,4
		cmp eax,ecx
		jl xloop_4
		add ebx,pitch1Y
		add edx,pitch1UV
		add esi,pitch1UV
		add edi,pitch2
		dec height
		jnz yloop_4
		
		pop esi
		pop edi
		pop ebx
		
		ret
		
conv422toYUY2_SSE2 endp



memcpy_SSE2 proc dst_:dword,src_:dword,size_:dword

	public memcpy_SSE2
	
	push esi
	push edi
	push ebx
	
	mov esi,src_
	mov edi,dst_
	mov eax,64
	mov edx,16
	mov ebx,48
		
	mov ecx,size_
	shr ecx,6
	jz short Suite0_1
Boucle0_1:
	movdqa xmm0,oword ptr[esi]
	movdqa xmm1,oword ptr[esi+edx]
	movdqa xmm2,oword ptr[esi+2*edx]
	movdqa xmm3,oword ptr[esi+ebx]
	movntdq oword ptr[edi],xmm0
	movntdq oword ptr[edi+edx],xmm1
	movntdq oword ptr[edi+2*edx],xmm2
	movntdq oword ptr[edi+ebx],xmm3
	add esi,eax
	add edi,eax
	loop Boucle0_1
Suite0_1:	
	mov edx,size_
	and edx,63
	jz short Suite2_1
	cld
	mov ecx,edx
	shr ecx,2
	jz short Suite1_1
	rep stosd
Suite1_1:
	and edx,3
	jz short Suite2_1
	mov ecx,edx
	rep stosb
	
Suite2_1:
	pop ebx
	pop edi
	pop esi
	
	ret
memcpy_SSE2 endp	
	
	
	
memcpy_SSE2_b proc dst_:dword,src_:dword,size_:dword

	public memcpy_SSE2_b
	
	push esi
	push edi
	
	mov esi,src_
	mov edi,dst_
	mov eax,64
		
	mov ecx,size_
	shr ecx,6
	jz short Suite0_2
Boucle0_2:
	movq mm0,qword ptr[esi]
	movq mm1,qword ptr[esi+8]
	movq mm2,qword ptr[esi+16]
	movq mm3,qword ptr[esi+24]
	movq mm4,qword ptr[esi+32]
	movq mm5,qword ptr[esi+40]
	movq mm6,qword ptr[esi+48]
	movq mm7,qword ptr[esi+56]
	movntq qword ptr[edi],mm0
	movntq qword ptr[edi+8],mm1
	movntq qword ptr[edi+16],mm2
	movntq qword ptr[edi+24],mm3
	movntq qword ptr[edi+32],mm0
	movntq qword ptr[edi+40],mm1
	movntq qword ptr[edi+48],mm2
	movntq qword ptr[edi+56],mm3
	add esi,eax
	add edi,eax
	loop Boucle0_2
Suite0_2:	
	mov edx,size_
	and edx,63
	jz short Suite2_2
	cld
	mov ecx,edx
	shr ecx,2
	jz short Suite1_2
	rep stosd
Suite1_2:
	and edx,3
	jz short Suite2_2
	mov ecx,edx
	rep stosb
	
Suite2_2:
	emms
	pop edi
	pop esi
	
	ret
memcpy_SSE2_b endp	
	
	
	
Move_Full_SSE2 proc src_:dword,dst_:dword,w:dword,h:dword,src_modulo:dword,dst_modulo:dword

	public Move_Full_SSE2
	
	push esi
	push edi
	push ebx
	
	mov esi,src_
	mov edi,dst_
	mov eax,64
	mov edx,16
	mov ebx,w
	cld
		
Boucle0_3:		
	mov ecx,ebx
	shr ecx,6
	jz short Suite0_3
Boucle1_3:
	movdqa xmm0,oword ptr[esi]
	movdqa xmm1,oword ptr[esi+edx]
	movdqa xmm2,oword ptr[esi+2*edx]
	movdqa xmm3,oword ptr[esi+48]
	movntdq oword ptr[edi],xmm0
	movntdq oword ptr[edi+edx],xmm1
	movntdq oword ptr[edi+2*edx],xmm2
	movntdq oword ptr[edi+48],xmm3
	add esi,eax
	add edi,eax
	loop Boucle1_3
Suite0_3:	
	mov ecx,ebx
	and ecx,63
	jz short Suite2_3
	shr ecx,2
	jz short Suite1_3
	rep stosd
Suite1_3:
	mov ecx,ebx
	and ecx,3
	jz short Suite2_3
	rep stosb
	
Suite2_3:
	add esi,src_modulo
	add edi,dst_modulo
	dec h
	jnz short Boucle0_3

	pop ebx
	pop edi
	pop esi
	
	ret
Move_Full_SSE2 endp		
	

	
Move_Full_SSE2_b proc src_:dword,dst_:dword,w:dword,h:dword,src_modulo:dword,dst_modulo:dword

	public Move_Full_SSE2_b
	
	push esi
	push edi
	push ebx
	
	mov esi,src_
	mov edi,dst_
	mov eax,64
	mov edx,63
	mov ebx,w
	cld
		
Boucle0_4:		
	mov ecx,ebx
	shr ecx,6
	jz short Suite0_4
Boucle1_4:
	movq mm0,qword ptr[esi]
	movq mm1,qword ptr[esi+8]
	movq mm2,qword ptr[esi+16]
	movq mm3,qword ptr[esi+24]
	movq mm4,qword ptr[esi+32]
	movq mm5,qword ptr[esi+40]
	movq mm6,qword ptr[esi+48]
	movq mm7,qword ptr[esi+56]
	movntq qword ptr[edi],mm0
	movntq qword ptr[edi+8],mm1
	movntq qword ptr[edi+16],mm2
	movntq qword ptr[edi+24],mm3
	movntq qword ptr[edi+32],mm0
	movntq qword ptr[edi+40],mm1
	movntq qword ptr[edi+48],mm2
	movntq qword ptr[edi+56],mm3
	add esi,eax
	add edi,eax
	loop Boucle1_4
Suite0_4:	
	mov ecx,ebx
	and ecx,edx
	jz short Suite2_4
	shr ecx,2
	jz short Suite1_4
	rep stosd
Suite1_4:
	mov ecx,ebx
	and ecx,3
	jz short Suite2_4
	rep stosb
	
Suite2_4:
	add esi,src_modulo
	add edi,dst_modulo
	dec h
	jnz short Boucle0_4

	emms
	pop ebx
	pop edi
	pop esi
	
	ret
Move_Full_SSE2_b endp		


end
