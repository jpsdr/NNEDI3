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
		
yloop_2:
		xor eax,eax
		mov ecx,width_
		shr ecx,1
		jz short suite1_2
		
xloop_2:
	movdqa xmm0,XMMWORD ptr[edi+4*eax]   ;V4Y8U4Y7V3Y6U3Y5 V2Y4U2Y3V1Y2U1Y1
	movdqa xmm1,XMMWORD ptr[edi+4*eax+16]   ;V8Y16U8Y15V7Y14U7Y13 V6Y12U6Y11V5Y10U5Y9
	movdqa xmm2,xmm0                      ;V4Y8U4Y7V3Y6U3Y5 V2Y4U2Y3V1Y2U1Y1
	punpcklbw xmm0,xmm1                  ;V6V2Y12Y4U6U2Y11Y3 V5V1Y10Y2U5U1Y9Y1
	punpckhbw xmm2,xmm1                  ;V8V4Y16Y8U8U4Y15Y7 V7V3Y14Y6U7U3Y13Y5
	movdqa xmm1,xmm0
	punpcklbw xmm0,xmm2                  ;V7V5V3V1Y14Y10Y6Y2 U7U5U3U1Y13Y9Y5Y1
	punpckhbw xmm1,xmm2                  ;V8V6V4V2Y16Y12Y8Y4 U8U6U4U2Y15Y11Y7Y3
	movdqa xmm2,xmm0
	punpcklbw xmm0,xmm1                  ;U8U7U6U5U4U3U2U1 Y15Y13Y11Y9Y5Y3Y1
	punpckhbw xmm2,xmm1                  ;V8V7V6V5V4V3V2V1 Y16Y14Y12Y10Y8Y6Y4Y2
	movhps qword ptr [edx+eax],xmm0
	punpcklbw xmm0,xmm2                  ;Y16Y15Y14Y13Y12Y11Y10Y9Y8Y7Y6Y5Y4Y3Y2Y1
	movhps qword ptr [esi+eax],xmm2
	movdqa XMMWORD ptr[ebx+2*eax],xmm0
	add eax,8
	loop xloop_2

suite1_2:
		mov ecx,width_
		and ecx,1
		jz short suite2_2
		
	movdqa xmm0,XMMWORD ptr[esi+4*eax]   ;V4Y8U4Y7V3Y6U3Y5 V2Y4U2Y3V1Y2U1Y1
	movhlps xmm1,xmm0                    ;V4Y8U4Y7V3Y6U3Y5 V4Y8U4Y7V3Y6U3Y5
	punpcklbw xmm0,xmm1                  ;V4V2Y8Y4U4U2Y7Y3 V3V1Y6Y2U3U1Y5Y1
	movhlps xmm1,xmm0                    ;V4V2Y8Y4U4U2Y7Y3 V4V2Y8Y4U4U2Y7Y3
	punpcklbw xmm0,xmm1                  ;V4V3V2V1Y8Y6Y4Y2 U4U3U2U1Y7Y5Y3Y1
	movhlps xmm2,xmm0                    ;xxxxxxxx V4V3V2V1Y8Y6Y4Y2
	movdqa xmm1,xmm0
	psrlq xmm0,32                        ;0000V4V3V2V1 0000U4U3U2U1
	punpcklbw xmm1,xmm2                  ; xxxxxxxx Y8Y7Y6Y5Y4Y3Y2Y1
	movd dword ptr[edx+eax],xmm0
	movhlps xmm2,xmm0
	movq qword ptr[ebx+2*eax],xmm1
	movd dword ptr[esi+eax],xmm2
		
	
suite2_2:	
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
