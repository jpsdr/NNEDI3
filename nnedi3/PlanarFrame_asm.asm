.xmm
.model flat,c

.data

align 16

Ymask qword 2 dup(00FF00FF00FF00FFh)

.code


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
		jl short xloop
		add edi,pitch1
		add ebx,pitch2Y
		add edx,pitch2UV
		add esi,pitch2UV
		dec height
		jnz short yloop
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
		movq qword ptr[ebx+eax*2],xmm0 ;store y
		movd dword ptr[edx+eax],xmm1     ;store u
		movd dword ptr[esi+eax],xmm2     ;store v
		add eax,4
		cmp eax,ecx
		jl short xloop_2
		add edi,pitch1
		add ebx,pitch2Y
		add edx,pitch2UV
		add esi,pitch2UV
		dec height
		jnz short yloop_2
		
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
		jl short xloop_3
		add ebx,pitch1Y
		add edx,pitch1UV
		add esi,pitch1UV
		add edi,pitch2
		dec height
		jnz short yloop_3
		emms

		pop esi
		pop edi
		pop ebx
		
		ret
		
conv422toYUY2_MMX endp


conv422toYUY2_SSE2 proc py:dword,pu:dword,pv:dword,dst:dword,pitch1Y:dword,pitch1UV:dword,modulo2:dword,width_:dword,height:dword

	public conv422toYUY2_SSE2		
	
		push ebx
		push edi
		push esi
		
		mov ebx,py
		mov edx,pu
		mov esi,pv
		mov edi,dst
		
yloop_4:
		xor eax,eax
		mov ecx,width_
		shr ecx,1
		jz suite1
		
xloop_4:
	movq xmm1,qword ptr[edx+4*eax]		;00000000UUUUUUUU
	movq xmm0,qword ptr[esi+4*eax]		;00000000VVVVVVVV
	movdqa xmm2,XMMWORD ptr[ebx+8*eax]	;YYYYYYYYYYYYYYYY	
	punpcklbw xmm1,xmm0					;VUVUVUVUVUVUVUVU
	movdqa xmm3,xmm2
	add eax,2
	punpcklbw xmm2,xmm1     			;VYUYVYUYVYUYVYUY
	punpckhbw xmm3,xmm1     			;VYUYVYUYVYUYVYUY
	
	movdqa XMMWORD ptr[edi],xmm2
	movdqa XMMWORD ptr[edi+16],xmm3
	add edi,32

	loop xloop_4
		
suite1:
	mov ecx,width_
	and ecx,1
	jz short suite2
	
	movd xmm1,dword ptr[edx+4*eax]		;000000000000UUUU
	movd xmm0,dword ptr[esi+4*eax]		;000000000000VVVV
	movq xmm2,qword ptr[ebx+8*eax]		;00000000YYYYYYYY
	punpcklbw xmm1,xmm0					;00000000VUVUVUVU
	punpcklbw xmm2,xmm1     			;VYUYVYUYVYUYVYUY
	
	movdqa XMMWORD ptr[edi],xmm2
	add edi,16
		
suite2:		
		add ebx,pitch1Y
		add edx,pitch1UV
		add esi,pitch1UV
		add edi,modulo2
		dec height
		jnz short yloop_4
		
		pop esi
		pop edi
		pop ebx
		
		ret
		
conv422toYUY2_SSE2 endp


end
