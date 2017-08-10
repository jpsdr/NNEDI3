.data

align 16

Ymask qword 2 dup(00FF00FF00FF00FFh)

.code


;convYUY2to422_MMX proc src:dword,py:dword,pu:dword,pv:dword,pitch1:dword,pitch2Y:dword,pitch2UV:dword,width_:dword,height:dword
; src = rcx
; py = rdx
; pu = r8
; pv = r9

convYUY2to422_MMX proc public frame

pitch1 equ dword ptr[rbp+48]
pitch2Y equ dword ptr[rbp+56]
pitch2UV equ dword ptr[rbp+64]
width_ equ dword ptr[rbp+72]
height equ dword ptr[rbp+80]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rbx
	.pushreg rbx
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	push r12
	.pushreg r12
	.endprolog
		
		mov rdi,rcx
		mov rbx,rdx
		mov rdx,r8
		mov rsi,r9
		xor rcx,rcx
		mov ecx,width_
		shr ecx,1
		movq mm5,qword ptr Ymask
		
		xor r8,r8
		mov r8d,height
		movsxd r9,pitch1
		movsxd r10,pitch2Y
		movsxd r11,pitch2UV
		mov r12,4
		
yloop:
		xor rax,rax
		align 16
xloop:
		movq mm0,[rdi+rax*4]   ;VYUYVYUY
		movq mm1,[rdi+rax*4+8] ;VYUYVYUY
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
		movq [rbx+rax*2],mm0   ;store y
		movd dword ptr[rdx+rax],mm2     ;store u
		movd dword ptr[rsi+rax],mm4     ;store v
		add rax,r12
		cmp rax,rcx
		jl short xloop
		add rdi,r9
		add rbx,r10
		add rdx,r11
		add rsi,r11
		dec r8
		jnz short yloop
		emms
		
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp		
				
		ret
		
convYUY2to422_MMX endp


;convYUY2to422_SSE2 proc src:dword,py:dword,pu:dword,pv:dword,pitch1:dword,pitch2Y:dword,pitch2UV:dword,width_:dword,height:dword
; src = rcx
; py = rdx
; pu = r8
; pv = r9

convYUY2to422_SSE2 proc public frame
	
pitch1 equ dword ptr[rbp+48]
pitch2Y equ dword ptr[rbp+56]
pitch2UV equ dword ptr[rbp+64]
width_ equ dword ptr[rbp+72]
height equ dword ptr[rbp+80]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rbx
	.pushreg rbx
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog
		
		mov rdi,rcx
		mov rbx,rdx
		mov rdx,r8
		mov rsi,r9
		xor rcx,rcx
		mov r13d,width_
		
		xor r8,r8
		mov r8d,height
		movsxd r9,pitch1
		movsxd r10,pitch2Y
		movsxd r11,pitch2UV
		mov r12,8
		mov r14d,r13d
		shr r14d,1
		mov r15d,1		
		
yloop_2:
		xor rax,rax
		mov ecx,r14d
		or ecx,ecx
		jz short suite1_2
		
