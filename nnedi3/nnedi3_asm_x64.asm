.data

FLT_EPSILON  equ   1.192092896e-07

align 16

sign_bits_f_zero_l qword 7FFFFFFF00000000h,7FFFFFFF7FFFFFFFh
sign_bits_f qword 2 dup(7FFFFFFF7FFFFFFFh)
ones_f real4 4 dup(1.0)

w_19 sword 8 dup(19)
w_3 sword 8 dup(3)
ub_1 byte 16 dup(1)
uw_16 word 8 dup(16)
w_254 sword 8 dup(254)

d_19 sdword 4 dup(19)
d_3 sdword 4 dup(3)
ud_16 dword 8 dup(16)
uw_1 word 8 dup(1)

f_19 real4 4 dup(0.59375)
f_3 real4 4 dup(0.09375)
dw_1 dword 4 dup(1)

flt_epsilon_sse real4 4 dup(FLT_EPSILON)

exp_hi real4 4 dup(80.0)
exp_lo real4 4 dup(-80.0)

; exp from:  A Fast, Compact Approximation of the Exponential Function (1998)
;            Nicol N. Schraudolph

e0_mult real4 4 dup(12102203.161561486)   ; (1.0/ln(2))*(2^23)
e0_bias real4 4 dup(1064866805.0)         ; (2^23)*127.0-486411.0

; exp from Loren Merritt

e1_scale real4 4 dup(1.4426950409)        ; 1/ln(2)
e1_bias real4 4 dup(12582912.0)           ; 3<<22
e1_c1 real4 4 dup(0.701277797)
e1_c2 real4 4 dup(0.237348593)
e1_c0 real4 4 dup(1.00035)

; exp from Intel Approximate Math (AM) Library

exp_rln2 real4 4 dup(1.442695041)
am_0p5 real4 4 dup(0.5)
epi32_1 sdword 4 dup(1)
exp_c2 real4 4 dup(1.428606820e-6)
exp_c1 real4 4 dup(6.931457520e-1)
exp_q0 real4 4 dup(3.001985051e-6)
exp_p0 real4 4 dup(1.261771931e-4)
epi32_0x7f sdword 4 dup(7Fh)
exp_q1 real4 4 dup(2.524483403e-3)
exp_p1 real4 4 dup(3.029944077e-2)
exp_q2 real4 4 dup(2.272655482e-1)
am_1 real4 4 dup(1.0)
exp_q3 real4 4 dup(2.0)

min_weight_sum real4 4 dup(1.0e-10)
five_f real4 4 dup(5.0)

sse_half real4 4 dup(0.5)

.code

;computeNetwork0_SSE2 proc input:dword,weights:dword,ptr_d:dword
; input = rcx
; weights = rdx
; ptr_d = r8

computeNetwork0_SSE2 proc public frame

	sub rsp,32
	.allocstack 32
	movdqu oword ptr[rsp],xmm6
	.savexmm128 xmm6,0
	movdqu oword ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog
	
		mov rax,1
		movaps xmm0,[rcx]
		movaps xmm1,xmm0
		movaps xmm2,xmm0
		movaps xmm3,xmm0
		mulps xmm0,[rdx]
		mulps xmm1,[rdx+16]
		mulps xmm2,[rdx+32]
		mulps xmm3,[rdx+48]
		
		movaps xmm4,[rcx+16]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[rdx+64]
		mulps xmm5,[rdx+80]
		mulps xmm6,[rdx+96]
		mulps xmm7,[rdx+112]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[rcx+32]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[rdx+128]
		mulps xmm5,[rdx+144]
		mulps xmm6,[rdx+160]
		mulps xmm7,[rdx+176]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[rcx+48]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[rdx+192]
		mulps xmm5,[rdx+208]
		mulps xmm6,[rdx+224]
		mulps xmm7,[rdx+240]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[rcx+64]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[rdx+256]
		mulps xmm5,[rdx+272]
		mulps xmm6,[rdx+288]
		mulps xmm7,[rdx+304]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[rcx+80]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[rdx+320]
		mulps xmm5,[rdx+336]
		mulps xmm6,[rdx+352]
		mulps xmm7,[rdx+368]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[rcx+96]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[rdx+384]
		mulps xmm5,[rdx+400]
		mulps xmm6,[rdx+416]
		mulps xmm7,[rdx+432]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[rcx+112]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[rdx+448]
		mulps xmm5,[rdx+464]
		mulps xmm6,[rdx+480]
		mulps xmm7,[rdx+496]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[rcx+128]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[rdx+512]
		mulps xmm5,[rdx+528]
		mulps xmm6,[rdx+544]
		mulps xmm7,[rdx+560]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[rcx+144]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[rdx+576]
		mulps xmm5,[rdx+592]
		mulps xmm6,[rdx+608]
		mulps xmm7,[rdx+624]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[rcx+160]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[rdx+640]
		mulps xmm5,[rdx+656]
		mulps xmm6,[rdx+672]
		mulps xmm7,[rdx+688]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[rcx+176]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[rdx+704]
		mulps xmm5,[rdx+720]
		mulps xmm6,[rdx+736]
		mulps xmm7,[rdx+752]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,xmm0
		movaps xmm5,xmm2
		unpcklpd xmm0,xmm1
		unpcklpd xmm2,xmm3
		unpckhpd xmm4,xmm1
		unpckhpd xmm5,xmm3
		addps xmm0,xmm4
		addps xmm2,xmm5
		movaps xmm6,xmm0
		shufps xmm0,xmm2,136
		shufps xmm6,xmm2,221
		
		addps xmm0,xmm6
		addps xmm0,[rdx+768]
		movaps xmm1,xmm0
		andps xmm0,oword ptr sign_bits_f_zero_l
		addps xmm0,ones_f
		rcpps xmm0,xmm0
		mulps xmm0,xmm1
		pshufd xmm1,xmm0,0
		pshufd xmm2,xmm0,85
		pshufd xmm3,xmm0,170
		pshufd xmm4,xmm0,255
		mulps xmm1,[rdx+784]
		mulps xmm2,[rdx+784+16]
		mulps xmm3,[rdx+784+32]
		mulps xmm4,[rdx+784+48]
		addps xmm1,xmm2
		addps xmm3,xmm4
		addps xmm1,xmm3
		addps xmm1,[rdx+784+64]
		movaps xmm7,xmm1
		andps xmm1, oword ptr sign_bits_f
		movaps xmm3,xmm0
		addps xmm1,oword ptr ones_f
		rcpps xmm1,xmm1
		mulps xmm7,xmm1
		pshufd xmm0,xmm0,0
		pshufd xmm1,xmm3,85
		pshufd xmm2,xmm3,170
		pshufd xmm3,xmm3,255
		mulps xmm0,[rdx+864]
		mulps xmm1,[rdx+864+16]
		mulps xmm2,[rdx+864+32]
		mulps xmm3,[rdx+864+48]
		pshufd xmm4,xmm7,0
		pshufd xmm5,xmm7,85
		pshufd xmm6,xmm7,170
		pshufd xmm7,xmm7,255
		mulps xmm4,[rdx+864+64]
		mulps xmm5,[rdx+864+80]
		mulps xmm6,[rdx+864+96]
		mulps xmm7,[rdx+864+112]
		addps xmm0,xmm1
		addps xmm2,xmm3
		addps xmm4,xmm5
		addps xmm6,xmm7
		addps xmm0,xmm2
		addps xmm4,xmm6
		addps xmm0,xmm4
		mov rcx,r8
		addps xmm0,[rdx+864+128]
		movhlps xmm1,xmm0
		maxps xmm0,xmm1
		pshuflw xmm1,xmm0,14
		comiss xmm1,xmm0
		jbe finish_1
		xor rax,rax
finish_1:
		mov BYTE PTR[rcx],al
		
	movdqu xmm7,oword ptr[rsp+16]
	movdqu xmm6,oword ptr[rsp]
	add rsp,32		
		
		ret

computeNetwork0_SSE2 endp


;computeNetwork0_i16_SSE2 proc inputf:dword,weightsf:dword,ptr_d:dword
; inputf = rcx
; weightsf = rdx
; ptr_d = r8

computeNetwork0_i16_SSE2 proc public frame

	sub rsp,32
	.allocstack 32
	movdqu oword ptr[rsp],xmm6
	.savexmm128 xmm6,0
	movdqu oword ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog

		mov rax,1
		movdqa xmm0,[rcx]
		movdqa xmm1,xmm0
		movdqa xmm2,xmm0
		movdqa xmm3,xmm0
		pmaddwd xmm0,[rdx]
		pmaddwd xmm1,[rdx+16]
		pmaddwd xmm2,[rdx+32]
		pmaddwd xmm3,[rdx+48]
		
		movdqa xmm4,[rcx+16]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[rdx+64]
		pmaddwd xmm5,[rdx+80]
		pmaddwd xmm6,[rdx+96]
		pmaddwd xmm7,[rdx+112]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[rcx+32]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[rdx+128]
		pmaddwd xmm5,[rdx+144]
		pmaddwd xmm6,[rdx+160]
		pmaddwd xmm7,[rdx+176]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[rcx+48]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[rdx+192]
		pmaddwd xmm5,[rdx+208]
		pmaddwd xmm6,[rdx+224]
		pmaddwd xmm7,[rdx+240]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[rcx+64]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[rdx+256]
		pmaddwd xmm5,[rdx+272]
		pmaddwd xmm6,[rdx+288]
		pmaddwd xmm7,[rdx+304]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[rcx+80]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[rdx+320]
		pmaddwd xmm5,[rdx+336]
		pmaddwd xmm6,[rdx+352]
		pmaddwd xmm7,[rdx+368]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,xmm0
		movdqa xmm5,xmm2
		punpcklqdq xmm0,xmm1
		punpcklqdq xmm2,xmm3
		punpckhqdq xmm4,xmm1
		punpckhqdq xmm5,xmm3
		paddd xmm0,xmm4
		paddd xmm2,xmm5
		movdqa xmm6,xmm0
		shufps xmm0,xmm2,136
		shufps xmm6,xmm2,221
		
		paddd xmm0,xmm6
		cvtdq2ps xmm0,xmm0
		mulps xmm0,[rdx+384]
		addps xmm0,[rdx+400]
		movaps xmm1,xmm0
		andps xmm0,oword ptr sign_bits_f_zero_l
		addps xmm0,oword ptr ones_f
		rcpps xmm0,xmm0
		mulps xmm0,xmm1
		pshufd xmm1,xmm0,0
		pshufd xmm2,xmm0,85
		pshufd xmm3,xmm0,170
		pshufd xmm4,xmm0,255
		mulps xmm1,[rdx+416]
		mulps xmm2,[rdx+416+16]
		mulps xmm3,[rdx+416+32]
		mulps xmm4,[rdx+416+48]
		addps xmm1,xmm2
		addps xmm3,xmm4
		addps xmm1,xmm3
		addps xmm1,[rdx+416+64]
		movaps xmm7,xmm1
		andps xmm1,oword ptr sign_bits_f
		movaps xmm3,xmm0
		addps xmm1,oword ptr ones_f
		rcpps xmm1,xmm1
		mulps xmm7,xmm1
		pshufd xmm0,xmm0,0
		pshufd xmm1,xmm3,85
		pshufd xmm2,xmm3,170
		pshufd xmm3,xmm3,255
		mulps xmm0,[rdx+496]
		mulps xmm1,[rdx+496+16]
		mulps xmm2,[rdx+496+32]
		mulps xmm3,[rdx+496+48]
		pshufd xmm4,xmm7,0
		pshufd xmm5,xmm7,85
		pshufd xmm6,xmm7,170
		pshufd xmm7,xmm7,255
		mulps xmm4,[rdx+496+64]
		mulps xmm5,[rdx+496+80]
		mulps xmm6,[rdx+496+96]
		mulps xmm7,[rdx+496+112]
		addps xmm0,xmm1
		addps xmm2,xmm3
		addps xmm4,xmm5
		addps xmm6,xmm7
		addps xmm0,xmm2
		addps xmm4,xmm6
		addps xmm0,xmm4
		mov rcx,r8
		addps xmm0,[rdx+496+128]
		movhlps xmm1,xmm0
		maxps xmm0,xmm1
		pshuflw xmm1,xmm0,14
		comiss xmm1,xmm0
		jbe finish_2
		xor rax,rax
