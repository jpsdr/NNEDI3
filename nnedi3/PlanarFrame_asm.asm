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

asm_BitBlt_ISSE_1 proc srcStart:dword,dstStart:dword,row_size:dword,height:dword,src_pitch:dword,dst_pitch:dword

	public asm_BitBlt_ISSE_1

		push ebx
		push edi
		push esi
		
			mov   esi,srcStart
			mov   edi,dstStart
			mov   edx,row_size
			dec   edx
			mov   ebx,height
			align 16
memoptS_rowloop:
			mov   ecx,edx
memoptS_byteloop:
			mov   AL,[esi+ecx]
			mov   [edi+ecx],AL
			sub   ecx,1
			jnc   memoptS_byteloop
			sub   esi,src_pitch
			sub   edi,dst_pitch
			dec   ebx
			jne   memoptS_rowloop
			
		pop esi
		pop edi
		pop ebx
		
		ret
		
asm_BitBlt_ISSE_1 endp


asm_BitBlt_ISSE_2 proc srcStart:dword,dstStart:dword,row_size:dword,height:dword,src_pitch:dword,dst_pitch:dword

	public asm_BitBlt_ISSE_2

		push ebx
		push edi
		push esi
		
			mov   esi,srcStart
			mov   al,[esi]
			mov   edi,dstStart
			mov   edx,row_size
			mov   ebx,height
			align 16
memoptU_rowloop:
			mov   ecx,edx
			dec   ecx
			add   ecx,esi
			and   ecx,0FFFFFFC0h
memoptU_prefetchloop:
			mov   AX,[ecx]
			sub   ecx,64
			cmp   ecx,esi
			jae   memoptU_prefetchloop
			movq    mm6,[esi]
			movntq  [edi],mm6
			mov   eax,edi
			neg   eax
			mov   ecx,eax
			and   eax,63
			and   ecx,7
			align 16
memoptU_prewrite8loop:
			cmp   ecx,eax
			jz    memoptU_pre8done
			movq    mm7,[esi+ecx]
			movntq  [edi+ecx],mm7
			add   ecx,8
			jmp   memoptU_prewrite8loop
			align 16
memoptU_write64loop:
			movntq  [edi+ecx-64],mm0
			movntq  [edi+ecx-56],mm1
			movntq  [edi+ecx-48],mm2
			movntq  [edi+ecx-40],mm3
			movntq  [edi+ecx-32],mm4
			movntq  [edi+ecx-24],mm5
			movntq  [edi+ecx-16],mm6
			movntq  [edi+ecx- 8],mm7
memoptU_pre8done:
			add   ecx,64
			cmp   ecx,edx
			ja    memoptU_done64
			movq    mm0,[esi+ecx-64]
			movq    mm1,[esi+ecx-56]
			movq    mm2,[esi+ecx-48]
			movq    mm3,[esi+ecx-40]
			movq    mm4,[esi+ecx-32]
			movq    mm5,[esi+ecx-24]
			movq    mm6,[esi+ecx-16]
			movq    mm7,[esi+ecx- 8]
			jmp   memoptU_write64loop
memoptU_done64:
			sub     ecx,64
			align 16
memoptU_write8loop:
			add     ecx,8
			cmp     ecx,edx
			ja      memoptU_done8
			movq    mm0,[esi+ecx-8]
			movntq  [edi+ecx-8],mm0
			jmp   memoptU_write8loop
memoptU_done8:
			movq    mm1,[esi+edx-8]
			movntq  [edi+edx-8],mm1
			sub   esi,src_pitch
			sub   edi,dst_pitch
			dec   ebx
			jne   memoptU_rowloop
			sfence
			emms
			
		pop esi
		pop edi
		pop ebx
		
		ret
		
asm_BitBlt_ISSE_2 endp
			

asm_BitBlt_ISSE_3 proc srcStart:dword,dstStart:dword,row_size:dword,height:dword,src_pitch:dword,dst_pitch:dword

	public asm_BitBlt_ISSE_3

		push ebx
		push edi
		push esi

			mov   esi,srcStart
			mov   edi,dstStart
			mov   ebx,height
			mov   edx,row_size
			align 16
memoptA_rowloop:
			mov   ecx,edx
			dec   ecx
			add   ecx,esi
			and   ecx,0FFFFFFC0h
			align 16
memoptA_prefetchloop:
			mov   AX,[ecx]
			sub   ecx,64
			cmp   ecx,esi
			jae   memoptA_prefetchloop
			mov   eax,edi
			xor   ecx,ecx
			neg   eax
			and   eax,63
			align 16
memoptA_prewrite8loop:
			cmp   ecx,eax
			jz    memoptA_pre8done
			movq    mm7,[esi+ecx]
			movntq  [edi+ecx],mm7
			add   ecx,8
			jmp   memoptA_prewrite8loop
			align 16
			memoptA_write64loop:
			movntq  [edi+ecx-64],mm0
			movntq  [edi+ecx-56],mm1
			movntq  [edi+ecx-48],mm2
			movntq  [edi+ecx-40],mm3
			movntq  [edi+ecx-32],mm4
			movntq  [edi+ecx-24],mm5
			movntq  [edi+ecx-16],mm6
			movntq  [edi+ecx- 8],mm7
memoptA_pre8done:
			add   ecx,64
			cmp   ecx,edx
			ja    memoptA_done64
			movq    mm0,[esi+ecx-64]
			movq    mm1,[esi+ecx-56]
			movq    mm2,[esi+ecx-48]
			movq    mm3,[esi+ecx-40]
			movq    mm4,[esi+ecx-32]
			movq    mm5,[esi+ecx-24]
			movq    mm6,[esi+ecx-16]
			movq    mm7,[esi+ecx- 8]
			jmp   memoptA_write64loop
memoptA_done64:
			sub   ecx,64
			align 16
memoptA_write8loop:
			add   ecx,8
			cmp   ecx,edx
			ja    memoptA_done8
			movq    mm7,[esi+ecx-8]
			movntq  [edi+ecx-8],mm7
			jmp   memoptA_write8loop
memoptA_done8:
			sub   esi,src_pitch
			sub   edi,dst_pitch
			dec   ebx
			jne   memoptA_rowloop
			sfence
			emms
			
		pop esi
		pop edi
		pop ebx
		
		ret
		
asm_BitBlt_ISSE_3 endp
			

end