xloop_2:
	movdqa xmm0,XMMWORD ptr[rdi+4*rax]   ;V4Y8U4Y7V3Y6U3Y5 V2Y4U2Y3V1Y2U1Y1
	movdqa xmm1,XMMWORD ptr[rdi+4*rax+16]   ;V8Y16U8Y15V7Y14U7Y13 V6Y12U6Y11V5Y10U5Y9
	movdqa xmm2,xmm0                      ;V4Y8U4Y7V3Y6U3Y5 V2Y4U2Y3V1Y2U1Y1
	punpcklbw xmm0,xmm1                  ;V6V2Y12Y4U6U2Y11Y3 V5V1Y10Y2U5U1Y9Y1
	punpckhbw xmm2,xmm1                  ;V8V4Y16Y8U8U4Y15Y7 V7V3Y14Y6U7U3Y13Y5
	movdqa xmm1,xmm0
	punpcklbw xmm0,xmm2                  ;V7V5V3V1Y14Y10Y6Y2 U7U5U3U1Y13Y9Y5Y1
	punpckhbw xmm1,xmm2                  ;V8V6V4V2Y16Y12Y8Y4 U8U6U4U2Y15Y11Y7Y3
	movdqa xmm2,xmm0
	punpcklbw xmm0,xmm1                  ;U8U7U6U5U4U3U2U1 Y15Y13Y11Y9Y5Y3Y1
	punpckhbw xmm2,xmm1                  ;V8V7V6V5V4V3V2V1 Y16Y14Y12Y10Y8Y6Y4Y2
	movhps qword ptr [rdx+rax],xmm0
	punpcklbw xmm0,xmm2                  ;Y16Y15Y14Y13Y12Y11Y10Y9Y8Y7Y6Y5Y4Y3Y2Y1
	movhps qword ptr [rsi+rax],xmm2
	movdqa XMMWORD ptr[rbx+2*rax],xmm0
	add rax,r12
	loop xloop_2

suite1_2:
		mov ecx,r13d
		and ecx,r15d
		jz short suite2_2

	movdqa xmm0,XMMWORD ptr[rsi+4*rax]   ;V4Y8U4Y7V3Y6U3Y5 V2Y4U2Y3V1Y2U1Y1
	movhlps xmm1,xmm0                    ;V4Y8U4Y7V3Y6U3Y5 V4Y8U4Y7V3Y6U3Y5
	punpcklbw xmm0,xmm1                  ;V4V2Y8Y4U4U2Y7Y3 V3V1Y6Y2U3U1Y5Y1
	movhlps xmm1,xmm0                    ;V4V2Y8Y4U4U2Y7Y3 V4V2Y8Y4U4U2Y7Y3
	punpcklbw xmm0,xmm1                  ;V4V3V2V1Y8Y6Y4Y2 U4U3U2U1Y7Y5Y3Y1
	movhlps xmm2,xmm0                    ;xxxxxxxx V4V3V2V1Y8Y6Y4Y2
	movdqa xmm1,xmm0
	psrlq xmm0,32                        ;0000V4V3V2V1 0000U4U3U2U1
	punpcklbw xmm1,xmm2                  ; xxxxxxxx Y8Y7Y6Y5Y4Y3Y2Y1
	movd dword ptr[rdx+rax],xmm0
	movhlps xmm2,xmm0
	movq qword ptr[rbx+2*rax],xmm1
	movd dword ptr[rsi+rax],xmm2	
	
suite2_2:	
		add rdi,r9
		add rbx,r10
		add rdx,r11
		add rsi,r11
		dec r8
		jnz yloop_2
		
	pop r15
	pop r14
	pop r13
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp		
				
		ret
		
convYUY2to422_SSE2 endp


;convYUY2to422_AVX proc src:dword,py:dword,pu:dword,pv:dword,pitch1:dword,pitch2Y:dword,pitch2UV:dword,width_:dword,height:dword
; src = rcx
; py = rdx
; pu = r8
; pv = r9

convYUY2to422_AVX proc public frame
	
pitch1 equ dword ptr[rbp+48]
pitch2Y equ dword ptr[rbp+56]
pitch2UV equ dword ptr[rbp+64]
width_ equ dword ptr[rbp+72]
height equ dword ptr[rbp+80]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rbx
	.pushreg rbx
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog
		
		mov rdi,rcx
		mov rbx,rdx
		mov rdx,r8
		mov rsi,r9
		xor rcx,rcx
		mov r13d,width_
		
		xor r8,r8
		mov r8d,height
		movsxd r9,pitch1
		movsxd r10,pitch2Y
		movsxd r11,pitch2UV
		mov r12,8
		mov r14d,r13d
		shr r14d,1
		mov r15d,1		
		