finish_2:
		mov BYTE PTR[rcx],al
		
	movdqu xmm7,oword ptr[rsp+16]
	movdqu xmm6,oword ptr[rsp]
	add rsp,32		
		
		ret
		
computeNetwork0_i16_SSE2 endp



;uc2f48_SSE2 proc ptr_t:dword,pitch:dword,ptr_p:dword
; ptr_t = rcx
; pitch = edx
; ptr_p = r8

uc2f48_SSE2 proc public frame

	sub rsp,16
	.allocstack 16
	movdqu oword ptr[rsp],xmm6
	.savexmm128 xmm6,0
	.endprolog

		mov rax,rcx
		movsxd rcx,edx
		mov rdx,r8
		pxor xmm6,xmm6
		movq xmm0,QWORD PTR[rax]
		movd xmm4,dword  ptr[rax+8]
		movq xmm2,QWORD PTR[rax+rcx*2]
		movd xmm5,dword ptr[rax+rcx*2+8]
		punpcklbw xmm0,xmm6
		punpcklbw xmm4,xmm6
		punpcklbw xmm2,xmm6
		punpcklbw xmm5,xmm6
		movdqa xmm1,xmm0
		punpcklbw xmm4,xmm6
		movdqa xmm3,xmm2
		punpcklbw xmm5,xmm6
		punpcklbw xmm0,xmm6
		punpckhbw xmm1,xmm6
		punpcklbw xmm2,xmm6
		punpckhbw xmm3,xmm6
		lea rax,[rax+rcx*4]
		cvtdq2ps xmm4,xmm4
		cvtdq2ps xmm5,xmm5
		cvtdq2ps xmm0,xmm0
		cvtdq2ps xmm1,xmm1
		cvtdq2ps xmm2,xmm2
		cvtdq2ps xmm3,xmm3
		movaps [rdx],xmm0
		movaps [rdx+16],xmm1
		movaps [rdx+32],xmm4
		movaps [rdx+48],xmm2
		movaps [rdx+64],xmm3
		movaps [rdx+80],xmm5
		movq xmm0,QWORD PTR[rax]
		movd xmm4,dword ptr[rax+8]
		movq xmm2,QWORD PTR[rax+rcx*2]
		movd xmm5,dword ptr[rax+rcx*2+8]
		punpcklbw xmm0,xmm6
		punpcklbw xmm4,xmm6
		punpcklbw xmm2,xmm6
		punpcklbw xmm5,xmm6
		movdqa xmm1,xmm0
		punpcklbw xmm4,xmm6
		movdqa xmm3,xmm2
		punpcklbw xmm5,xmm6
		punpcklbw xmm0,xmm6
		punpckhbw xmm1,xmm6
		punpcklbw xmm2,xmm6
		punpckhbw xmm3,xmm6
		cvtdq2ps xmm4,xmm4
		cvtdq2ps xmm5,xmm5
		cvtdq2ps xmm0,xmm0
		cvtdq2ps xmm1,xmm1
		cvtdq2ps xmm2,xmm2
		cvtdq2ps xmm3,xmm3
		movaps [rdx+96],xmm0
		movaps [rdx+112],xmm1
		movaps [rdx+128],xmm4
		movaps [rdx+144],xmm2
		movaps [rdx+160],xmm3
		movaps [rdx+176],xmm5
		
	movdqu xmm6,oword ptr[rsp]
	add rsp,16				
		
		ret
		
uc2f48_SSE2 endp


;uc2f48_SSE2_16 proc ptr_t:dword,pitch:dword,ptr_p:dword
; ptr_t = rcx
; pitch = edx
; ptr_p = r8

uc2f48_SSE2_16 proc public frame

	sub rsp,16
	.allocstack 16
	movdqu oword ptr[rsp],xmm6
	.savexmm128 xmm6,0
	.endprolog

		mov rax,rcx
		movsxd rcx,edx
		mov rdx,r8
		pxor xmm6,xmm6
		
		movq xmm0,qword ptr[rax]
		movq xmm1,qword ptr[rax+8]
		movq xmm2,qword ptr[rax+16]
		movq xmm3,qword ptr[rax+rcx*2]
		movq xmm4,qword ptr[rax+rcx*2+8]
		movq xmm5,qword ptr[rax+rcx*2+16]
		punpcklwd xmm0,xmm6
		punpcklwd xmm1,xmm6
		punpcklwd xmm2,xmm6
		punpcklwd xmm3,xmm6
		punpcklwd xmm4,xmm6
		punpcklwd xmm5,xmm6
		
		lea rax,[rax+rcx*4]
		cvtdq2ps xmm0,xmm0
		cvtdq2ps xmm1,xmm1
		cvtdq2ps xmm2,xmm2
		cvtdq2ps xmm3,xmm3
		cvtdq2ps xmm4,xmm4
		cvtdq2ps xmm5,xmm5
		movaps [rdx],xmm0
		movaps [rdx+16],xmm1
		movaps [rdx+32],xmm2
		movaps [rdx+48],xmm3
		movaps [rdx+64],xmm4
		movaps [rdx+80],xmm5
		
		movq xmm0,qword ptr[rax]
		movq xmm1,qword ptr[rax+8]
		movq xmm2,qword ptr[rax+16]
		movq xmm3,qword ptr[rax+rcx*2]
		movq xmm4,qword ptr[rax+rcx*2+8]
		movq xmm5,qword ptr[rax+rcx*2+16]
		punpcklwd xmm0,xmm6
		punpcklwd xmm1,xmm6
		punpcklwd xmm2,xmm6
		punpcklwd xmm3,xmm6
		punpcklwd xmm4,xmm6
		punpcklwd xmm5,xmm6

		cvtdq2ps xmm0,xmm0
		cvtdq2ps xmm1,xmm1
		cvtdq2ps xmm2,xmm2
		cvtdq2ps xmm3,xmm3
		cvtdq2ps xmm4,xmm4
		cvtdq2ps xmm5,xmm5
		movaps [rdx+96],xmm0
		movaps [rdx+112],xmm1
		movaps [rdx+128],xmm2
		movaps [rdx+144],xmm3
		movaps [rdx+160],xmm4
		movaps [rdx+176],xmm5
		
	movdqu xmm6,oword ptr[rsp]
	add rsp,16				
		
		ret
		
uc2f48_SSE2_16 endp


;uc2s48_SSE2 proc ptr_t:dword,pitch:dword,ptr_pf:dword
; ptr_t = rcx
; pitch = edx
; ptr_pf = r8

uc2s48_SSE2 proc public frame

	sub rsp,32
	.allocstack 32
	movdqu oword ptr[rsp],xmm6
	.savexmm128 xmm6,0
	movdqu oword ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog

		mov rax,rcx
		movsxd rcx,edx
		lea rdx,[rax+rcx*4]
		movq xmm0,QWORD PTR[rax]
		movd xmm1,dword ptr[rax+8]
		movd xmm2,dword ptr[rax+rcx*2]
		movq xmm3,QWORD PTR[rax+rcx*2+4]
		movq xmm4,QWORD PTR[rdx]
		movd xmm5,dword ptr[rdx+8]
		movd xmm6,dword ptr[rdx+rcx*2]
		movq xmm7,QWORD PTR[rdx+rcx*2+4]
		punpckldq xmm1,xmm2
		pxor xmm2,xmm2
		punpckldq xmm5,xmm6
		mov rdx,r8
		punpcklbw xmm0,xmm2
		punpcklbw xmm3,xmm2
		punpcklbw xmm1,xmm2
		punpcklbw xmm4,xmm2
		punpcklbw xmm5,xmm2
		punpcklbw xmm7,xmm2
		movdqa [rdx],xmm0
		movdqa [rdx+16],xmm1
		movdqa [rdx+32],xmm3
		movdqa [rdx+48],xmm4
		movdqa [rdx+64],xmm5
		movdqa [rdx+80],xmm7
		
	movdqu xmm7,oword ptr[rsp+16]
	movdqu xmm6,oword ptr[rsp]
	add rsp,32				
		
		ret

uc2s48_SSE2 endp


;processLine0_SSE2_ASM proc tempu:dword,width_:dword,dstp:dword,src3p:dword,src_pitch:dword,val_min:word,val_max:word
; tempu = rcx
; width_ = edx
; dstp = r8
; src3p = r9

processLine0_SSE2_ASM proc public frame

src_pitch equ dword ptr[rbp+48]
val_min equ word ptr[rbp+56]
val_max equ word ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rbx
	.pushreg rbx
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	sub rsp,128
	.allocstack 128
	movdqu oword ptr[rsp],xmm6
	.savexmm128 xmm6,0
	movdqu oword ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	movdqu oword ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	movdqu oword ptr[rsp+48],xmm9
	.savexmm128 xmm9,48
	movdqu oword ptr[rsp+64],xmm10
	.savexmm128 xmm10,64
	movdqu oword ptr[rsp+80],xmm11
	.savexmm128 xmm11,80
	movdqu oword ptr[rsp+96],xmm12
	.savexmm128 xmm12,96
	movdqu oword ptr[rsp+112],xmm13
	.savexmm128 xmm13,112
	.endprolog

		movzx eax,val_max
		pinsrw xmm12,eax,0
		pinsrw xmm12,eax,1
		pinsrw xmm12,eax,2
		pinsrw xmm12,eax,3
		pinsrw xmm12,eax,4
		pinsrw xmm12,eax,5
		pinsrw xmm12,eax,6
		pinsrw xmm12,eax,7
	
		movzx eax,val_min
		pinsrw xmm13,eax,0
		pinsrw xmm13,eax,1
		pinsrw xmm13,eax,2
		pinsrw xmm13,eax,3
		pinsrw xmm13,eax,4
		pinsrw xmm13,eax,5
		pinsrw xmm13,eax,6
		pinsrw xmm13,eax,7
	
		mov rax,rcx
		mov rbx,r9
		xor rcx,rcx
		mov ecx,edx
		movsxd rdx,src_pitch
		mov rsi,r8
		mov r8,16
		
		lea rdi,[rbx+rdx*4]
		pxor xmm6,xmm6
		pxor xmm7,xmm7
		movdqa xmm8,oword ptr w_19
		movdqa xmm9,oword ptr w_3
		movdqa xmm10,oword ptr ub_1
		movdqa xmm11,oword ptr uw_16
xloop:
		movdqa xmm0,[rbx+rdx*2]
		movdqa xmm1,[rdi]
		movdqa xmm2,xmm0
		movdqa xmm3,xmm1
		punpcklbw xmm0,xmm7
		punpckhbw xmm2,xmm7
		punpcklbw xmm1,xmm7
		punpckhbw xmm3,xmm7
		paddw xmm0,xmm1
		paddw xmm2,xmm3
		pmullw xmm0,xmm8
		pmullw xmm2,xmm8
		movdqa xmm1,[rbx]
		movdqa xmm3,[rdi+rdx*2]
		movdqa xmm4,xmm1
		movdqa xmm5,xmm3
		punpcklbw xmm1,xmm7
		punpckhbw xmm4,xmm7
		punpcklbw xmm3,xmm7
		punpckhbw xmm5,xmm7
		paddw xmm1,xmm3
		paddw xmm4,xmm5
		pmullw xmm1,xmm9
		pmullw xmm4,xmm9
		movdqa xmm5,[rax]
		psubusw xmm0,xmm1
		psubusw xmm2,xmm4
		pxor xmm5,xmm10
		paddusw xmm0,xmm11
		paddusw xmm2,xmm11
		psadbw xmm5,xmm7		
		psraw xmm0,5
		psraw xmm2,5
		movdqa xmm3,xmm5
		pminsw xmm0,xmm12
		pminsw xmm2,xmm12
		psrldq xmm5,8
		pmaxsw xmm0,xmm13
		pmaxsw xmm2,xmm13
		paddusw xmm5,xmm3
		packuswb xmm0,xmm2
		movdqa [rsi],xmm0
		paddusw xmm6,xmm5
		add rbx,r8
		add rdi,r8
		add rax,r8
		add rsi,r8
		sub rcx,r8
		jnz xloop
		
		xor  rax,rax
		movd eax,xmm6
		
	movdqu xmm13,oword ptr[rsp+112]
	movdqu xmm12,oword ptr[rsp+96]
	movdqu xmm11,oword ptr[rsp+80]
	movdqu xmm10,oword ptr[rsp+64]
	movdqu xmm9,oword ptr[rsp+48]
	movdqu xmm8,oword ptr[rsp+32]
	movdqu xmm7,oword ptr[rsp+16]
	movdqu xmm6,oword ptr[rsp]	
	add rsp,128
	pop rdi
	pop rsi
	pop rbx
	pop rbp
			
		ret
		
processLine0_SSE2_ASM endp


;processLine0_SSE2_ASM_16 proc tempu:dword,width_:dword,dstp:dword,src3p:dword,src_pitch:dword,val_min:word,val_max:word
; tempu = rcx
; width_ = edx
; dstp = r8
; src3p = r9

processLine0_SSE2_ASM_16 proc public frame

src_pitch equ dword ptr[rbp+48]
val_min equ word ptr[rbp+56]
val_max equ word ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rbx
	.pushreg rbx
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	sub rsp,128
	.allocstack 128
	movdqu oword ptr[rsp],xmm6
	.savexmm128 xmm6,0
	movdqu oword ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	movdqu oword ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	movdqu oword ptr[rsp+48],xmm9
	.savexmm128 xmm9,48
	movdqu oword ptr[rsp+64],xmm10
	.savexmm128 xmm10,64
	movdqu oword ptr[rsp+80],xmm11
	.savexmm128 xmm11,80
	movdqu oword ptr[rsp+96],xmm12
	.savexmm128 xmm12,96
	movdqu oword ptr[rsp+112],xmm13
	.savexmm128 xmm13,112
	.endprolog

		movzx eax,val_max
		pinsrw xmm12,eax,0
		pinsrw xmm12,eax,1
		pinsrw xmm12,eax,2
		pinsrw xmm12,eax,3
		pinsrw xmm12,eax,4
		pinsrw xmm12,eax,5
		pinsrw xmm12,eax,6
		pinsrw xmm12,eax,7
		
		movzx eax,val_min
		pinsrw xmm13,eax,0
		pinsrw xmm13,eax,1
		pinsrw xmm13,eax,2
		pinsrw xmm13,eax,3
		pinsrw xmm13,eax,4
		pinsrw xmm13,eax,5
		pinsrw xmm13,eax,6
		pinsrw xmm13,eax,7		
	
		mov rax,rcx
		mov rbx,r9
		xor rcx,rcx
		mov ecx,edx
		movsxd rdx,src_pitch
		mov rsi,r8
		mov r8,16
		mov r9,8
		
		lea rdi,[rbx+rdx*4]
		pxor xmm6,xmm6
		pxor xmm7,xmm7
		movdqa xmm8,oword ptr d_19
		movdqa xmm9,oword ptr d_3
		movdqa xmm10,oword ptr uw_1
		movdqa xmm11,oword ptr ud_16
		
xloop_16:
		movdqa xmm0,[rbx+rdx*2]
		movdqa xmm1,[rdi]
		movdqa xmm2,xmm0
		movdqa xmm3,xmm1
		punpcklwd xmm0,xmm7
		punpckhwd xmm2,xmm7
		punpcklwd xmm1,xmm7
		punpckhwd xmm3,xmm7
		paddd xmm0,xmm1
		paddd xmm2,xmm3
		pmulld xmm0,xmm8
		pmulld xmm2,xmm8
		movdqa xmm1,[rbx]
		movdqa xmm3,[rdi+rdx*2]
		movdqa xmm4,xmm1
		movdqa xmm5,xmm3
		punpcklwd xmm1,xmm7
		punpckhwd xmm4,xmm7
		punpcklwd xmm3,xmm7
		punpckhwd xmm5,xmm7
		paddd xmm1,xmm3
		paddd xmm4,xmm5
		pmulld xmm1,xmm9
		pmulld xmm4,xmm9
		movq xmm5,qword ptr [rax]
		psubd xmm0,xmm1
		punpcklbw xmm5,xmm7
		psubd xmm2,xmm4
		pxor xmm5,xmm10
		paddd xmm0,xmm11
		paddd xmm2,xmm11
		psadbw xmm5,xmm7		
		psrad xmm0,5
		psrad xmm2,5
		movdqa xmm3,xmm5		
		packusdw xmm0,xmm2
		psrldq xmm5,8
		pminuw xmm0,xmm12
		pmaxuw xmm0,xmm13
		paddusw xmm5,xmm3
		movdqa [rsi],xmm0
		paddusw xmm6,xmm5
		add rbx,r8
		add rdi,r8
		add rax,r9
		add rsi,r8
		sub rcx,r9
		jnz xloop_16
		
		xor  rax,rax
		movd eax,xmm6
		
	movdqu xmm13,oword ptr[rsp+112]
	movdqu xmm12,oword ptr[rsp+96]
	movdqu xmm11,oword ptr[rsp+80]
	movdqu xmm10,oword ptr[rsp+64]
	movdqu xmm9,oword ptr[rsp+48]
	movdqu xmm8,oword ptr[rsp+32]
	movdqu xmm7,oword ptr[rsp+16]
	movdqu xmm6,oword ptr[rsp]	
	add rsp,128
	pop rdi
	pop rsi
	pop rbx
	pop rbp
			
		ret
		
processLine0_SSE2_ASM_16 endp


;processLine0_SSE2_ASM_32 proc tempu:dword,width_:dword,dstp:dword,src3p:dword,src_pitch:dword
; tempu = rcx
; width_ = edx
; dstp = r8
; src3p = r9

processLine0_SSE2_ASM_32 proc public frame

src_pitch equ dword ptr[rbp+48]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rbx
	.pushreg rbx
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	sub rsp,64
	.allocstack 64
	movdqu oword ptr[rsp],xmm6
	.savexmm128 xmm6,0
	movdqu oword ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	movdqu oword ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	movdqu oword ptr[rsp+48],xmm9
	.savexmm128 xmm9,48
	.endprolog

		mov rax,rcx
		mov rbx,r9
		xor rcx,rcx
		mov ecx,edx
		movsxd rdx,src_pitch
		mov rsi,r8
		mov r8,16
		mov r9,4
		
		lea rdi,[rbx+rdx*4]
		pxor xmm5,xmm5
		pxor xmm6,xmm6
		movaps xmm7,oword ptr f_19
		movaps xmm8,oword ptr f_3
		movdqa xmm9,oword ptr dw_1
		
xloop_32:
		movd xmm4,dword ptr [rax]
		movaps xmm2,[rbx]
		movaps xmm0,[rbx+rdx*2]
		punpcklbw xmm4,xmm6
		movaps xmm1,[rdi]
		movaps xmm3,[rdi+rdx*2]
		punpcklwd xmm4,xmm6
		addps xmm0,xmm1
		pxor xmm4,xmm9
		addps xmm2,xmm3
		psadbw xmm4,xmm6
		mulps xmm0,xmm7
		movdqa xmm3,xmm4
		mulps xmm2,xmm8
		psrldq xmm4,8
		subps xmm0,xmm2		
		paddusw xmm4,xmm3
		movaps [rsi],xmm0
		paddusw xmm5,xmm4
		
		add rbx,r8
		add rdi,r8
		add rax,r9
		add rsi,r8
		sub rcx,r9
		jnz xloop_32
		
		xor  rax,rax
		movd eax,xmm5
		
	movdqu xmm9,oword ptr[rsp+48]
	movdqu xmm8,oword ptr[rsp+32]
	movdqu xmm7,oword ptr[rsp+16]
	movdqu xmm6,oword ptr[rsp]	
	add rsp,64
	pop rdi
	pop rsi
	pop rbx
	pop rbp
			
		ret
		
processLine0_SSE2_ASM_32 endp


;extract_m8_SSE2 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,input:dword
; srcp = rcx
; stride = edx
; xdia = r8d
; ydia = r9d

extract_m8_SSE2 proc public frame
	
mstd equ qword ptr[rbp+48]
input equ qword ptr[rbp+56]

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
	sub rsp,32
	.allocstack 32
	movdqa oword ptr[rsp],xmm6
	.savexmm128 xmm6,0
	movdqa oword ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog
		
		mov rax,rcx
		movsxd rbx,edx
		xor rdi,rdi
		mov edi,r8d
		mov rsi,input
		xor r8,r8
		mov r8d,r9d
		mov r10,2
		mov r11,8
		mov r12,32
				
		lea rdx,[rax+rbx*2]
		pxor xmm5,xmm5
		pxor xmm6,xmm6
		pxor xmm3,xmm3
yloop2:
		xor rcx,rcx