yloop_2_AVX:
		xor rax,rax
		mov ecx,r14d
		or ecx,ecx
		jz short suite1_2_AVX
		
xloop_2_AVX:
	vmovdqa xmm0,XMMWORD ptr[rdi+4*rax]   ;V4Y8U4Y7V3Y6U3Y5 V2Y4U2Y3V1Y2U1Y1
	vmovdqa xmm1,XMMWORD ptr[rdi+4*rax+16]   ;V8Y16U8Y15V7Y14U7Y13 V6Y12U6Y11V5Y10U5Y9
	vpunpckhbw xmm2,xmm0,xmm1                ;V8V4Y16Y8U8U4Y15Y7 V7V3Y14Y6U7U3Y13Y5
	vpunpcklbw xmm0,xmm0,xmm1                ;V6V2Y12Y4U6U2Y11Y3 V5V1Y10Y2U5U1Y9Y1
	vpunpckhbw xmm1,xmm0,xmm2                ;V8V6V4V2Y16Y12Y8Y4 U8U6U4U2Y15Y11Y7Y3
	vpunpcklbw xmm0,xmm0,xmm2                ;V7V5V3V1Y14Y10Y6Y2 U7U5U3U1Y13Y9Y5Y1
	vpunpckhbw xmm2,xmm0,xmm1                ;V8V7V6V5V4V3V2V1 Y16Y14Y12Y10Y8Y6Y4Y2
	vpunpcklbw xmm0,xmm0,xmm1                ;U8U7U6U5U4U3U2U1 Y15Y13Y11Y9Y5Y3Y1
	vmovhps qword ptr [rdx+rax],xmm0
	vpunpcklbw xmm0,xmm0,xmm2                ;Y16Y15Y14Y13Y12Y11Y10Y9Y8Y7Y6Y5Y4Y3Y2Y1
	vmovhps qword ptr [rsi+rax],xmm2
	vmovdqa XMMWORD ptr[rbx+2*rax],xmm0
	add rax,r12
	loop xloop_2_AVX

suite1_2_AVX:
		mov ecx,r13d
		and ecx,r15d
		jz short suite2_2_AVX

	vmovdqa xmm0,XMMWORD ptr[rsi+4*rax]   ;V4Y8U4Y7V3Y6U3Y5 V2Y4U2Y3V1Y2U1Y1
	vmovhlps xmm1,xmm1,xmm0               ;V4Y8U4Y7V3Y6U3Y5 V4Y8U4Y7V3Y6U3Y5
	vpunpcklbw xmm0,xmm0,xmm1             ;V4V2Y8Y4U4U2Y7Y3 V3V1Y6Y2U3U1Y5Y1
	vmovhlps xmm1,xmm1,xmm0               ;V4V2Y8Y4U4U2Y7Y3 V4V2Y8Y4U4U2Y7Y3
	vpunpcklbw xmm0,xmm0,xmm1             ;V4V3V2V1Y8Y6Y4Y2 U4U3U2U1Y7Y5Y3Y1
	vmovhlps xmm2,xmm2,xmm0               ;xxxxxxxx V4V3V2V1Y8Y6Y4Y2
	vpunpcklbw xmm1,xmm0,xmm2             ; xxxxxxxx Y8Y7Y6Y5Y4Y3Y2Y1
	vpsrlq xmm0,xmm0,32                   ;0000V4V3V2V1 0000U4U3U2U1
	vmovd dword ptr[rdx+rax],xmm0
	vmovhlps xmm2,xmm2,xmm0
	vmovq qword ptr[rbx+2*rax],xmm1
	vmovd dword ptr[rsi+rax],xmm2	
	
suite2_2_AVX:	
		add rdi,r9
		add rbx,r10
		add rdx,r11
		add rsi,r11
		dec r8
		jnz yloop_2_AVX
		
	pop r15
	pop r14
	pop r13
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp		
				
		ret
		
convYUY2to422_AVX endp