xloop2:
		movq xmm0,QWORD PTR[rax+rcx]
		movq xmm2,QWORD PTR[rdx+rcx]
		punpcklbw xmm0,xmm3
		punpcklbw xmm2,xmm3
		movdqa xmm1,xmm0
		movdqa xmm4,xmm2
		punpcklwd xmm0,xmm3
		punpckhwd xmm1,xmm3
		punpcklwd xmm2,xmm3
		punpckhwd xmm4,xmm3
		cvtdq2ps xmm0,xmm0
		cvtdq2ps xmm1,xmm1
		cvtdq2ps xmm2,xmm2
		cvtdq2ps xmm4,xmm4
		movaps [rsi],xmm0
		movaps [rsi+16],xmm1
		movaps [rsi+rdi*4],xmm2
		movaps [rsi+rdi*4+16],xmm4
		addps xmm5,xmm0
		addps xmm5,xmm1
		addps xmm5,xmm2
		addps xmm5,xmm4
		mulps xmm0,xmm0
		mulps xmm1,xmm1
		mulps xmm2,xmm2
		mulps xmm4,xmm4
		addps xmm0,xmm1
		addps xmm2,xmm4
		addps xmm6,xmm0
		addps xmm6,xmm2
		add rcx,r11
		add rsi,r12
		cmp rcx,rdi
		jl xloop2
		lea rax,[rax+rbx*4]
		lea rdx,[rdx+rbx*4]
		lea rsi,[rsi+rdi*4]
		sub r8d,r10d
		jnz yloop2
		mov eax,r9d
		movhlps xmm0,xmm5
		movhlps xmm1,xmm6
		mul edi
		addps xmm5,xmm0
		addps xmm6,xmm1
		cvtsi2ss xmm7,eax
		pshuflw xmm0,xmm5,14
		pshuflw xmm1,xmm6,14
		rcpss xmm7,xmm7
		addss xmm5,xmm0
		addss xmm6,xmm1
		mov rax,mstd
		mulss xmm5,xmm7
		mulss xmm6,xmm7
		movss dword ptr[rax],xmm5
		mulss xmm5,xmm5
		subss xmm6,xmm5
		comiss xmm6,dword ptr flt_epsilon_sse
		jbe novarjmp
		rsqrtss xmm6,xmm6
		rcpss xmm5,xmm6
		movss dword ptr[rax+4],xmm5
		movss dword ptr[rax+8],xmm6
		jmp finish_3
novarjmp:
		movss dword ptr[rax+4],xmm3
		movss dword ptr[rax+8],xmm3
finish_3:
		movss dword ptr[rax+12],xmm3
		
	movdqa xmm7,oword ptr[rsp+16]
	movdqa xmm6,oword ptr[rsp]	
	add rsp,32	
		
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp
		
		ret
		
extract_m8_SSE2 endp



;extract_m8_SSE2_16 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,input:dword
; srcp = rcx
; stride = edx
; xdia = r8d
; ydia = r9d

extract_m8_SSE2_16 proc public frame
	
mstd equ qword ptr[rbp+48]
input equ qword ptr[rbp+56]

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
	sub rsp,32
	.allocstack 32
	movdqa oword ptr[rsp],xmm6
	.savexmm128 xmm6,0
	movdqa oword ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog
		
		mov rax,rcx
		movsxd rbx,edx
		xor rdi,rdi
		mov edi,r8d
		mov rsi,input
		xor r8,r8
		mov r8d,r9d
		mov r10,2
		mov r11,8
		mov r12,32
				
		lea rdx,[rax+rbx*2]
		pxor xmm5,xmm5
		pxor xmm6,xmm6
		pxor xmm3,xmm3
		
yloop2_16:
		xor rcx,rcx
xloop2_16:
		movlps xmm0,QWORD PTR[rax+2*rcx]
		movhps xmm0,QWORD PTR[rax+2*rcx+8]
		movlps xmm2,QWORD PTR[rdx+2*rcx]
		movhps xmm2,QWORD PTR[rdx+2*rcx+8]

		movdqa xmm1,xmm0
		movdqa xmm4,xmm2		
		punpcklwd xmm0,xmm3
		punpckhwd xmm1,xmm3
		punpcklwd xmm2,xmm3
		punpckhwd xmm4,xmm3
		cvtdq2ps xmm0,xmm0
		cvtdq2ps xmm1,xmm1
		cvtdq2ps xmm2,xmm2
		cvtdq2ps xmm4,xmm4
		movaps [rsi],xmm0
		movaps [rsi+16],xmm1
		movaps [rsi+rdi*4],xmm2
		movaps [rsi+rdi*4+16],xmm4
		addps xmm5,xmm0
		addps xmm5,xmm1
		addps xmm5,xmm2
		addps xmm5,xmm4
		mulps xmm0,xmm0
		mulps xmm1,xmm1
		mulps xmm2,xmm2
		mulps xmm4,xmm4
		addps xmm0,xmm1
		addps xmm2,xmm4
		addps xmm6,xmm0
		addps xmm6,xmm2
		add rcx,r11
		add rsi,r12
		cmp rcx,rdi
		jl xloop2_16
		lea rax,[rax+rbx*4]
		lea rdx,[rdx+rbx*4]
		lea rsi,[rsi+rdi*4]
		sub r8d,r10d
		jnz yloop2_16
		
		mov eax,r9d
		movhlps xmm0,xmm5
		movhlps xmm1,xmm6
		mul edi
		addps xmm5,xmm0
		addps xmm6,xmm1
		cvtsi2ss xmm7,eax
		pshuflw xmm0,xmm5,14
		pshuflw xmm1,xmm6,14
		rcpss xmm7,xmm7
		addss xmm5,xmm0
		addss xmm6,xmm1
		mov rax,mstd
		mulss xmm5,xmm7
		mulss xmm6,xmm7
		movss dword ptr[rax],xmm5
		mulss xmm5,xmm5
		subss xmm6,xmm5
		comiss xmm6,dword ptr flt_epsilon_sse
		jbe novarjmp_16
		rsqrtss xmm6,xmm6
		rcpss xmm5,xmm6
		movss dword ptr[rax+4],xmm5
		movss dword ptr[rax+8],xmm6
		jmp finish_3_16
novarjmp_16:
		movss dword ptr[rax+4],xmm3
		movss dword ptr[rax+8],xmm3
finish_3_16:
		movss dword ptr[rax+12],xmm3
		
	movdqa xmm7,oword ptr[rsp+16]
	movdqa xmm6,oword ptr[rsp]	
	add rsp,32	
		
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp
		
		ret
		
extract_m8_SSE2_16 endp



;extract_m8_SSE2_32 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,input:dword
; srcp = rcx
; stride = edx
; xdia = r8d
; ydia = r9d

extract_m8_SSE2_32 proc public frame
	
mstd equ qword ptr[rbp+48]
input equ qword ptr[rbp+56]

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
	sub rsp,32
	.allocstack 32
	movdqa oword ptr[rsp],xmm6
	.savexmm128 xmm6,0
	movdqa oword ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog
		
		mov rax,rcx
		movsxd rbx,edx
		xor rdi,rdi
		mov edi,r8d
		mov rsi,input
		xor r8,r8
		mov r8d,r9d
		mov r10,2
		mov r11,4
		mov r12,16
				
		lea rdx,[rax+rbx*2]
		pxor xmm5,xmm5
		pxor xmm6,xmm6
		pxor xmm3,xmm3
		
yloop2_32:
		xor rcx,rcx
xloop2_32:
		movlps xmm0,QWORD PTR[rax+4*rcx]
		movhps xmm0,QWORD PTR[rax+4*rcx+8]
		movlps xmm2,QWORD PTR[rdx+4*rcx]
		movhps xmm2,QWORD PTR[rdx+4*rcx+8]
		
		movaps [rsi],xmm0
		movaps [rsi+rdi*4],xmm2
		addps xmm5,xmm0
		addps xmm5,xmm2
		mulps xmm0,xmm0
		mulps xmm2,xmm2
		addps xmm6,xmm0
		addps xmm6,xmm2
		add rcx,r11
		add rsi,r12
		cmp rcx,rdi
		jl xloop2_32
		lea rax,[rax+rbx*4]
		lea rdx,[rdx+rbx*4]
		lea rsi,[rsi+rdi*4]
		sub r8d,r10d
		jnz yloop2_32
		
		mov eax,r9d
		movhlps xmm0,xmm5
		movhlps xmm1,xmm6
		mul edi
		addps xmm5,xmm0
		addps xmm6,xmm1
		cvtsi2ss xmm7,eax
		pshuflw xmm0,xmm5,14
		pshuflw xmm1,xmm6,14
		rcpss xmm7,xmm7
		addss xmm5,xmm0
		addss xmm6,xmm1
		mov rax,mstd
		mulss xmm5,xmm7
		mulss xmm6,xmm7
		movss dword ptr[rax],xmm5
		mulss xmm5,xmm5
		subss xmm6,xmm5
		comiss xmm6,dword ptr flt_epsilon_sse
		jbe novarjmp_32
		rsqrtss xmm6,xmm6
		rcpss xmm5,xmm6
		movss dword ptr[rax+4],xmm5
		movss dword ptr[rax+8],xmm6
		jmp finish_3_32
novarjmp_32:
		movss dword ptr[rax+4],xmm3
		movss dword ptr[rax+8],xmm3
finish_3_32:
		movss dword ptr[rax+12],xmm3
		
	movdqa xmm7,oword ptr[rsp+16]
	movdqa xmm6,oword ptr[rsp]	
	add rsp,32	
		
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp
		
		ret
		
extract_m8_SSE2_32 endp



;extract_m8_i16_SSE2 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,inputf:dword
; srcp = rcx
; stride = edx
; xdia = r8d
; ydia = r9d

extract_m8_i16_SSE2 proc public frame

mstd equ qword ptr[rbp+48]
inputf equ qword ptr[rbp+56]

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
	sub rsp,32
	.allocstack 32
	movdqa oword ptr[rsp],xmm6
	.savexmm128 xmm6,0
	movdqa oword ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog
		
		mov rax,rcx
		movsxd rbx,edx
		xor rdi,rdi
		mov edi,r8d
		mov rdx,inputf
		xor r8,r8
		mov r8d,r9d
		mov r10,2
		mov r11,8
		mov r12,16
			
		lea rsi,[rax+rbx*2]
		pxor xmm4,xmm4
		pxor xmm5,xmm5
		pxor xmm6,xmm6
yloop:
		xor rcx,rcx
xloop_2:
		movq xmm0,QWORD PTR[rax+rcx]
		movq xmm1,QWORD PTR[rsi+rcx]
		movdqa xmm2,xmm0
		movdqa xmm3,xmm1
		punpcklbw xmm0,xmm6
		punpcklbw xmm1,xmm6
		psadbw xmm2,xmm6
		psadbw xmm3,xmm6
		movdqa [rdx],xmm0
		movdqa [rdx+rdi*2],xmm1
		pmaddwd xmm0,xmm0
		pmaddwd xmm1,xmm1
		paddd xmm4,xmm2
		paddd xmm5,xmm0
		paddd xmm4,xmm3
		paddd xmm5,xmm1
		add rcx,r11
		add rdx,r12
		cmp rcx,rdi
		jl xloop_2
		lea rax,[rax+rbx*4]
		lea rsi,[rsi+rbx*4]
		lea rdx,[rdx+rdi*2]
		sub r8d,r10d
		jnz yloop
		movhlps xmm1,xmm5
		mov eax,r9d
		paddd xmm5,xmm1
		mul edi
		pshuflw xmm1,xmm5,14
		cvtsi2ss xmm7,eax
		paddd xmm5,xmm1
		rcpss xmm7,xmm7
		cvtdq2ps xmm4,xmm4
		cvtdq2ps xmm5,xmm5
		mov rax,mstd
		mulss xmm4,xmm7
		mulss xmm5,xmm7
		movss dword ptr[rax],xmm4
		mulss xmm4,xmm4
		subss xmm5,xmm4
		comiss xmm5,dword ptr flt_epsilon_sse
		jbe novarjmp_2
		rsqrtss xmm5,xmm5
		rcpss xmm4,xmm5
		movss dword ptr[rax+4],xmm4
		movss dword ptr[rax+8],xmm5
		jmp finish_4
novarjmp_2:
		movss dword ptr[rax+4],xmm6
		movss dword ptr[rax+8],xmm6
finish_4:
		movss dword ptr[rax+12],xmm6
		
	movdqa xmm7,oword ptr[rsp+16]
	movdqa xmm6,oword ptr[rsp]	
	add rsp,32	
		
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp
		
		ret
		
extract_m8_i16_SSE2 endp


;extract_m8_i16_SSE2_16 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,inputf:dword
; srcp = rcx
; stride = edx
; xdia = r8d
; ydia = r9d

extract_m8_i16_SSE2_16 proc public frame

mstd equ qword ptr[rbp+48]
inputf equ qword ptr[rbp+56]

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
	sub rsp,48
	.allocstack 48
	movdqa oword ptr[rsp],xmm6
	.savexmm128 xmm6,0
	movdqa oword ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	movdqa oword ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	.endprolog
		
		mov rax,rcx
		movsxd rbx,edx
		xor rdi,rdi
		mov edi,r8d
		mov rdx,inputf
		xor r8,r8
		mov r8d,r9d
		mov r10,2
		mov r11,8
		mov r12,16
			
		lea rsi,[rax+rbx*2]
		pxor xmm4,xmm4
		pxor xmm5,xmm5
		pxor xmm6,xmm6		
		movdqa xmm8,oword ptr uw_1
		
yloop_16:
		xor rcx,rcx
xloop_2_16:
		movlps xmm0,QWORD PTR[rax+2*rcx]
		movhps xmm0,QWORD PTR[rax+2*rcx+8]
		movlps xmm1,QWORD PTR[rsi+2*rcx]
		movhps xmm1,QWORD PTR[rsi+2*rcx+8]
		
		movdqa oword ptr [rdx],xmm0
		movdqa oword ptr [rdx+rdi*2],xmm1
		
		movdqa xmm2,xmm0
		movdqa xmm3,xmm1

		pmaddwd xmm2,xmm8
		pmaddwd xmm3,xmm8
		
		pmaddwd xmm0,xmm0
		pmaddwd xmm1,xmm1
		
		paddd xmm4,xmm2
		paddd xmm5,xmm0
		paddd xmm4,xmm3
		paddd xmm5,xmm1		
		add rcx,r11
		add rdx,r12
		cmp rcx,rdi
		jl xloop_2_16
		lea rax,[rax+rbx*4]
		lea rsi,[rsi+rbx*4]
		lea rdx,[rdx+rdi*2]
		sub r8d,r10d
		jnz yloop_16
		
		movhlps xmm1,xmm5
		movhlps xmm2,xmm4
		mov eax,r9d
		paddd xmm5,xmm1
		paddd xmm4,xmm2
		mul edi
				
		pshufd xmm1,xmm5,1
		pshufd xmm2,xmm4,1

		cvtsi2ss xmm7,eax
		
		paddd xmm5,xmm1
		paddd xmm4,xmm2
		
		rcpss xmm7,xmm7
		cvtdq2ps xmm4,xmm4
		cvtdq2ps xmm5,xmm5
		mov rax,mstd
		mulss xmm4,xmm7
		mulss xmm5,xmm7
		movss dword ptr[rax],xmm4
		mulss xmm4,xmm4
		subss xmm5,xmm4
		comiss xmm5,dword ptr flt_epsilon_sse
		jbe novarjmp_2_16
		rsqrtss xmm5,xmm5
		rcpss xmm4,xmm5
		movss dword ptr[rax+4],xmm4
		movss dword ptr[rax+8],xmm5
		jmp finish_4_16
novarjmp_2_16:
		movss dword ptr[rax+4],xmm6
		movss dword ptr[rax+8],xmm6
finish_4_16:
		movss dword ptr[rax+12],xmm6
		
	movdqa xmm8,oword ptr[rsp+32]
	movdqa xmm7,oword ptr[rsp+16]
	movdqa xmm6,oword ptr[rsp]	
	add rsp,48
		
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp
		
		ret
		
extract_m8_i16_SSE2_16 endp


;extract_m8_i16_SSE2_16_2 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,inputf:dword,sum:dword,sumsq:dword
; srcp = rcx
; stride = edx
; xdia = r8d
; ydia = r9d

extract_m8_i16_SSE2_16_2 proc public frame

inputf equ qword ptr[rbp+48]
sum equ qword ptr[rbp+56]
sumsq equ qword ptr[rbp+64]

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
	sub rsp,32
	.allocstack 32
	movdqa oword ptr[rsp],xmm6
	.savexmm128 xmm6,0
	movdqa oword ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog
		
		mov rax,rcx
		movsxd rbx,edx
		xor rdi,rdi
		mov edi,r8d
		mov rdx,inputf
		xor r8,r8
		mov r8d,r9d
		mov r10,2
		mov r11,4
		mov r12,8
			
		lea rsi,[rax+rbx*2]
		pxor xmm4,xmm4
		pxor xmm5,xmm5
		pxor xmm6,xmm6		
		movdqa xmm7,oword ptr uw_1
		
yloop_16_2:
		xor rcx,rcx
xloop_2_16_2:
		movq xmm0,QWORD PTR[rax+2*rcx]
		movq xmm1,QWORD PTR[rsi+2*rcx]
		
		movq qword ptr [rdx],xmm0
		movq qword ptr [rdx+rdi*2],xmm1
		
		movdqa xmm2,xmm0
		movdqa xmm3,xmm1

		pmaddwd xmm2,xmm7
		pmaddwd xmm3,xmm7
		
		paddd xmm4,xmm2
	
		punpcklwd xmm0,xmm6
		punpcklwd xmm1,xmm6
		
		paddd xmm4,xmm3
					
		pmulld xmm0,xmm0
		pmulld xmm1,xmm1
		movhlps xmm2,xmm0
		movhlps xmm3,xmm1
		punpckldq xmm0,xmm6
		punpckldq xmm1,xmm6
		punpckldq xmm2,xmm6
		punpckldq xmm3,xmm6
		paddq xmm0,xmm2
		paddq xmm1,xmm3
		
		paddq xmm5,xmm0
		movhlps xmm2,xmm0
		paddq xmm5,xmm1
		movhlps xmm3,xmm1
		paddq xmm5,xmm2
		paddq xmm5,xmm3		
		
		add rcx,r11
		add rdx,r12
		cmp rcx,rdi
		jl xloop_2_16_2
		lea rax,[rax+rbx*4]
		lea rsi,[rsi+rbx*4]
		lea rdx,[rdx+rdi*2]
		sub r8d,r10d
		jnz yloop_16_2
		
		movhlps xmm2,xmm4
		mov rax,sum
		paddd xmm4,xmm2
		mov rbx,sumsq
		pshufd xmm2,xmm4,1
		movq qword ptr [rbx],xmm5		
		paddd xmm4,xmm2
		movd dword ptr [rax],xmm4
		
	movdqa xmm7,oword ptr[rsp+16]
	movdqa xmm6,oword ptr[rsp]	
	add rsp,32
		
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp
		
		ret
		
extract_m8_i16_SSE2_16_2 endp


;dotProd_m32_m16_SSE2 proc data_:dword,weights:dword,vals:dword,n:dword,len:dword,istd:dword
; data_ = rcx
; weights = rdx
; vals = r8
; n = r9d

dotProd_m32_m16_SSE2 proc public frame

len equ dword ptr[rbp+48]
istd equ qword ptr[rbp+56]

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
	sub rsp,32
	.allocstack 32
	movdqu oword ptr[rsp],xmm6
	.savexmm128 xmm6,0
	movdqu oword ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog
		
		mov rdi,rdx
		mov rax,r8
		xor rbx,rbx
		mov ebx,r9d
		xor rsi,rsi
		mov esi,len
		mov r15,rcx
		
		mov r10,4
		mov r11,16
		mov r12,32
		mov r13,128
		mov r14,512
nloop:
		mov rcx,r15
		xorps xmm0,xmm0
		xorps xmm1,xmm1
		xorps xmm2,xmm2
		xorps xmm3,xmm3
		mov rdx,rsi
lloop:
		movaps xmm4,[rcx]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[rdi]
		mulps xmm5,[rdi+r11]
		mulps xmm6,[rdi+r12]
		mulps xmm7,[rdi+48]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[rcx+r11]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[rdi+2*r12]
		mulps xmm5,[rdi+80]
		mulps xmm6,[rdi+96]
		mulps xmm7,[rdi+112]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[rcx+r12]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[rdi+r13]
		mulps xmm5,[rdi+144]
		mulps xmm6,[rdi+160]
		mulps xmm7,[rdi+176]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[rcx+48]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[rdi+192]
		mulps xmm5,[rdi+208]
		mulps xmm6,[rdi+224]
		mulps xmm7,[rdi+240]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[rcx+2*r12]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[rdi+2*r13]
		mulps xmm5,[rdi+272]
		mulps xmm6,[rdi+288]
		mulps xmm7,[rdi+304]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[rcx+80]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[rdi+320]
		mulps xmm5,[rdi+336]
		mulps xmm6,[rdi+352]
		mulps xmm7,[rdi+368]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[rcx+96]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[rdi+384]
		mulps xmm5,[rdi+400]
		mulps xmm6,[rdi+416]
		mulps xmm7,[rdi+432]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[rcx+112]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[rdi+448]
		mulps xmm5,[rdi+464]
		mulps xmm6,[rdi+480]
		mulps xmm7,[rdi+496]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		add rcx,r13
		add rdi,r14
		sub rdx,r12
		jnz lloop
		movaps xmm4,xmm0
		movaps xmm5,xmm2
		unpcklpd xmm0,xmm1
		unpcklpd xmm2,xmm3
		unpckhpd xmm4,xmm1
		unpckhpd xmm5,xmm3
		addps xmm0,xmm4
		addps xmm2,xmm5
		movaps xmm6,xmm0
		shufps xmm0,xmm2,136
		shufps xmm6,xmm2,221
		addps xmm6,xmm0
		movaps [rax],xmm6
		add rax,r11
		sub rbx,r10
		jnz nloop
		mov rcx,istd
		mov rax,r8
		movss xmm7,dword ptr[rcx]
		xor rdx,rdx
		mov edx,r9d
		shufps xmm7,xmm7,0
		xor rcx,rcx
aloop:
		movaps xmm0,[rax+rcx*4]
		movaps xmm1,[rax+rcx*4+16]
		movaps xmm2,[rax+rcx*4+32]
		movaps xmm3,[rax+rcx*4+48]
		mulps xmm0,xmm7
		mulps xmm1,xmm7
		mulps xmm2,xmm7
		mulps xmm3,xmm7
		addps xmm0,[rdi+rcx*4]
		addps xmm1,[rdi+rcx*4+16]
		addps xmm2,[rdi+rcx*4+32]
		addps xmm3,[rdi+rcx*4+48]
		movaps [rax+rcx*4],xmm0
		movaps [rax+rcx*4+16],xmm1
		movaps [rax+rcx*4+32],xmm2
		movaps [rax+rcx*4+48],xmm3
		add rcx,r11
		sub rdx,r11
		jnz aloop
		
	movdqu xmm7,oword ptr[rsp+16]
	movdqu xmm6,oword ptr[rsp]	
	add rsp,32	
		
	pop r15
	pop r14
	pop r13
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp
			
		ret
		