;conv422toYUY2_MMX proc py:dword,pu:dword,pv:dword,dst:dword,pitch1Y:dword,pitch1UV:dword,pitch2:dword,width_:dword,height:dword
; py = rcx
; pu = rdx
; pv = r8
; dst = r9

conv422toYUY2_MMX proc public frame
	
pitch1Y equ dword ptr[rbp+48]
pitch1UV equ dword ptr[rbp+56]
pitch2 equ dword ptr[rbp+64]
width_ equ dword ptr[rbp+72]
height equ dword ptr[rbp+80]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rbx
	.pushreg rbx
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	push r12
	.pushreg r12
	.endprolog
			
		mov rbx,rcx
		mov rsi,r8
		mov rdi,r9
		xor rcx,rcx
		mov ecx,width_
		shr ecx,1
		
		xor r8,r8
		mov r8d,height
		movsxd r9,pitch1Y
		movsxd r10,pitch1UV
		movsxd r11,pitch2
		mov r12,4			
		
yloop_3:
		xor rax,rax
		align 16
xloop_3:
		movq mm0,[rbx+rax*2]   ;YYYYYYYY
		movd mm1,dword ptr[rdx+rax]     ;0000UUUU
		movd mm2,dword ptr[rsi+rax]     ;0000VVVV
		movq mm3,mm0           ;YYYYYYYY
		punpcklbw mm1,mm2      ;VUVUVUVU
		punpcklbw mm0,mm1      ;VYUYVYUY
		punpckhbw mm3,mm1      ;VYUYVYUY
		movq [rdi+rax*4],mm0   ;store
		movq [rdi+rax*4+8],mm3 ;store
		add rax,r12
		cmp rax,rcx
		jl short xloop_3
		add rbx,r9
		add rdx,r10
		add rsi,r10
		add rdi,r11
		dec r8
		jnz short yloop_3
		emms

	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp		
		
		ret
		
conv422toYUY2_MMX endp


;conv422toYUY2_SSE2 proc py:dword,pu:dword,pv:dword,dst:dword,pitch1Y:dword,pitch1UV:dword,pitch2:dword,width_:dword,height:dword
; py = rcx
; pu = rdx
; pv = r8
; dst = r9

conv422toYUY2_SSE2 proc public frame
	
pitch1Y equ dword ptr[rbp+48]
pitch1UV equ dword ptr[rbp+56]
pitch2 equ dword ptr[rbp+64]
width_ equ dword ptr[rbp+72]
height equ dword ptr[rbp+80]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rbx
	.pushreg rbx
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog
			
		mov rbx,rcx
		mov rsi,r8
		mov rdi,r9
		xor rcx,rcx
		mov r15d,width_
		shr ecx,1
		
		xor r8,r8
		mov r8d,height
		movsxd r9,pitch1Y
		movsxd r10,pitch1UV
		movsxd r11,pitch2
		mov r12,16
		mov r13,32
		mov r14,2
		
yloop_4:
		xor rax,rax
		mov ecx,r15d
		shr ecx,1
		jz short suite1
		
xloop_4:
		movq xmm1,qword ptr[rdx+4*rax]     ;00000000UUUUUUUU
		movq xmm0,qword ptr[rsi+4*rax]     ;00000000VVVVVVVV
		movdqa xmm2,XMMWORD ptr[rbx+8*rax] ;YYYYYYYYYYYYYYYY
		punpcklbw xmm1,xmm0					;VUVUVUVUVUVUVUVU
		movdqa xmm3,xmm2
		add rax,r14
		punpcklbw xmm2,xmm1     			;VYUYVYUYVYUYVYUY
		punpckhbw xmm3,xmm1     			;VYUYVYUYVYUYVYUY
		
		movdqa XMMWORD ptr[rdi],xmm2 ;store
		movdqa XMMWORD ptr[rdi+r12],xmm3 ;store
		add rdi,r13
		loop xloop_4
		