dotProd_m32_m16_SSE2 endp


;dotProd_m48_m16_SSE2 proc data_:dword,weights:dword,vals:dword,n:dword,len:dword,istd:dword
; data_ = rcx
; weights = rdx
; vals = r8
; n = r9d

dotProd_m48_m16_SSE2 proc public frame

len equ dword ptr[rbp+48]
istd equ qword ptr[rbp+56]

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
	sub rsp,32
	.allocstack 32
	movdqu oword ptr[rsp],xmm6
	.savexmm128 xmm6,0
	movdqu oword ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog
		
		mov rdi,rdx
		mov rax,r8
		xor rbx,rbx
		mov ebx,r9d
		xor rsi,rsi
		mov esi,len
		mov r15,rcx
		
		mov r10,4
		mov r11,16
		mov r12,48
		mov r13,192
		mov r14,768
			
nloop_2:
		mov rcx,r15
		xorps xmm0,xmm0
		xorps xmm1,xmm1
		xorps xmm2,xmm2
		xorps xmm3,xmm3
		mov rdx,rsi
lloop_2:
		movaps xmm4,[rcx]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[rdi]
		mulps xmm5,[rdi+r11]
		mulps xmm6,[rdi+2*r11]
		mulps xmm7,[rdi+r12]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[rcx+r11]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[rdi+4*r11]
		mulps xmm5,[rdi+80]
		mulps xmm6,[rdi+96]
		mulps xmm7,[rdi+112]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[rcx+2*r11]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[rdi+8*r11]
		mulps xmm5,[rdi+144]
		mulps xmm6,[rdi+160]
		mulps xmm7,[rdi+176]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[rcx+r12]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[rdi+r13]
		mulps xmm5,[rdi+208]
		mulps xmm6,[rdi+224]
		mulps xmm7,[rdi+240]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[rcx+4*r11]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[rdi+256]
		mulps xmm5,[rdi+272]
		mulps xmm6,[rdi+288]
		mulps xmm7,[rdi+304]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[rcx+80]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[rdi+320]
		mulps xmm5,[rdi+336]
		mulps xmm6,[rdi+352]
		mulps xmm7,[rdi+368]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[rcx+96]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[rdi+384]
		mulps xmm5,[rdi+400]
		mulps xmm6,[rdi+416]
		mulps xmm7,[rdi+432]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[rcx+112]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[rdi+448]
		mulps xmm5,[rdi+464]
		mulps xmm6,[rdi+480]
		mulps xmm7,[rdi+496]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[rcx+8*r11]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[rdi+512]
		mulps xmm5,[rdi+528]
		mulps xmm6,[rdi+544]
		mulps xmm7,[rdi+560]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[rcx+144]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[rdi+576]
		mulps xmm5,[rdi+592]
		mulps xmm6,[rdi+608]
		mulps xmm7,[rdi+624]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[rcx+160]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[rdi+640]
		mulps xmm5,[rdi+656]
		mulps xmm6,[rdi+672]
		mulps xmm7,[rdi+688]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[rcx+176]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[rdi+704]
		mulps xmm5,[rdi+720]
		mulps xmm6,[rdi+736]
		mulps xmm7,[rdi+752]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		add rcx,r13
		add rdi,r14
		sub rdx,r12
		jnz lloop_2
		movaps xmm4,xmm0
		movaps xmm5,xmm2
		unpcklpd xmm0,xmm1
		unpcklpd xmm2,xmm3
		unpckhpd xmm4,xmm1
		unpckhpd xmm5,xmm3
		addps xmm0,xmm4
		addps xmm2,xmm5
		movaps xmm6,xmm0
		shufps xmm0,xmm2,136
		shufps xmm6,xmm2,221
		addps xmm6,xmm0
		movaps [rax],xmm6
		add rax,r11
		sub rbx,r10
		jnz nloop_2
		mov rcx,istd
		mov rax,r8
		movss xmm7,dword ptr[rcx]
		xor rdx,rdx
		mov edx,r9d
		shufps xmm7,xmm7,0
		xor rcx,rcx
aloop_2:
		movaps xmm0,[rax+rcx*4]
		movaps xmm1,[rax+rcx*4+16]
		movaps xmm2,[rax+rcx*4+32]
		movaps xmm3,[rax+rcx*4+48]
		mulps xmm0,xmm7
		mulps xmm1,xmm7
		mulps xmm2,xmm7
		mulps xmm3,xmm7
		addps xmm0,[rdi+rcx*4]
		addps xmm1,[rdi+rcx*4+16]
		addps xmm2,[rdi+rcx*4+32]
		addps xmm3,[rdi+rcx*4+48]
		movaps [rax+rcx*4],xmm0
		movaps [rax+rcx*4+16],xmm1
		movaps [rax+rcx*4+32],xmm2
		movaps [rax+rcx*4+48],xmm3
		add rcx,r11
		sub rdx,r11
		jnz aloop_2
		
	movdqu xmm7,oword ptr[rsp+16]
	movdqu xmm6,oword ptr[rsp]	
	add rsp,32	
		
	pop r15
	pop r14
	pop r13
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp
		
		ret
		
dotProd_m48_m16_SSE2 endp


;dotProd_m32_m16_i16_SSE2 proc dataf:dword,weightsf:dword,vals:dword,n:dword,len:dword,istd:dword
; dataf = rcx
; weightsf = rdx
; vals = r8
; n = r9d

dotProd_m32_m16_i16_SSE2 proc public frame

len equ dword ptr[rbp+48]
istd equ qword ptr[rbp+56]

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
	sub rsp,32
	.allocstack 32
	movdqu oword ptr[rsp],xmm6
	.savexmm128 xmm6,0
	movdqu oword ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog
		
		mov rdi,rdx
		mov rax,r8
		xor rbx,rbx
		mov ebx,r9d
		xor rsi,rsi
		mov esi,len
		mov r15,rcx
		
		mov r10,4
		mov r11,16
		mov r12,32
		mov r13,64
		mov r14,256
		
nloop_3:
		mov rcx,r15
		pxor xmm0,xmm0
		pxor xmm1,xmm1
		pxor xmm2,xmm2
		pxor xmm3,xmm3
		mov rdx,rsi
lloop_3:
		movdqa xmm4,[rcx]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[rdi]
		pmaddwd xmm5,[rdi+r11]
		pmaddwd xmm6,[rdi+r12]
		pmaddwd xmm7,[rdi+48]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[rcx+r11]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[rdi+2*r12]
		pmaddwd xmm5,[rdi+80]
		pmaddwd xmm6,[rdi+96]
		pmaddwd xmm7,[rdi+112]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[rcx+r12]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[rdi+2*r13]
		pmaddwd xmm5,[rdi+144]
		pmaddwd xmm6,[rdi+160]
		pmaddwd xmm7,[rdi+176]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[rcx+48]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[rdi+192]
		pmaddwd xmm5,[rdi+208]
		pmaddwd xmm6,[rdi+224]
		pmaddwd xmm7,[rdi+240]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		add rcx,r13
		add rdi,r14
		sub rdx,r12
		jnz lloop_3
		movdqa xmm4,xmm0
		movdqa xmm5,xmm2
		punpcklqdq xmm0,xmm1
		punpcklqdq xmm2,xmm3
		punpckhqdq xmm4,xmm1
		punpckhqdq xmm5,xmm3
		paddd xmm0,xmm4
		paddd xmm2,xmm5
		movdqa xmm6,xmm0
		shufps xmm0,xmm2,136
		shufps xmm6,xmm2,221
		paddd xmm6,xmm0
		movdqa [rax],xmm6
		add rax,r11
		sub rbx,r10
		jnz nloop_3
		mov rcx,istd
		mov rax,r8
		movss xmm7,dword ptr[rcx]
		xor rdx,rdx
		mov edx,r9d
		pshufd xmm7,xmm7,0
		xor rcx,rcx
aloop_3:
		movdqa xmm0,[rax+rcx*4]
		movdqa xmm1,[rax+rcx*4+16]
		movdqa xmm2,[rax+rcx*4+32]
		movdqa xmm3,[rax+rcx*4+48]
		cvtdq2ps xmm0,xmm0
		cvtdq2ps xmm1,xmm1
		cvtdq2ps xmm2,xmm2
		cvtdq2ps xmm3,xmm3
		mulps xmm0,[rdi+rcx*8]
		mulps xmm1,[rdi+rcx*8+32]
		mulps xmm2,[rdi+rcx*8+64]
		mulps xmm3,[rdi+rcx*8+96]
		mulps xmm0,xmm7
		mulps xmm1,xmm7
		mulps xmm2,xmm7
		mulps xmm3,xmm7
		addps xmm0,[rdi+rcx*8+16]
		addps xmm1,[rdi+rcx*8+48]
		addps xmm2,[rdi+rcx*8+80]
		addps xmm3,[rdi+rcx*8+112]
		movaps [rax+rcx*4],xmm0
		movaps [rax+rcx*4+16],xmm1
		movaps [rax+rcx*4+32],xmm2
		movaps [rax+rcx*4+48],xmm3
		add rcx,r11
		sub rdx,r11
		jnz aloop_3
		
	movdqu xmm7,oword ptr[rsp+16]
	movdqu xmm6,oword ptr[rsp]	
	add rsp,32	
		
	pop r15
	pop r14
	pop r13
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp		
		
		ret
		
dotProd_m32_m16_i16_SSE2 endp


;dotProd_m48_m16_i16_SSE2 proc dataf:dword,weightsf:dword,vals:dword,n:dword,len:dword,istd:dword
; dataf = rcx
; weightsf = rdx
; vals = r8
; n = r9d

dotProd_m48_m16_i16_SSE2 proc public frame

len equ dword ptr[rbp+48]
istd equ qword ptr[rbp+56]

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
	sub rsp,32
	.allocstack 32
	movdqu oword ptr[rsp],xmm6
	.savexmm128 xmm6,0
	movdqu oword ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog
		
		mov rdi,rdx
		mov rax,r8
		xor rbx,rbx
		mov ebx,r9d
		xor rsi,rsi
		mov esi,len
		mov r15,rcx
		
		mov r10,4
		mov r11,16
		mov r12,48
		mov r13,96
		mov r14,384
		
nloop_4:
		mov rcx,r15
		pxor xmm0,xmm0
		pxor xmm1,xmm1
		pxor xmm2,xmm2
		pxor xmm3,xmm3
		mov rdx,rsi
lloop_4:
		movdqa xmm4,[rcx]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[rdi]
		pmaddwd xmm5,[rdi+r11]
		pmaddwd xmm6,[rdi+2*r11]
		pmaddwd xmm7,[rdi+r12]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[rcx+r11]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[rdi+4*r11]
		pmaddwd xmm5,[rdi+80]
		pmaddwd xmm6,[rdi+r13]
		pmaddwd xmm7,[rdi+112]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[rcx+2*r11]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[rdi+8*r11]
		pmaddwd xmm5,[rdi+144]
		pmaddwd xmm6,[rdi+160]
		pmaddwd xmm7,[rdi+176]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[rcx+r12]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[rdi+192]
		pmaddwd xmm5,[rdi+208]
		pmaddwd xmm6,[rdi+224]
		pmaddwd xmm7,[rdi+240]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[rcx+4*r11]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[rdi+256]
		pmaddwd xmm5,[rdi+272]
		pmaddwd xmm6,[rdi+288]
		pmaddwd xmm7,[rdi+304]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[rcx+80]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[rdi+320]
		pmaddwd xmm5,[rdi+336]
		pmaddwd xmm6,[rdi+352]
		pmaddwd xmm7,[rdi+368]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		add rcx,r13
		add rdi,r14
		sub rdx,r12
		jnz lloop_4
		movdqa xmm4,xmm0
		movdqa xmm5,xmm2
		punpcklqdq xmm0,xmm1
		punpcklqdq xmm2,xmm3
		punpckhqdq xmm4,xmm1
		punpckhqdq xmm5,xmm3
		paddd xmm0,xmm4
		paddd xmm2,xmm5
		movdqa xmm6,xmm0
		shufps xmm0,xmm2,136
		shufps xmm6,xmm2,221
		paddd xmm6,xmm0
		movdqa [rax],xmm6
		add rax,r11
		sub rbx,r10
		jnz nloop_4
		mov rcx,istd
		mov rax,r8
		movss xmm7,dword ptr[rcx]
		xor rbx,rbx
		mov edx,r9d
		pshufd xmm7,xmm7,0
		xor rcx,rcx
aloop_4:
		movdqa xmm0,[rax+rcx*4]
		movdqa xmm1,[rax+rcx*4+16]
		movdqa xmm2,[rax+rcx*4+32]
		movdqa xmm3,[rax+rcx*4+48]
		cvtdq2ps xmm0,xmm0
		cvtdq2ps xmm1,xmm1
		cvtdq2ps xmm2,xmm2
		cvtdq2ps xmm3,xmm3
		mulps xmm0,[rdi+rcx*8]
		mulps xmm1,[rdi+rcx*8+32]
		mulps xmm2,[rdi+rcx*8+64]
		mulps xmm3,[rdi+rcx*8+96]
		mulps xmm0,xmm7
		mulps xmm1,xmm7
		mulps xmm2,xmm7
		mulps xmm3,xmm7
		addps xmm0,[rdi+rcx*8+16]
		addps xmm1,[rdi+rcx*8+48]
		addps xmm2,[rdi+rcx*8+80]
		addps xmm3,[rdi+rcx*8+112]
		movaps [rax+rcx*4],xmm0
		movaps [rax+rcx*4+16],xmm1
		movaps [rax+rcx*4+32],xmm2
		movaps [rax+rcx*4+48],xmm3
		add rcx,r11
		sub rdx,r11
		jnz aloop_4
		
	movdqu xmm7,oword ptr[rsp+16]
	movdqu xmm6,oword ptr[rsp]	
	add rsp,32	
		
	pop r15
	pop r14
	pop r13
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp		
		
		ret

dotProd_m48_m16_i16_SSE2 endp


;e0_m16_SSE2 proc ptr_s:dword,n:dword
; ptr_s = rcx
; n = edx

e0_m16_SSE2 proc public frame

	sub rsp,32
	.allocstack 32
	movdqu oword ptr[rsp],xmm6
	.savexmm128 xmm6,0
	movdqu oword ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog
	
		mov rax,rcx
		xor rcx,rcx
		mov ecx,edx
		
		movdqa xmm4,oword ptr exp_hi
		movdqa xmm5,oword ptr exp_lo
		movdqa xmm6,oword ptr e0_mult
		movdqa xmm7,oword ptr e0_bias
		
		mov rdx,16
		mov r8,32
		mov r9,48
		mov r10,64
		
eloop16:
		movaps xmm0,[rax]
		movaps xmm1,[rax+rdx]
		movaps xmm2,[rax+r8]
		movaps xmm3,[rax+r9]
		minps xmm0,xmm4
		minps xmm1,xmm4
		minps xmm2,xmm4
		minps xmm3,xmm4
		maxps xmm0,xmm5
		maxps xmm1,xmm5
		maxps xmm2,xmm5
		maxps xmm3,xmm5
		mulps xmm0,xmm6
		mulps xmm1,xmm6
		mulps xmm2,xmm6
		mulps xmm3,xmm6
		addps xmm0,xmm7
		addps xmm1,xmm7
		addps xmm2,xmm7
		addps xmm3,xmm7
		cvtps2dq xmm0,xmm0
		cvtps2dq xmm1,xmm1
		cvtps2dq xmm2,xmm2
		cvtps2dq xmm3,xmm3
		movaps [rax],xmm0
		movaps [rax+rdx],xmm1
		movaps [rax+r8],xmm2
		movaps [rax+r9],xmm3
		add rax,r10
		sub rcx,rdx
		
		jnz eloop16
		
	movdqu xmm7,oword ptr[rsp+16]
	movdqu xmm6,oword ptr[rsp]	
	add rsp,32			
		
		ret

e0_m16_SSE2 endp


;e1_m16_SSE2 proc ptr_s:dword,n:dword
; ptr_s = rcx
; n = edx

e1_m16_SSE2 proc public frame

	sub rsp,128
	.allocstack 128
	movdqu oword ptr[rsp],xmm6
	.savexmm128 xmm6,0
	movdqu oword ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	movdqu oword ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	movdqu oword ptr[rsp+48],xmm9
	.savexmm128 xmm9,48
	movdqu oword ptr[rsp+64],xmm10
	.savexmm128 xmm10,64
	movdqu oword ptr[rsp+80],xmm11
	.savexmm128 xmm11,80
	movdqu oword ptr[rsp+96],xmm12
	.savexmm128 xmm12,96
	movdqu oword ptr[rsp+112],xmm13
	.savexmm128 xmm13,112
	.endprolog
	
		mov rax,rcx
		xor rcx,rcx
		mov ecx,edx
		
		movdqa xmm7,oword ptr exp_hi
		movdqa xmm8,oword ptr exp_lo
		movdqa xmm9,oword ptr e1_scale
		movdqa xmm10,oword ptr e1_bias
		movdqa xmm11,oword ptr e1_c1
		movdqa xmm12,oword ptr e1_c2
		movdqa xmm13,oword ptr e1_c0
		
		mov rdx,8
		mov r8,16
		mov r9,32	
		
eloop8:
		movaps xmm0,[rax]
		movaps xmm4,[rax+r8]
		minps xmm0,xmm7
		minps xmm4,xmm7
		maxps xmm0,xmm8
		maxps xmm4,xmm8
		mulps xmm0,xmm9
		mulps xmm4,xmm9
		movaps xmm1,xmm0
		movaps xmm5,xmm4
		addps xmm0,xmm10
		addps xmm4,xmm10
		movaps xmm2,xmm0
		movaps xmm6,xmm4
		subps xmm0,xmm10
		subps xmm4,xmm10
		pslld xmm2,23
		pslld xmm6,23
		subps xmm1,xmm0
		subps xmm5,xmm4
		movaps xmm0,xmm1
		movaps xmm4,xmm5
		mulps xmm1,xmm1
		mulps xmm5,xmm5
		mulps xmm0,xmm11
		mulps xmm4,xmm11
		mulps xmm1,xmm12
		mulps xmm5,xmm12
		addps xmm0,xmm13
		addps xmm4,xmm13
		addps xmm0,xmm1
		addps xmm4,xmm5
		paddd xmm0,xmm2
		paddd xmm4,xmm6
		movaps [rax],xmm0
		movaps [rax+r8],xmm4
		add rax,r9
		sub rcx,rdx
		jnz eloop8
		
	movdqu xmm13,oword ptr[rsp+112]
	movdqu xmm12,oword ptr[rsp+96]
	movdqu xmm11,oword ptr[rsp+80]
	movdqu xmm10,oword ptr[rsp+64]
	movdqu xmm9,oword ptr[rsp+48]
	movdqu xmm8,oword ptr[rsp+32]
	movdqu xmm7,oword ptr[rsp+16]
	movdqu xmm6,oword ptr[rsp]	
	add rsp,128
		
		ret
		
e1_m16_SSE2 endp


;e2_m16_SSE2 proc ptr_s:dword,n:dword
; ptr_s = rcx
; n = edx

e2_m16_SSE2 proc public frame

	sub rsp,160
	.allocstack 160
	movdqu oword ptr[rsp],xmm6
	.savexmm128 xmm6,0
	movdqu oword ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	movdqu oword ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	movdqu oword ptr[rsp+48],xmm9
	.savexmm128 xmm9,48
	movdqu oword ptr[rsp+64],xmm10
	.savexmm128 xmm10,64
	movdqu oword ptr[rsp+80],xmm11
	.savexmm128 xmm11,80
	movdqu oword ptr[rsp+96],xmm12
	.savexmm128 xmm12,96
	movdqu oword ptr[rsp+112],xmm13
	.savexmm128 xmm13,112
	movdqu oword ptr[rsp+128],xmm14
	.savexmm128 xmm14,128
	movdqu oword ptr[rsp+144],xmm15
	.savexmm128 xmm15,144
	.endprolog
	
		mov rax,rcx
		xor rcx,rcx
		mov ecx,edx
		
		movdqa xmm7,oword ptr exp_hi
		movdqa xmm8,oword ptr exp_lo
		movdqa xmm9,oword ptr exp_rln2
		movdqa xmm10,oword ptr am_0p5
		movdqa xmm11,oword ptr epi32_1
		movdqa xmm12,oword ptr exp_c2
		movdqa xmm13,oword ptr exp_c1
		movdqa xmm14,oword ptr exp_q0
		movdqa xmm15,oword ptr exp_p0
		
		mov rdx,4
		mov r8,16

eloop4:
		movaps xmm0,[rax]
		minps xmm0,xmm7
		maxps xmm0,xmm8
		movaps xmm1,xmm9
		mulps xmm1,xmm0
		xorps xmm2,xmm2
		addps xmm1,xmm10
		cmpnltps xmm2,xmm1
		pand xmm2,xmm11
		cvttps2dq xmm1,xmm1
		movaps xmm4,xmm12
		psubd xmm1,xmm2
		movaps xmm5,xmm13
		cvtdq2ps xmm3,xmm1
		mulps xmm4,xmm3
		mulps xmm5,xmm3
		movaps xmm6,xmm14
		subps xmm0,xmm4
		movaps xmm4,xmm15
		subps xmm0,xmm5
		paddd xmm1,oword ptr epi32_0x7f
		movaps xmm2,xmm0
		mulps xmm0,xmm0
		mulps xmm6,xmm0
		mulps xmm4,xmm0
		addps xmm6,oword ptr exp_q1
		addps xmm4,oword ptr exp_p1
		mulps xmm6,xmm0
		mulps xmm4,xmm0
		addps xmm6,oword ptr exp_q2
		mulps xmm4,xmm2
		mulps xmm6,xmm0
		movaps xmm0,oword ptr am_1
		addps xmm2,xmm4
		addps xmm6,oword ptr exp_q3
		pslld xmm1,23
		subps xmm6,xmm2
		rcpps xmm6,xmm6
		mulps xmm2,xmm6
		addps xmm2,xmm2
		addps xmm0,xmm2
		mulps xmm0,xmm1
		movaps [rax],xmm0
		add rax,r8
		sub rcx,rdx
		jnz eloop4
		
	movdqu xmm15,oword ptr[rsp+144]
	movdqu xmm14,oword ptr[rsp+128]
	movdqu xmm13,oword ptr[rsp+112]
	movdqu xmm12,oword ptr[rsp+96]
	movdqu xmm11,oword ptr[rsp+80]
	movdqu xmm10,oword ptr[rsp+64]
	movdqu xmm9,oword ptr[rsp+48]
	movdqu xmm8,oword ptr[rsp+32]
	movdqu xmm7,oword ptr[rsp+16]
	movdqu xmm6,oword ptr[rsp]	
	add rsp,160		
		
		ret
		