suite1:		
		mov ecx,r15d
		and ecx,1
		jz short suite2

		movd xmm1,dword ptr[rdx+4*rax]     ;000000000000UUUU
		movd xmm0,dword ptr[rsi+4*rax]     ;000000000000VVVV
		movq xmm2,qword ptr[rbx+8*rax] ;00000000YYYYYYY
		punpcklbw xmm1,xmm0					;00000000VUVUVUVU
		punpcklbw xmm2,xmm1     			;VYUYVYUYVYUYVYUY
		
		movdqa XMMWORD ptr[rdi],xmm2 ;store
		add rdi,r12			
		
suite2:		
		add rbx,r9
		add rdx,r10
		add rsi,r10
		add rdi,r11
		dec r8
		jnz short yloop_4
		
	pop r15
	pop r14
	pop r13
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp		
				
		ret
		
conv422toYUY2_SSE2 endp


;conv422toYUY2_AVX proc py:dword,pu:dword,pv:dword,dst:dword,pitch1Y:dword,pitch1UV:dword,pitch2:dword,width_:dword,height:dword
; py = rcx
; pu = rdx
; pv = r8
; dst = r9

conv422toYUY2_AVX proc public frame
	
pitch1Y equ dword ptr[rbp+48]
pitch1UV equ dword ptr[rbp+56]
pitch2 equ dword ptr[rbp+64]
width_ equ dword ptr[rbp+72]
height equ dword ptr[rbp+80]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rbx
	.pushreg rbx
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog
			
		mov rbx,rcx
		mov rsi,r8
		mov rdi,r9
		xor rcx,rcx
		mov r15d,width_
		shr ecx,1
		
		xor r8,r8
		mov r8d,height
		movsxd r9,pitch1Y
		movsxd r10,pitch1UV
		movsxd r11,pitch2
		mov r12,16
		mov r13,32
		mov r14,2
		
yloop_4_AVX:
		xor rax,rax
		mov ecx,r15d
		shr ecx,1
		jz short suite1_AVX
		
xloop_4_AVX:
		vmovq xmm1,qword ptr[rdx+4*rax]     ;00000000UUUUUUUU
		vmovq xmm0,qword ptr[rsi+4*rax]     ;00000000VVVVVVVV
		vmovdqa xmm2,XMMWORD ptr[rbx+8*rax] ;YYYYYYYYYYYYYYYY
		vpunpcklbw xmm1,xmm1,xmm0				;VUVUVUVUVUVUVUVU
		add rax,r14
		vpunpckhbw xmm3,xmm2,xmm1     			;VYUYVYUYVYUYVYUY
		vpunpcklbw xmm2,xmm2,xmm1     			;VYUYVYUYVYUYVYUY
		
		vmovdqa XMMWORD ptr[rdi],xmm2 ;store
		vmovdqa XMMWORD ptr[rdi+r12],xmm3 ;store
		add rdi,r13
		loop xloop_4_AVX
		
suite1_AVX:		
		mov ecx,r15d
		and ecx,1
		jz short suite2_AVX

		vmovd xmm1,dword ptr[rdx+4*rax]     ;000000000000UUUU
		vmovd xmm0,dword ptr[rsi+4*rax]     ;000000000000VVVV
		vmovq xmm2,qword ptr[rbx+8*rax] ;00000000YYYYYYY
		vpunpcklbw xmm1,xmm1,xmm0				;00000000VUVUVUVU
		vpunpcklbw xmm2,xmm2,xmm1     			;VYUYVYUYVYUYVYUY
		
		vmovdqa XMMWORD ptr[rdi],xmm2 ;store
		add rdi,r12			
		
suite2_AVX:		
		add rbx,r9
		add rdx,r10
		add rsi,r10
		add rdi,r11
		dec r8
		jnz short yloop_4_AVX
		
	pop r15
	pop r14
	pop r13
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp		
				
		ret
		
conv422toYUY2_AVX endp


end