e2_m16_SSE2 endp


;weightedAvgElliottMul5_m16_SSE2 proc ptr_w:dword,n:dword,mstd:dword
; ptr_w = rcx
; n = edx
; mstd = r8

weightedAvgElliottMul5_m16_SSE2 proc public frame

	push rdi
	.pushreg rdi
	sub rsp,64
	.allocstack 64
	movdqa oword ptr[rsp],xmm6
	.savexmm128 xmm6,0
	movdqa oword ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	movdqa oword ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	movdqa oword ptr[rsp+48],xmm9
	.savexmm128 xmm9,48
	.endprolog

		mov rax,rcx
		xor rcx,rcx
		mov ecx,edx
		
		mov r9,16
		movdqa xmm8,oword ptr sign_bits_f
		movdqa xmm9,oword ptr ones_f
	
		lea rdx,[rax+rcx*4]
		xor rdi,rdi
		xorps xmm0,xmm0
		xorps xmm1,xmm1
nloop_5:
		movaps xmm2,[rax+rdi*4]
		movaps xmm3,[rax+rdi*4+16]
		movaps xmm4,[rdx+rdi*4]
		movaps xmm5,[rdx+rdi*4+16]
		addps xmm0,xmm2
		movaps xmm6,xmm4
		movaps xmm7,xmm5
		addps xmm0,xmm3
		andps xmm4,xmm8
		andps xmm5,xmm8
		addps xmm4,xmm9
		addps xmm5,xmm9
		rcpps xmm4,xmm4
		rcpps xmm5,xmm5
		mulps xmm6,xmm4
		mulps xmm7,xmm5
		mulps xmm6,xmm2
		mulps xmm7,xmm3
		addps xmm1,xmm6
		addps xmm1,xmm7
		movaps xmm2,[rax+rdi*4+32]
		movaps xmm3,[rax+rdi*4+48]
		movaps xmm4,[rdx+rdi*4+32]
		movaps xmm5,[rdx+rdi*4+48]
		addps xmm0,xmm2
		movaps xmm6,xmm4
		movaps xmm7,xmm5
		addps xmm0,xmm3
		andps xmm4,xmm8
		andps xmm5,xmm8
		addps xmm4,xmm9
		addps xmm5,xmm9
		rcpps xmm4,xmm4
		rcpps xmm5,xmm5
		mulps xmm6,xmm4
		mulps xmm7,xmm5
		mulps xmm6,xmm2
		mulps xmm7,xmm3
		addps xmm1,xmm6
		addps xmm1,xmm7
		add rdi,r9
		sub rcx,r9
		jnz nloop_5
		movhlps xmm2,xmm0
		movhlps xmm3,xmm1
		addps xmm0,xmm2
		addps xmm1,xmm3
		pshuflw xmm2,xmm0,14
		pshuflw xmm3,xmm1,14
		addss xmm0,xmm2
		addss xmm1,xmm3
		comiss xmm0,dword ptr min_weight_sum
		jbe nodiv
		mulss xmm1,dword ptr five_f
		rcpss xmm0,xmm0
		mulss xmm1,xmm0
		jmp finish_5
nodiv:
		xorps xmm1,xmm1
finish_5:
		mov rax,r8
		mulss xmm1,dword ptr[rax+4]
		addss xmm1,dword ptr[rax]
		addss xmm1,dword ptr[rax+12]
		movss dword ptr[rax+12],xmm1
		
	movdqa xmm9,oword ptr[rsp+48]
	movdqa xmm8,oword ptr[rsp+32]
	movdqa xmm7,oword ptr[rsp+16]
	movdqa xmm6,oword ptr[rsp]	
	add rsp,64
		
		pop rdi
		
		ret
		
weightedAvgElliottMul5_m16_SSE2 endp


;castScale_SSE proc val:dword,scale:dword,dstp:dword,val_min:dword,val_max:dword
; val = rcx
; scale = rdx
; dstp = r8
; val_min = r9d

castScale_SSE proc public frame

val_max equ dword ptr[rsp+40]
	
	.endprolog
	
		movss xmm0,dword ptr[rcx+12]
		mulss xmm0,dword ptr[rdx]
		addss xmm0,dword ptr sse_half
		cvttss2si eax,xmm0
		mov rcx,r8
		cmp eax,val_max
		cmovnl eax,val_max
		cmp eax,r9d
		cmovng eax,r9d
		mov byte ptr[rcx],al
		
		ret
		
castScale_SSE endp



;castScale_SSE_16 proc val:dword,scale:dword,dstp:dword,val_min:dword,val_max:dword
; val = rcx
; scale = rdx
; dstp = r8
; val_min = r9d

castScale_SSE_16 proc public frame

val_max equ dword ptr[rsp+40]
	
	.endprolog
	
		movss xmm0,dword ptr[rcx+12]
		mulss xmm0,dword ptr[rdx]
		addss xmm0,dword ptr sse_half
		cvttss2si eax,xmm0
		mov rcx,r8
		cmp eax,val_max
		cmovnl eax,val_max
		cmp eax,r9d
		cmovng eax,r9d
		mov word ptr[rcx],ax
		
		ret
		
castScale_SSE_16 endp



;uc2s64_SSE2 proc ptr_t:dword,pitch:dword,ptr_p:dword
; ptr_t = rcx
; pitch = edx
; ptr_p = r8

uc2s64_SSE2 proc public frame
	
	sub rsp,32
	.allocstack 32
	movdqu oword ptr[rsp],xmm6
	.savexmm128 xmm6,0
	movdqu oword ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog
	
		mov rax,rcx
		movsxd rcx,edx
		pxor xmm7,xmm7
		movq xmm0,QWORD PTR[rax]
		movq xmm1,QWORD PTR[rax+8]
		movq xmm2,QWORD PTR[rax+rcx*2]
		movq xmm3,QWORD PTR[rax+rcx*2+8]
		punpcklbw xmm0,xmm7
		punpcklbw xmm1,xmm7
		punpcklbw xmm2,xmm7
		punpcklbw xmm3,xmm7
		lea rax,[rax+rcx*4]
		movdqa [r8],xmm0
		movdqa [r8+16],xmm1
		movdqa [r8+32],xmm2
		movdqa [r8+48],xmm3
		movq xmm4,QWORD PTR[rax]
		movq xmm5,QWORD PTR[rax+8]
		movq xmm6,QWORD PTR[rax+rcx*2]
		movq xmm0,QWORD PTR[rax+rcx*2+8]
		punpcklbw xmm4,xmm7
		punpcklbw xmm5,xmm7
		punpcklbw xmm6,xmm7
		punpcklbw xmm0,xmm7
		movdqa [r8+64],xmm4
		movdqa [r8+80],xmm5
		movdqa [r8+96],xmm6
		movdqa [r8+112],xmm0
		
	movdqu xmm7,oword ptr[rsp+16]
	movdqu xmm6,oword ptr[rsp]	
	add rsp,32		
		
		ret
		
uc2s64_SSE2 endp


;computeNetwork0new_SSE2 proc datai:dword,weights:dword,ptr_d:dword
; datai = rcx
; weights = rdx
; ptr_d = r8

computeNetwork0new_SSE2 proc public frame

	sub rsp,32
	.allocstack 32
	movdqu oword ptr[rsp],xmm6
	.savexmm128 xmm6,0
	movdqu oword ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog

		mov rax,rdx
		movdqa xmm0,[rcx]
		movdqa xmm1,xmm0
		movdqa xmm2,xmm0
		movdqa xmm3,xmm0
		pmaddwd xmm0,[rax]
		pmaddwd xmm1,[rax+16]
		pmaddwd xmm2,[rax+32]
		pmaddwd xmm3,[rax+48]
		
		movdqa xmm4,[rcx+16]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[rax+64]
		pmaddwd xmm5,[rax+80]
		pmaddwd xmm6,[rax+96]
		pmaddwd xmm7,[rax+112]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[rcx+32]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[rax+128]
		pmaddwd xmm5,[rax+144]
		pmaddwd xmm6,[rax+160]
		pmaddwd xmm7,[rax+176]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[rcx+48]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[rax+192]
		pmaddwd xmm5,[rax+208]
		pmaddwd xmm6,[rax+224]
		pmaddwd xmm7,[rax+240]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[rcx+64]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[rax+256]
		pmaddwd xmm5,[rax+272]
		pmaddwd xmm6,[rax+288]
		pmaddwd xmm7,[rax+304]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[rcx+80]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[rax+320]
		pmaddwd xmm5,[rax+336]
		pmaddwd xmm6,[rax+352]
		pmaddwd xmm7,[rax+368]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[rcx+96]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[rax+384]
		pmaddwd xmm5,[rax+400]
		pmaddwd xmm6,[rax+416]
		pmaddwd xmm7,[rax+432]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[rcx+112]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[rax+448]
		pmaddwd xmm5,[rax+464]
		pmaddwd xmm6,[rax+480]
		pmaddwd xmm7,[rax+496]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,xmm0
		movdqa xmm5,xmm2
		punpcklqdq xmm0,xmm1
		punpcklqdq xmm2,xmm3
		punpckhqdq xmm4,xmm1
		punpckhqdq xmm5,xmm3
		paddd xmm0,xmm4
		paddd xmm2,xmm5
		movdqa xmm6,xmm0
		shufps xmm0,xmm2,136
		shufps xmm6,xmm2,221
		
		paddd xmm0,xmm6
		cvtdq2ps xmm0,xmm0
		mulps xmm0,[rax+512]
		addps xmm0,[rax+528]
		movaps xmm1,xmm0
		andps xmm0,oword ptr sign_bits_f
		addps xmm0,oword ptr ones_f
		rcpps xmm0,xmm0
		mulps xmm0,xmm1
		pshufd xmm1,xmm0,0
		pshufd xmm2,xmm0,85
		pshufd xmm3,xmm0,170
		pshufd xmm4,xmm0,255
		mulps xmm1,[rax+544]
		mulps xmm2,[rax+560]
		mulps xmm3,[rax+576]
		mulps xmm4,[rax+592]
		pxor xmm0,xmm0
		addps xmm1,xmm2
		addps xmm3,xmm4
		addps xmm1,xmm3
		mov rcx,r8
		addps xmm1,[rax+608]
		cmpps xmm1,xmm0,1
		packssdw xmm1,xmm0
		packsswb xmm1,xmm0
		movd eax,xmm1
		xor eax,0FFFFFFFFh
		and eax,001010101h
		mov [rcx],eax
		
	movdqu xmm7,oword ptr[rsp+16]
	movdqu xmm6,oword ptr[rsp]	
	add rsp,32				
		
		ret
		
computeNetwork0new_SSE2 endp

end
