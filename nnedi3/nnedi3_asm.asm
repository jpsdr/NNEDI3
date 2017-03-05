.xmm
.model flat,c

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
w_16 sword 8 dup(16)

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

computeNetwork0_SSE2 proc input:dword,weights:dword,ptr_d:dword

    public computeNetwork0_SSE2
	
		mov ecx,input
		mov edx,weights
		mov eax,1
		
		movaps xmm0,[ecx]
		movaps xmm1,xmm0
		movaps xmm2,xmm0
		movaps xmm3,xmm0
		mulps xmm0,[edx]
		mulps xmm1,[edx+16]
		mulps xmm2,[edx+32]
		mulps xmm3,[edx+48]
		
		movaps xmm4,[ecx+16]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[edx+64]
		mulps xmm5,[edx+80]
		mulps xmm6,[edx+96]
		mulps xmm7,[edx+112]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[ecx+32]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[edx+128]
		mulps xmm5,[edx+144]
		mulps xmm6,[edx+160]
		mulps xmm7,[edx+176]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[ecx+48]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[edx+192]
		mulps xmm5,[edx+208]
		mulps xmm6,[edx+224]
		mulps xmm7,[edx+240]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[ecx+64]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[edx+256]
		mulps xmm5,[edx+272]
		mulps xmm6,[edx+288]
		mulps xmm7,[edx+304]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[ecx+80]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[edx+320]
		mulps xmm5,[edx+336]
		mulps xmm6,[edx+352]
		mulps xmm7,[edx+368]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[ecx+96]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[edx+384]
		mulps xmm5,[edx+400]
		mulps xmm6,[edx+416]
		mulps xmm7,[edx+432]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[ecx+112]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[edx+448]
		mulps xmm5,[edx+464]
		mulps xmm6,[edx+480]
		mulps xmm7,[edx+496]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[ecx+128]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[edx+512]
		mulps xmm5,[edx+528]
		mulps xmm6,[edx+544]
		mulps xmm7,[edx+560]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[ecx+144]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[edx+576]
		mulps xmm5,[edx+592]
		mulps xmm6,[edx+608]
		mulps xmm7,[edx+624]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[ecx+160]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[edx+640]
		mulps xmm5,[edx+656]
		mulps xmm6,[edx+672]
		mulps xmm7,[edx+688]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[ecx+176]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[edx+704]
		mulps xmm5,[edx+720]
		mulps xmm6,[edx+736]
		mulps xmm7,[edx+752]
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
		addps xmm0,[edx+768]
		
		movaps xmm1,xmm0
		andps xmm0,oword ptr sign_bits_f_zero_l
		addps xmm0,ones_f
		rcpps xmm0,xmm0
		mulps xmm0,xmm1
		pshufd xmm1,xmm0,0
		pshufd xmm2,xmm0,85
		pshufd xmm3,xmm0,170
		pshufd xmm4,xmm0,255
		mulps xmm1,[edx+784]
		mulps xmm2,[edx+784+16]
		mulps xmm3,[edx+784+32]
		mulps xmm4,[edx+784+48]
		addps xmm1,xmm2
		addps xmm3,xmm4
		addps xmm1,xmm3
		addps xmm1,[edx+784+64]
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
		mulps xmm0,[edx+864]
		mulps xmm1,[edx+864+16]
		mulps xmm2,[edx+864+32]
		mulps xmm3,[edx+864+48]
		pshufd xmm4,xmm7,0
		pshufd xmm5,xmm7,85
		pshufd xmm6,xmm7,170
		pshufd xmm7,xmm7,255
		mulps xmm4,[edx+864+64]
		mulps xmm5,[edx+864+80]
		mulps xmm6,[edx+864+96]
		mulps xmm7,[edx+864+112]
		addps xmm0,xmm1
		addps xmm2,xmm3
		addps xmm4,xmm5
		addps xmm6,xmm7
		addps xmm0,xmm2
		addps xmm4,xmm6
		addps xmm0,xmm4
		mov ecx,ptr_d
		addps xmm0,[edx+864+128]
		movhlps xmm1,xmm0
		maxps xmm0,xmm1
		pshuflw xmm1,xmm0,14
		comiss xmm1,xmm0
		jbe finish_1
		xor eax,eax
finish_1:
		mov BYTE PTR[ecx],al
		
		ret

computeNetwork0_SSE2 endp



computeNetwork0_i16_SSE2 proc inputf:dword,weightsf:dword,ptr_d:dword

    public computeNetwork0_i16_SSE2

		mov ecx,inputf
		mov edx,weightsf
		mov eax,1
		movdqa xmm0,[ecx]
		movdqa xmm1,xmm0
		movdqa xmm2,xmm0
		movdqa xmm3,xmm0
		pmaddwd xmm0,[edx]
		pmaddwd xmm1,[edx+16]
		pmaddwd xmm2,[edx+32]
		pmaddwd xmm3,[edx+48]
		
		movdqa xmm4,[ecx+16]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[edx+64]
		pmaddwd xmm5,[edx+80]
		pmaddwd xmm6,[edx+96]
		pmaddwd xmm7,[edx+112]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[ecx+32]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[edx+128]
		pmaddwd xmm5,[edx+144]
		pmaddwd xmm6,[edx+160]
		pmaddwd xmm7,[edx+176]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[ecx+48]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[edx+192]
		pmaddwd xmm5,[edx+208]
		pmaddwd xmm6,[edx+224]
		pmaddwd xmm7,[edx+240]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[ecx+64]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[edx+256]
		pmaddwd xmm5,[edx+272]
		pmaddwd xmm6,[edx+288]
		pmaddwd xmm7,[edx+304]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[ecx+80]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[edx+320]
		pmaddwd xmm5,[edx+336]
		pmaddwd xmm6,[edx+352]
		pmaddwd xmm7,[edx+368]
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
		mulps xmm0,[edx+384]
		addps xmm0,[edx+400]
		movaps xmm1,xmm0
		andps xmm0,oword ptr sign_bits_f_zero_l
		addps xmm0,oword ptr ones_f
		rcpps xmm0,xmm0
		mulps xmm0,xmm1
		pshufd xmm1,xmm0,0
		pshufd xmm2,xmm0,85
		pshufd xmm3,xmm0,170
		pshufd xmm4,xmm0,255
		mulps xmm1,[edx+416]
		mulps xmm2,[edx+416+16]
		mulps xmm3,[edx+416+32]
		mulps xmm4,[edx+416+48]
		addps xmm1,xmm2
		addps xmm3,xmm4
		addps xmm1,xmm3
		addps xmm1,[edx+416+64]
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
		mulps xmm0,[edx+496]
		mulps xmm1,[edx+496+16]
		mulps xmm2,[edx+496+32]
		mulps xmm3,[edx+496+48]
		pshufd xmm4,xmm7,0
		pshufd xmm5,xmm7,85
		pshufd xmm6,xmm7,170
		pshufd xmm7,xmm7,255
		mulps xmm4,[edx+496+64]
		mulps xmm5,[edx+496+80]
		mulps xmm6,[edx+496+96]
		mulps xmm7,[edx+496+112]
		addps xmm0,xmm1
		addps xmm2,xmm3
		addps xmm4,xmm5
		addps xmm6,xmm7
		addps xmm0,xmm2
		addps xmm4,xmm6
		addps xmm0,xmm4
		mov ecx,ptr_d
		addps xmm0,[edx+496+128]
		movhlps xmm1,xmm0
		maxps xmm0,xmm1
		pshuflw xmm1,xmm0,14
		comiss xmm1,xmm0
		jbe finish_2
		xor eax,eax
finish_2:
		mov BYTE PTR[ecx],al
		ret
		
computeNetwork0_i16_SSE2 endp



uc2f48_SSE2 proc ptr_t:dword,pitch:dword,ptr_p:dword

    public uc2f48_SSE2

		mov eax,ptr_t
		mov ecx,pitch
		mov edx,ptr_p
		pxor xmm6,xmm6
		movq xmm0,QWORD PTR[eax]
		movd xmm4,dword  ptr[eax+8]
		movq xmm2,QWORD PTR[eax+ecx*2]
		movd xmm5,dword ptr[eax+ecx*2+8]
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
		lea eax,[eax+ecx*4]
		cvtdq2ps xmm4,xmm4
		cvtdq2ps xmm5,xmm5
		cvtdq2ps xmm0,xmm0
		cvtdq2ps xmm1,xmm1
		cvtdq2ps xmm2,xmm2
		cvtdq2ps xmm3,xmm3
		movaps [edx],xmm0
		movaps [edx+16],xmm1
		movaps [edx+32],xmm4
		movaps [edx+48],xmm2
		movaps [edx+64],xmm3
		movaps [edx+80],xmm5
		movq xmm0,QWORD PTR[eax]
		movd xmm4,dword ptr[eax+8]
		movq xmm2,QWORD PTR[eax+ecx*2]
		movd xmm5,dword ptr[eax+ecx*2+8]
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
		movaps [edx+96],xmm0
		movaps [edx+112],xmm1
		movaps [edx+128],xmm4
		movaps [edx+144],xmm2
		movaps [edx+160],xmm3
		movaps [edx+176],xmm5
		
		ret
		
uc2f48_SSE2 endp


uc2f48_SSE2_16 proc ptr_t:dword,pitch:dword,ptr_p:dword

    public uc2f48_SSE2_16

		mov eax,ptr_t
		mov ecx,pitch
		mov edx,ptr_p
		pxor xmm6,xmm6
		
		movq xmm0,qword ptr[eax]
		movq xmm1,qword ptr[eax+8]
		movq xmm2,qword ptr[eax+16]
		movq xmm3,qword ptr[eax+ecx*2]
		movq xmm4,qword ptr[eax+ecx*2+8]
		movq xmm5,qword ptr[eax+ecx*2+16]
		punpcklwd xmm0,xmm6
		punpcklwd xmm1,xmm6
		punpcklwd xmm2,xmm6
		punpcklwd xmm3,xmm6
		punpcklwd xmm4,xmm6
		punpcklwd xmm5,xmm6
		
		lea eax,[eax+ecx*4]
		cvtdq2ps xmm0,xmm0
		cvtdq2ps xmm1,xmm1
		cvtdq2ps xmm2,xmm2
		cvtdq2ps xmm3,xmm3
		cvtdq2ps xmm4,xmm4
		cvtdq2ps xmm5,xmm5
		movaps [edx],xmm0
		movaps [edx+16],xmm1
		movaps [edx+32],xmm2
		movaps [edx+48],xmm3
		movaps [edx+64],xmm4
		movaps [edx+80],xmm5
		
		movq xmm0,qword ptr[eax]
		movq xmm1,qword ptr[eax+8]
		movq xmm2,qword ptr[eax+16]
		movq xmm3,qword ptr[eax+ecx*2]
		movq xmm4,qword ptr[eax+ecx*2+8]
		movq xmm5,qword ptr[eax+ecx*2+16]
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
		movaps [edx+96],xmm0
		movaps [edx+112],xmm1
		movaps [edx+128],xmm2
		movaps [edx+144],xmm3
		movaps [edx+160],xmm4
		movaps [edx+176],xmm5
		
		ret
		
uc2f48_SSE2_16 endp


uc2s48_SSE2 proc ptr_t:dword,pitch:dword,ptr_pf:dword

    public uc2s48_SSE2

		mov eax,ptr_t
		mov ecx,pitch
		lea edx,[eax+ecx*4]
		movq xmm0,QWORD PTR[eax]
		movd xmm1,dword ptr[eax+8]
		movd xmm2,dword ptr[eax+ecx*2]
		movq xmm3,QWORD PTR[eax+ecx*2+4]
		movq xmm4,QWORD PTR[edx]
		movd xmm5,dword ptr[edx+8]
		movd xmm6,dword ptr[edx+ecx*2]
		movq xmm7,QWORD PTR[edx+ecx*2+4]
		punpckldq xmm1,xmm2
		pxor xmm2,xmm2
		punpckldq xmm5,xmm6
		mov edx,ptr_pf
		punpcklbw xmm0,xmm2
		punpcklbw xmm3,xmm2
		punpcklbw xmm1,xmm2
		punpcklbw xmm4,xmm2
		punpcklbw xmm5,xmm2
		punpcklbw xmm7,xmm2
		movdqa [edx],xmm0
		movdqa [edx+16],xmm1
		movdqa [edx+32],xmm3
		movdqa [edx+48],xmm4
		movdqa [edx+64],xmm5
		movdqa [edx+80],xmm7
		
		ret

uc2s48_SSE2 endp


processLine0_SSE2_ASM proc tempu:dword,width_:dword,dstp:dword,src3p:dword,src_pitch:dword,val_min:word,val_max:word

    public processLine0_SSE2_ASM
	
		push ebx
		push edi
		push esi

		movzx eax,val_min
		pinsrw xmm0,eax,0
		pinsrw xmm0,eax,1
		pinsrw xmm0,eax,2
		pinsrw xmm0,eax,3
		pinsrw xmm0,eax,4
		pinsrw xmm0,eax,5
		pinsrw xmm0,eax,6
		pinsrw xmm0,eax,7
		movdqa oword ptr w_16,xmm0		
		
		movzx eax,val_max
		pinsrw xmm0,eax,0
		pinsrw xmm0,eax,1
		pinsrw xmm0,eax,2
		pinsrw xmm0,eax,3
		pinsrw xmm0,eax,4
		pinsrw xmm0,eax,5
		pinsrw xmm0,eax,6
		pinsrw xmm0,eax,7
		movdqa oword ptr w_254,xmm0	
				
		mov eax,tempu
		mov ebx,src3p
		mov ecx,width_
		mov edx,src_pitch
		mov esi,dstp
		lea edi,[ebx+edx*4]
		pxor xmm6,xmm6
		pxor xmm7,xmm7
xloop:
		movdqa xmm0,[ebx+edx*2]
		movdqa xmm1,[edi]
		movdqa xmm2,xmm0
		movdqa xmm3,xmm1
		punpcklbw xmm0,xmm7
		punpckhbw xmm2,xmm7
		punpcklbw xmm1,xmm7
		punpckhbw xmm3,xmm7
		paddw xmm0,xmm1
		paddw xmm2,xmm3
		pmullw xmm0,oword ptr w_19
		pmullw xmm2,oword ptr w_19
		movdqa xmm1,[ebx]
		movdqa xmm3,[edi+edx*2]
		movdqa xmm4,xmm1
		movdqa xmm5,xmm3
		punpcklbw xmm1,xmm7
		punpckhbw xmm4,xmm7
		punpcklbw xmm3,xmm7
		punpckhbw xmm5,xmm7
		paddw xmm1,xmm3
		paddw xmm4,xmm5
		pmullw xmm1,oword ptr w_3
		pmullw xmm4,oword ptr w_3
		movdqa xmm5,[eax]
		psubusw xmm0,xmm1
		psubusw xmm2,xmm4
		pxor xmm5,oword ptr ub_1
		paddusw xmm0,oword ptr uw_16
		paddusw xmm2,oword ptr uw_16
		psadbw xmm5,xmm7
		psraw xmm0,5
		psraw xmm2,5
		movdqa xmm3,xmm5
		pminsw xmm0,oword ptr w_254
		pminsw xmm2,oword ptr w_254
		psrldq xmm5,8
		pmaxsw xmm0,oword ptr w_16
		pmaxsw xmm2,oword ptr w_16
		paddusw xmm5,xmm3
		packuswb xmm0,xmm2
		movdqa [esi],xmm0
		paddusw xmm6,xmm5
		add ebx,16
		add edi,16
		add eax,16
		add esi,16
		sub ecx,16
		jnz xloop
		
		pop esi
		pop edi
		pop ebx
		
		movd eax,xmm6
		
		ret
		
processLine0_SSE2_ASM endp


processLine0_SSE2_ASM_16 proc tempu:dword,width_:dword,dstp:dword,src3p:dword,src_pitch:dword,val_min:word,val_max:word

    public processLine0_SSE2_ASM_16
	
		push ebx
		push edi
		push esi

		movzx eax,val_min
		pinsrw xmm0,eax,0
		pinsrw xmm0,eax,1
		pinsrw xmm0,eax,2
		pinsrw xmm0,eax,3
		pinsrw xmm0,eax,4
		pinsrw xmm0,eax,5
		pinsrw xmm0,eax,6
		pinsrw xmm0,eax,7
		movdqa oword ptr w_16,xmm0		
		
		movzx eax,val_max
		pinsrw xmm0,eax,0
		pinsrw xmm0,eax,1
		pinsrw xmm0,eax,2
		pinsrw xmm0,eax,3
		pinsrw xmm0,eax,4
		pinsrw xmm0,eax,5
		pinsrw xmm0,eax,6
		pinsrw xmm0,eax,7
		movdqa oword ptr w_254,xmm0		
				
		mov eax,tempu
		mov ebx,src3p
		mov ecx,width_
		mov edx,src_pitch
		mov esi,dstp
		lea edi,[ebx+edx*4]
		pxor xmm6,xmm6
		pxor xmm7,xmm7		
xloop_16:
		movdqa xmm0,[ebx+edx*2]
		movdqa xmm1,[edi]
		movdqa xmm2,xmm0
		movdqa xmm3,xmm1
		punpcklwd xmm0,xmm7
		punpckhwd xmm2,xmm7
		punpcklwd xmm1,xmm7
		punpckhwd xmm3,xmm7
		paddd xmm0,xmm1
		paddd xmm2,xmm3
		pmulld xmm0,oword ptr d_19
		pmulld xmm2,oword ptr d_19
		movdqa xmm1,[ebx]
		movdqa xmm3,[edi+edx*2]
		movdqa xmm4,xmm1
		movdqa xmm5,xmm3
		punpcklwd xmm1,xmm7
		punpckhwd xmm4,xmm7
		punpcklwd xmm3,xmm7
		punpckhwd xmm5,xmm7
		paddd xmm1,xmm3
		paddd xmm4,xmm5
		pmulld xmm1,oword ptr d_3
		pmulld xmm4,oword ptr d_3
		movq xmm5,qword ptr [eax]
		psubd xmm0,xmm1
		punpcklbw xmm5,xmm7
		psubd xmm2,xmm4
		pxor xmm5,oword ptr uw_1
		paddd xmm0,oword ptr ud_16
		paddd xmm2,oword ptr ud_16
		psadbw xmm5,xmm7		
		psrad xmm0,5
		psrad xmm2,5
		movdqa xmm3,xmm5
		packusdw xmm0,xmm2
		psrldq xmm5,8
		pminuw xmm0,oword ptr w_254
		pmaxuw xmm0,oword ptr w_16
		paddusw xmm5,xmm3
		movdqa [esi],xmm0
		paddusw xmm6,xmm5
		add ebx,16
		add edi,16
		add eax,8
		add esi,16
		sub ecx,8
		jnz xloop_16
		
		pop esi
		pop edi
		pop ebx
		
		movd eax,xmm6
		
		ret
		
processLine0_SSE2_ASM_16 endp



processLine0_SSE2_ASM_32 proc tempu:dword,width_:dword,dstp:dword,src3p:dword,src_pitch:dword

    public processLine0_SSE2_ASM_32
	
		push ebx
		push edi
		push esi

		mov eax,tempu
		mov ebx,src3p
		mov ecx,width_
		mov edx,src_pitch
		mov esi,dstp
		lea edi,[ebx+edx*4]
		pxor xmm5,xmm5
		pxor xmm6,xmm6		
		
xloop_32:
		movd xmm4,dword ptr [eax]
		movaps xmm2,[ebx]		
		movaps xmm0,[ebx+edx*2]
		punpcklbw xmm4,xmm6		
		movaps xmm1,[edi]
		movaps xmm3,[edi+edx*2]		
		punpcklwd xmm4,xmm6		
		addps xmm0,xmm1
		pxor xmm4,oword ptr dw_1		
		addps xmm2,xmm3		
		psadbw xmm4,xmm6
		mulps xmm0,oword ptr f_19
		movdqa xmm3,xmm4
		mulps xmm2,oword ptr f_3
		psrldq xmm4,8
		subps xmm0,xmm2	
		paddusw xmm4,xmm3
		movaps [esi],xmm0
		paddusw xmm5,xmm4
		add ebx,16
		add edi,16
		add eax,4
		add esi,16
		sub ecx,4
		jnz xloop_32
		
		pop esi
		pop edi
		pop ebx
		
		movd eax,xmm5
		
		ret
		
processLine0_SSE2_ASM_32 endp



extract_m8_SSE2 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,input:dword

	public extract_m8_SSE2
	
	local ydia_:dword

		push ebx
		push edi
		push esi
		
		mov eax,ydia
		mov ydia_,eax
		
		mov eax,srcp
		mov ebx,stride
		mov edi,xdia
		mov esi,input
		
		lea edx,[eax+ebx*2]
		pxor xmm5,xmm5
		pxor xmm6,xmm6
		pxor xmm3,xmm3
		
yloop2:
		xor ecx,ecx
xloop2:
		movq xmm0,QWORD PTR[eax+ecx]
		movq xmm2,QWORD PTR[edx+ecx]
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
		movaps [esi],xmm0
		movaps [esi+16],xmm1
		movaps [esi+edi*4],xmm2
		movaps [esi+edi*4+16],xmm4
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
		add ecx,8
		add esi,32
		cmp ecx,edi
		jl xloop2
		lea eax,[eax+ebx*4]
		lea edx,[edx+ebx*4]
		lea esi,[esi+edi*4]
		sub ydia_,2
		jnz yloop2
		mov eax,ydia
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
		mov eax,mstd
		mulss xmm5,xmm7
		mulss xmm6,xmm7
		movss dword ptr[eax],xmm5
		mulss xmm5,xmm5
		subss xmm6,xmm5
		comiss xmm6,dword ptr flt_epsilon_sse
		jbe novarjmp
		rsqrtss xmm6,xmm6
		rcpss xmm5,xmm6
		movss dword ptr[eax+4],xmm5
		movss dword ptr[eax+8],xmm6
		jmp finish_3
novarjmp:
		movss dword ptr[eax+4],xmm3
		movss dword ptr[eax+8],xmm3
finish_3:
		movss dword ptr[eax+12],xmm3
		
		pop esi
		pop edi
		pop ebx
		
		ret
		
extract_m8_SSE2 endp



extract_m8_SSE2_16 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,input:dword

	public extract_m8_SSE2_16
	
	local ydia_:dword

		push ebx
		push edi
		push esi
		
		mov eax,ydia
		mov ydia_,eax
		
		mov eax,srcp
		mov ebx,stride
		mov edi,xdia
		mov esi,input
		
		lea edx,[eax+ebx*2]
		pxor xmm5,xmm5
		pxor xmm6,xmm6
		pxor xmm3,xmm3
		
yloop2_16:
		xor ecx,ecx
xloop2_16:
		movlps xmm0,QWORD PTR[eax+2*ecx]
		movhps xmm0,QWORD PTR[eax+2*ecx+8]
		movlps xmm2,QWORD PTR[edx+2*ecx]
		movhps xmm2,QWORD PTR[edx+2*ecx+8]

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
		movaps [esi],xmm0
		movaps [esi+16],xmm1
		movaps [esi+edi*4],xmm2
		movaps [esi+edi*4+16],xmm4
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
		add ecx,8
		add esi,32
		cmp ecx,edi
		jl xloop2_16
		lea eax,[eax+ebx*4]
		lea edx,[edx+ebx*4]
		lea esi,[esi+edi*4]
		sub ydia_,2
		jnz yloop2_16
		
		mov eax,ydia
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
		mov eax,mstd
		mulss xmm5,xmm7
		mulss xmm6,xmm7
		movss dword ptr[eax],xmm5
		mulss xmm5,xmm5
		subss xmm6,xmm5
		comiss xmm6,dword ptr flt_epsilon_sse
		jbe novarjmp_16
		rsqrtss xmm6,xmm6
		rcpss xmm5,xmm6
		movss dword ptr[eax+4],xmm5
		movss dword ptr[eax+8],xmm6
		jmp finish_3_16
novarjmp_16:
		movss dword ptr[eax+4],xmm3
		movss dword ptr[eax+8],xmm3
finish_3_16:
		movss dword ptr[eax+12],xmm3
		
		pop esi
		pop edi
		pop ebx
		
		ret
		
extract_m8_SSE2_16 endp



extract_m8_SSE2_32 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,input:dword

	public extract_m8_SSE2_32
	
	local ydia_:dword

		push ebx
		push edi
		push esi
		
		mov eax,ydia
		mov ydia_,eax
		
		mov eax,srcp
		mov ebx,stride
		mov edi,xdia
		mov esi,input
		
		lea edx,[eax+ebx*2]
		pxor xmm5,xmm5
		pxor xmm6,xmm6
		pxor xmm3,xmm3
		
yloop2_32:
		xor ecx,ecx
xloop2_32:
		movlps xmm0,QWORD PTR[eax+4*ecx]
		movhps xmm0,QWORD PTR[eax+4*ecx+8]
		movlps xmm2,QWORD PTR[edx+4*ecx]
		movhps xmm2,QWORD PTR[edx+4*ecx+8]
		
		movaps [esi],xmm0
		movaps [esi+edi*4],xmm2
		addps xmm5,xmm0
		addps xmm5,xmm2
		mulps xmm0,xmm0
		mulps xmm2,xmm2
		addps xmm6,xmm0
		addps xmm6,xmm2
		add ecx,4
		add esi,16
		cmp ecx,edi
		jl xloop2_32
		lea eax,[eax+ebx*4]
		lea edx,[edx+ebx*4]
		lea esi,[esi+edi*4]
		sub ydia_,2
		jnz yloop2_32
		
		mov eax,ydia
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
		mov eax,mstd
		mulss xmm5,xmm7
		mulss xmm6,xmm7
		movss dword ptr[eax],xmm5
		mulss xmm5,xmm5
		subss xmm6,xmm5
		comiss xmm6,dword ptr flt_epsilon_sse
		jbe novarjmp_32
		rsqrtss xmm6,xmm6
		rcpss xmm5,xmm6
		movss dword ptr[eax+4],xmm5
		movss dword ptr[eax+8],xmm6
		jmp finish_3_32
novarjmp_32:
		movss dword ptr[eax+4],xmm3
		movss dword ptr[eax+8],xmm3
finish_3_32:
		movss dword ptr[eax+12],xmm3
		
		pop esi
		pop edi
		pop ebx
		
		ret
		
extract_m8_SSE2_32 endp


extract_m8_i16_SSE2 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,inputf:dword

	public extract_m8_i16_SSE2
	
	local ydia_:dword
	
		push ebx
		push edi
		push esi
		
		mov eax,ydia
		mov ydia_,eax		
		
		mov eax,srcp
		mov ebx,stride
		mov edi,xdia
		mov edx,inputf
		lea esi,[eax+ebx*2]
		pxor xmm4,xmm4
		pxor xmm5,xmm5
		pxor xmm6,xmm6
		
yloop:
		xor ecx,ecx
xloop_2:
		movq xmm0,QWORD PTR[eax+ecx]
		movq xmm1,QWORD PTR[esi+ecx]
		movdqa xmm2,xmm0
		movdqa xmm3,xmm1
		punpcklbw xmm0,xmm6
		punpcklbw xmm1,xmm6
		psadbw xmm2,xmm6
		psadbw xmm3,xmm6
		movdqa [edx],xmm0
		movdqa [edx+edi*2],xmm1
		pmaddwd xmm0,xmm0
		pmaddwd xmm1,xmm1
		paddd xmm4,xmm2
		paddd xmm5,xmm0
		paddd xmm4,xmm3
		paddd xmm5,xmm1
		add ecx,8
		add edx,16
		cmp ecx,edi
		jl xloop_2
		lea eax,[eax+ebx*4]
		lea esi,[esi+ebx*4]
		lea edx,[edx+edi*2]
		sub ydia_,2
		jnz yloop
		
		movhlps xmm1,xmm5
		mov eax,ydia
		paddd xmm5,xmm1
		mul edi
		pshuflw xmm1,xmm5,14
		cvtsi2ss xmm7,eax
		paddd xmm5,xmm1
		rcpss xmm7,xmm7
		cvtdq2ps xmm4,xmm4
		cvtdq2ps xmm5,xmm5
		mov eax,mstd
		mulss xmm4,xmm7
		mulss xmm5,xmm7
		movss dword ptr[eax],xmm4
		mulss xmm4,xmm4
		subss xmm5,xmm4
		comiss xmm5,dword ptr flt_epsilon_sse
		jbe novarjmp_2
		rsqrtss xmm5,xmm5
		rcpss xmm4,xmm5
		movss dword ptr[eax+4],xmm4
		movss dword ptr[eax+8],xmm5
		jmp finish_4
novarjmp_2:
		movss dword ptr[eax+4],xmm6
		movss dword ptr[eax+8],xmm6
finish_4:
		movss dword ptr[eax+12],xmm6
		
		pop esi
		pop edi
		pop ebx
		
		ret
		
extract_m8_i16_SSE2 endp


extract_m8_i16_SSE2_16 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,inputf:dword

	public extract_m8_i16_SSE2_16
	
	local ydia_:dword
	
		push ebx
		push edi
		push esi
		
		mov eax,ydia
		mov ydia_,eax		
		
		mov eax,srcp
		mov ebx,stride
		mov edi,xdia
		mov edx,inputf
		lea esi,[eax+ebx*2]
		pxor xmm4,xmm4
		pxor xmm5,xmm5
		pxor xmm6,xmm6
		
yloop_16:
		xor ecx,ecx
xloop_2_16:
		movlps xmm0,QWORD PTR[eax+2*ecx]
		movhps xmm0,QWORD PTR[eax+2*ecx+8]
		movlps xmm1,QWORD PTR[esi+2*ecx]
		movhps xmm1,QWORD PTR[esi+2*ecx+8]

		movdqa oword ptr [edx],xmm0
		movdqa oword ptr [edx+edi*2],xmm1
		
		movdqa xmm2,xmm0
		movdqa xmm3,xmm1

		pmaddwd xmm2,oword ptr uw_1
		pmaddwd xmm3,oword ptr uw_1
		
		pmaddwd xmm0,xmm0
		pmaddwd xmm1,xmm1
		
		paddd xmm4,xmm2
		paddd xmm5,xmm0
		paddd xmm4,xmm3
		paddd xmm5,xmm1
		add ecx,8
		add edx,16
		cmp ecx,edi
		jl xloop_2_16
		lea eax,[eax+ebx*4]
		lea esi,[esi+ebx*4]
		lea edx,[edx+edi*2]
		sub ydia_,2
		jnz yloop_16
		
		movhlps xmm1,xmm5
		movhlps xmm2,xmm4
		mov eax,ydia
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
		mov eax,mstd
		mulss xmm4,xmm7
		mulss xmm5,xmm7
		movss dword ptr[eax],xmm4
		mulss xmm4,xmm4
		subss xmm5,xmm4
		comiss xmm5,dword ptr flt_epsilon_sse
		jbe novarjmp_2_16
		rsqrtss xmm5,xmm5
		rcpss xmm4,xmm5
		movss dword ptr[eax+4],xmm4
		movss dword ptr[eax+8],xmm5
		jmp finish_4_16
novarjmp_2_16:
		movss dword ptr[eax+4],xmm6
		movss dword ptr[eax+8],xmm6
finish_4_16:
		movss dword ptr[eax+12],xmm6
		
		pop esi
		pop edi
		pop ebx
		
		ret
		
extract_m8_i16_SSE2_16 endp


extract_m8_i16_SSE2_16_2 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,inputf:dword,sum:dword,sumsq:dword

	public extract_m8_i16_SSE2_16_2
	
	local ydia_:dword
	
		push ebx
		push edi
		push esi
		
		mov eax,ydia
		mov ydia_,eax		
		
		mov eax,srcp
		mov ebx,stride
		mov edi,xdia
		mov edx,inputf
		lea esi,[eax+ebx*2]
		pxor xmm4,xmm4
		pxor xmm5,xmm5
		pxor xmm6,xmm6
		
yloop_16_2:
		xor ecx,ecx
xloop_2_16_2:
		movq xmm0,QWORD PTR[eax+2*ecx]
		movq xmm1,QWORD PTR[esi+2*ecx]
		
		movq qword ptr [edx],xmm0
		movq qword ptr [edx+edi*2],xmm1
		
		movdqa xmm2,xmm0
		movdqa xmm3,xmm1

		pmaddwd xmm2,oword ptr uw_1
		pmaddwd xmm3,oword ptr uw_1
		
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
		
		add ecx,4
		add edx,8
		cmp ecx,edi
		jl xloop_2_16_2
		lea eax,[eax+ebx*4]
		lea esi,[esi+ebx*4]
		lea edx,[edx+edi*2]
		sub ydia_,2
		jnz yloop_16_2
		
		movhlps xmm2,xmm4
		mov eax,sum
		paddd xmm4,xmm2
		mov ebx,sumsq
		pshufd xmm2,xmm4,1
		movq qword ptr [ebx],xmm5		
		paddd xmm4,xmm2
		movd dword ptr [eax],xmm4
	
		pop esi
		pop edi
		pop ebx
		
		ret
		
extract_m8_i16_SSE2_16_2 endp


dotProd_m32_m16_SSE2 proc data_:dword,weights:dword,vals:dword,n:dword,len:dword,istd:dword

	public dotProd_m32_m16_SSE2

		push edi
		push esi
		push ebx
		
		mov edi,weights
		mov eax,vals
		mov ebx,n
		mov esi,len
nloop:
		mov ecx,data_
		xorps xmm0,xmm0
		xorps xmm1,xmm1
		xorps xmm2,xmm2
		xorps xmm3,xmm3
		mov edx,esi
lloop:
		movaps xmm4,[ecx]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[edi]
		mulps xmm5,[edi+16]
		mulps xmm6,[edi+32]
		mulps xmm7,[edi+48]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[ecx+16]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[edi+64]
		mulps xmm5,[edi+80]
		mulps xmm6,[edi+96]
		mulps xmm7,[edi+112]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[ecx+32]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[edi+128]
		mulps xmm5,[edi+144]
		mulps xmm6,[edi+160]
		mulps xmm7,[edi+176]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[ecx+48]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[edi+192]
		mulps xmm5,[edi+208]
		mulps xmm6,[edi+224]
		mulps xmm7,[edi+240]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[ecx+64]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[edi+256]
		mulps xmm5,[edi+272]
		mulps xmm6,[edi+288]
		mulps xmm7,[edi+304]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[ecx+80]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[edi+320]
		mulps xmm5,[edi+336]
		mulps xmm6,[edi+352]
		mulps xmm7,[edi+368]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[ecx+96]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[edi+384]
		mulps xmm5,[edi+400]
		mulps xmm6,[edi+416]
		mulps xmm7,[edi+432]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[ecx+112]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[edi+448]
		mulps xmm5,[edi+464]
		mulps xmm6,[edi+480]
		mulps xmm7,[edi+496]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		add ecx,128
		add edi,512
		sub edx,32
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
		movaps [eax],xmm6
		add eax,16
		sub ebx,4
		jnz nloop
		mov ecx,istd
		mov eax,vals
		movss xmm7,dword ptr[ecx]
		mov edx,n
		shufps xmm7,xmm7,0
		xor ecx,ecx
aloop:
		movaps xmm0,[eax+ecx*4]
		movaps xmm1,[eax+ecx*4+16]
		movaps xmm2,[eax+ecx*4+32]
		movaps xmm3,[eax+ecx*4+48]
		mulps xmm0,xmm7
		mulps xmm1,xmm7
		mulps xmm2,xmm7
		mulps xmm3,xmm7
		addps xmm0,[edi+ecx*4]
		addps xmm1,[edi+ecx*4+16]
		addps xmm2,[edi+ecx*4+32]
		addps xmm3,[edi+ecx*4+48]
		movaps [eax+ecx*4],xmm0
		movaps [eax+ecx*4+16],xmm1
		movaps [eax+ecx*4+32],xmm2
		movaps [eax+ecx*4+48],xmm3
		add ecx,16
		sub edx,16
		jnz aloop
		
		pop ebx
		pop esi
		pop edi
		
		ret
		
dotProd_m32_m16_SSE2 endp


dotProd_m48_m16_SSE2 proc data_:dword,weights:dword,vals:dword,n:dword,len:dword,istd:dword

	public dotProd_m48_m16_SSE2
	
		push edi
		push esi
		push ebx
		
		mov edi,weights
		mov eax,vals
		mov ebx,n
		mov esi,len
nloop_2:
		mov ecx,data_
		xorps xmm0,xmm0
		xorps xmm1,xmm1
		xorps xmm2,xmm2
		xorps xmm3,xmm3
		mov edx,esi
lloop_2:
		movaps xmm4,[ecx]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[edi]
		mulps xmm5,[edi+16]
		mulps xmm6,[edi+32]
		mulps xmm7,[edi+48]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[ecx+16]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[edi+64]
		mulps xmm5,[edi+80]
		mulps xmm6,[edi+96]
		mulps xmm7,[edi+112]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[ecx+32]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[edi+128]
		mulps xmm5,[edi+144]
		mulps xmm6,[edi+160]
		mulps xmm7,[edi+176]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[ecx+48]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[edi+192]
		mulps xmm5,[edi+208]
		mulps xmm6,[edi+224]
		mulps xmm7,[edi+240]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[ecx+64]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[edi+256]
		mulps xmm5,[edi+272]
		mulps xmm6,[edi+288]
		mulps xmm7,[edi+304]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[ecx+80]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[edi+320]
		mulps xmm5,[edi+336]
		mulps xmm6,[edi+352]
		mulps xmm7,[edi+368]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[ecx+96]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[edi+384]
		mulps xmm5,[edi+400]
		mulps xmm6,[edi+416]
		mulps xmm7,[edi+432]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[ecx+112]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[edi+448]
		mulps xmm5,[edi+464]
		mulps xmm6,[edi+480]
		mulps xmm7,[edi+496]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[ecx+128]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[edi+512]
		mulps xmm5,[edi+528]
		mulps xmm6,[edi+544]
		mulps xmm7,[edi+560]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[ecx+144]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[edi+576]
		mulps xmm5,[edi+592]
		mulps xmm6,[edi+608]
		mulps xmm7,[edi+624]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[ecx+160]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[edi+640]
		mulps xmm5,[edi+656]
		mulps xmm6,[edi+672]
		mulps xmm7,[edi+688]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		movaps xmm4,[ecx+176]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		mulps xmm4,[edi+704]
		mulps xmm5,[edi+720]
		mulps xmm6,[edi+736]
		mulps xmm7,[edi+752]
		addps xmm0,xmm4
		addps xmm1,xmm5
		addps xmm2,xmm6
		addps xmm3,xmm7
		
		add ecx,192
		add edi,768
		sub edx,48
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
		movaps [eax],xmm6
		add eax,16
		sub ebx,4
		jnz nloop_2
		mov ecx,istd
		mov eax,vals
		movss xmm7,dword ptr[ecx]
		mov edx,n
		shufps xmm7,xmm7,0
		xor ecx,ecx
aloop_2:
		movaps xmm0,[eax+ecx*4]
		movaps xmm1,[eax+ecx*4+16]
		movaps xmm2,[eax+ecx*4+32]
		movaps xmm3,[eax+ecx*4+48]
		mulps xmm0,xmm7
		mulps xmm1,xmm7
		mulps xmm2,xmm7
		mulps xmm3,xmm7
		addps xmm0,[edi+ecx*4]
		addps xmm1,[edi+ecx*4+16]
		addps xmm2,[edi+ecx*4+32]
		addps xmm3,[edi+ecx*4+48]
		movaps [eax+ecx*4],xmm0
		movaps [eax+ecx*4+16],xmm1
		movaps [eax+ecx*4+32],xmm2
		movaps [eax+ecx*4+48],xmm3
		add ecx,16
		sub edx,16
		jnz aloop_2
		
		pop ebx
		pop esi
		pop edi
		
		ret
		
dotProd_m48_m16_SSE2 endp


dotProd_m32_m16_i16_SSE2 proc dataf:dword,weightsf:dword,vals:dword,n:dword,len:dword,istd:dword

	public dotProd_m32_m16_i16_SSE2

		push edi
		push esi
		push ebx
		
		mov edi,weightsf
		mov eax,vals
		mov ebx,n
		mov esi,len
nloop_3:
		mov ecx,dataf
		pxor xmm0,xmm0
		pxor xmm1,xmm1
		pxor xmm2,xmm2
		pxor xmm3,xmm3
		mov edx,esi
lloop_3:
		movdqa xmm4,[ecx]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[edi]
		pmaddwd xmm5,[edi+16]
		pmaddwd xmm6,[edi+32]
		pmaddwd xmm7,[edi+48]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[ecx+16]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[edi+64]
		pmaddwd xmm5,[edi+80]
		pmaddwd xmm6,[edi+96]
		pmaddwd xmm7,[edi+112]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[ecx+32]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[edi+128]
		pmaddwd xmm5,[edi+144]
		pmaddwd xmm6,[edi+160]
		pmaddwd xmm7,[edi+176]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[ecx+48]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[edi+192]
		pmaddwd xmm5,[edi+208]
		pmaddwd xmm6,[edi+224]
		pmaddwd xmm7,[edi+240]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		add ecx,64
		add edi,256
		sub edx,32
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
		movdqa [eax],xmm6
		add eax,16
		sub ebx,4
		jnz nloop_3
		mov ecx,istd
		mov eax,vals
		movss xmm7,dword ptr[ecx]
		mov edx,n
		pshufd xmm7,xmm7,0
		xor ecx,ecx
aloop_3:
		movdqa xmm0,[eax+ecx*4]
		movdqa xmm1,[eax+ecx*4+16]
		movdqa xmm2,[eax+ecx*4+32]
		movdqa xmm3,[eax+ecx*4+48]
		cvtdq2ps xmm0,xmm0
		cvtdq2ps xmm1,xmm1
		cvtdq2ps xmm2,xmm2
		cvtdq2ps xmm3,xmm3
		mulps xmm0,[edi+ecx*8]
		mulps xmm1,[edi+ecx*8+32]
		mulps xmm2,[edi+ecx*8+64]
		mulps xmm3,[edi+ecx*8+96]
		mulps xmm0,xmm7
		mulps xmm1,xmm7
		mulps xmm2,xmm7
		mulps xmm3,xmm7
		addps xmm0,[edi+ecx*8+16]
		addps xmm1,[edi+ecx*8+48]
		addps xmm2,[edi+ecx*8+80]
		addps xmm3,[edi+ecx*8+112]
		movaps [eax+ecx*4],xmm0
		movaps [eax+ecx*4+16],xmm1
		movaps [eax+ecx*4+32],xmm2
		movaps [eax+ecx*4+48],xmm3
		add ecx,16
		sub edx,16
		jnz aloop_3
		
		pop ebx
		pop esi
		pop edi
		
		ret
		
dotProd_m32_m16_i16_SSE2 endp


dotProd_m48_m16_i16_SSE2 proc dataf:dword,weightsf:dword,vals:dword,n:dword,len:dword,istd:dword

	public dotProd_m48_m16_i16_SSE2

		push edi
		push esi
		push ebx
		
		mov edi,weightsf
		mov eax,vals
		mov ebx,n
		mov esi,len
nloop_4:
		mov ecx,dataf
		pxor xmm0,xmm0
		pxor xmm1,xmm1
		pxor xmm2,xmm2
		pxor xmm3,xmm3
		mov edx,esi
lloop_4:
		movdqa xmm4,[ecx]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[edi]
		pmaddwd xmm5,[edi+16]
		pmaddwd xmm6,[edi+32]
		pmaddwd xmm7,[edi+48]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[ecx+16]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[edi+64]
		pmaddwd xmm5,[edi+80]
		pmaddwd xmm6,[edi+96]
		pmaddwd xmm7,[edi+112]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[ecx+32]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[edi+128]
		pmaddwd xmm5,[edi+144]
		pmaddwd xmm6,[edi+160]
		pmaddwd xmm7,[edi+176]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[ecx+48]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[edi+192]
		pmaddwd xmm5,[edi+208]
		pmaddwd xmm6,[edi+224]
		pmaddwd xmm7,[edi+240]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[ecx+64]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[edi+256]
		pmaddwd xmm5,[edi+272]
		pmaddwd xmm6,[edi+288]
		pmaddwd xmm7,[edi+304]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[ecx+80]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[edi+320]
		pmaddwd xmm5,[edi+336]
		pmaddwd xmm6,[edi+352]
		pmaddwd xmm7,[edi+368]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		add ecx,96
		add edi,384
		sub edx,48
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
		movdqa [eax],xmm6
		add eax,16
		sub ebx,4
		jnz nloop_4
		mov ecx,istd
		mov eax,vals
		movss xmm7,dword ptr[ecx]
		mov edx,n
		pshufd xmm7,xmm7,0
		xor ecx,ecx
aloop_4:
		movdqa xmm0,[eax+ecx*4]
		movdqa xmm1,[eax+ecx*4+16]
		movdqa xmm2,[eax+ecx*4+32]
		movdqa xmm3,[eax+ecx*4+48]
		cvtdq2ps xmm0,xmm0
		cvtdq2ps xmm1,xmm1
		cvtdq2ps xmm2,xmm2
		cvtdq2ps xmm3,xmm3
		mulps xmm0,[edi+ecx*8]
		mulps xmm1,[edi+ecx*8+32]
		mulps xmm2,[edi+ecx*8+64]
		mulps xmm3,[edi+ecx*8+96]
		mulps xmm0,xmm7
		mulps xmm1,xmm7
		mulps xmm2,xmm7
		mulps xmm3,xmm7
		addps xmm0,[edi+ecx*8+16]
		addps xmm1,[edi+ecx*8+48]
		addps xmm2,[edi+ecx*8+80]
		addps xmm3,[edi+ecx*8+112]
		movaps [eax+ecx*4],xmm0
		movaps [eax+ecx*4+16],xmm1
		movaps [eax+ecx*4+32],xmm2
		movaps [eax+ecx*4+48],xmm3
		add ecx,16
		sub edx,16
		jnz aloop_4
		
		pop ebx
		pop esi
		pop edi
		
		ret

dotProd_m48_m16_i16_SSE2 endp


e0_m16_SSE2 proc ptr_s:dword,n:dword

	public e0_m16_SSE2
	
		mov eax,ptr_s
		mov ecx,n
		
		movdqa xmm4,oword ptr exp_hi
		movdqa xmm5,oword ptr exp_lo
		movdqa xmm6,oword ptr e0_mult
		movdqa xmm7,oword ptr e0_bias
		
eloop16:
		movaps xmm0,[eax]
		movaps xmm1,[eax+16]
		movaps xmm2,[eax+32]
		movaps xmm3,[eax+48]
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
		movaps [eax],xmm0
		movaps [eax+16],xmm1
		movaps [eax+32],xmm2
		movaps [eax+48],xmm3
		add eax,64
		sub ecx,16
		
		jnz eloop16
		
		ret

e0_m16_SSE2 endp


e1_m16_SSE2 proc ptr_s:dword,n:dword

	public e1_m16_SSE2

		mov eax,ptr_s
		mov ecx,n
eloop8:
		movaps xmm0,[eax]
		movaps xmm4,[eax+16]
		minps xmm0,oword ptr exp_hi
		minps xmm4,oword ptr exp_hi
		maxps xmm0,oword ptr exp_lo
		maxps xmm4,oword ptr exp_lo
		mulps xmm0,oword ptr e1_scale
		mulps xmm4,oword ptr e1_scale
		movaps xmm1,xmm0
		movaps xmm5,xmm4
		addps xmm0,oword ptr e1_bias
		addps xmm4,oword ptr e1_bias
		movaps xmm2,xmm0
		movaps xmm6,xmm4
		subps xmm0,oword ptr e1_bias
		subps xmm4,oword ptr e1_bias
		pslld xmm2,23
		pslld xmm6,23
		subps xmm1,xmm0
		subps xmm5,xmm4
		movaps xmm0,xmm1
		movaps xmm4,xmm5
		mulps xmm1,xmm1
		mulps xmm5,xmm5
		mulps xmm0,oword ptr e1_c1
		mulps xmm4,oword ptr e1_c1
		mulps xmm1,oword ptr e1_c2
		mulps xmm5,oword ptr e1_c2
		addps xmm0,oword ptr e1_c0
		addps xmm4,oword ptr e1_c0
		addps xmm0,xmm1
		addps xmm4,xmm5
		paddd xmm0,xmm2
		paddd xmm4,xmm6
		movaps [eax],xmm0
		movaps [eax+16],xmm4
		add eax,32
		sub ecx,8
		jnz eloop8
		
		ret
		
e1_m16_SSE2 endp


e2_m16_SSE2 proc ptr_s:dword,n:dword

	public e2_m16_SSE2

		mov eax,ptr_s
		mov ecx,n
eloop4:
		movaps xmm0,[eax]
		minps xmm0,oword ptr exp_hi
		maxps xmm0,oword ptr exp_lo
		movaps xmm1,oword ptr exp_rln2
		mulps xmm1,xmm0
		xorps xmm2,xmm2
		addps xmm1,oword ptr am_0p5
		cmpnltps xmm2,xmm1
		pand xmm2,oword ptr epi32_1
		cvttps2dq xmm1,xmm1
		movaps xmm4,oword ptr exp_c2
		psubd xmm1,xmm2
		movaps xmm5,oword ptr exp_c1
		cvtdq2ps xmm3,xmm1
		mulps xmm4,xmm3
		mulps xmm5,xmm3
		movaps xmm6,oword ptr exp_q0
		subps xmm0,xmm4
		movaps xmm4,oword ptr exp_p0
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
		movaps [eax],xmm0
		add eax,16
		sub ecx,4
		jnz eloop4
		
		ret
		
e2_m16_SSE2 endp


weightedAvgElliottMul5_m16_SSE2 proc ptr_w:dword,n:dword,mstd:dword

	public weightedAvgElliottMul5_m16_SSE2

		push edi
		
		mov eax,ptr_w
		mov ecx,n
		lea edx,[eax+ecx*4]
		xor edi,edi
		xorps xmm0,xmm0
		xorps xmm1,xmm1
nloop_5:
		movaps xmm2,[eax+edi*4]
		movaps xmm3,[eax+edi*4+16]
		movaps xmm4,[edx+edi*4]
		movaps xmm5,[edx+edi*4+16]
		addps xmm0,xmm2
		movaps xmm6,xmm4
		movaps xmm7,xmm5
		addps xmm0,xmm3
		andps xmm4,oword ptr sign_bits_f
		andps xmm5,oword ptr sign_bits_f
		addps xmm4,oword ptr ones_f
		addps xmm5,oword ptr ones_f
		rcpps xmm4,xmm4
		rcpps xmm5,xmm5
		mulps xmm6,xmm4
		mulps xmm7,xmm5
		mulps xmm6,xmm2
		mulps xmm7,xmm3
		addps xmm1,xmm6
		addps xmm1,xmm7
		movaps xmm2,[eax+edi*4+32]
		movaps xmm3,[eax+edi*4+48]
		movaps xmm4,[edx+edi*4+32]
		movaps xmm5,[edx+edi*4+48]
		addps xmm0,xmm2
		movaps xmm6,xmm4
		movaps xmm7,xmm5
		addps xmm0,xmm3
		andps xmm4,oword ptr sign_bits_f
		andps xmm5,oword ptr sign_bits_f
		addps xmm4,oword ptr ones_f
		addps xmm5,oword ptr ones_f
		rcpps xmm4,xmm4
		rcpps xmm5,xmm5
		mulps xmm6,xmm4
		mulps xmm7,xmm5
		mulps xmm6,xmm2
		mulps xmm7,xmm3
		addps xmm1,xmm6
		addps xmm1,xmm7
		add edi,16
		sub ecx,16
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
		mov eax,mstd
		mulss xmm1,dword ptr[eax+4]
		addss xmm1,dword ptr[eax]
		addss xmm1,dword ptr[eax+12]
		movss dword ptr[eax+12],xmm1
		
		pop edi
		
		ret
		
weightedAvgElliottMul5_m16_SSE2 endp


castScale_SSE proc val:dword,scale:dword,dstp:dword,val_min:dword,val_max:dword

	public castScale_SSE
	
		mov ecx,val
		mov eax,scale
		
		movss xmm0,dword ptr[ecx+12]
		mulss xmm0,dword ptr[eax]
		addss xmm0,dword ptr sse_half
		cvttss2si eax,xmm0
		mov ecx,dstp
		cmp eax,val_max
		cmovnl eax,val_max
		cmp eax,val_min
		cmovng eax,val_min
		mov byte ptr[ecx],al
		
		ret
		
castScale_SSE endp


castScale_SSE_16 proc val:dword,scale:dword,dstp:dword,val_min:dword,val_max:dword

	public castScale_SSE_16
	
		mov ecx,val
		mov eax,scale
		
		movss xmm0,dword ptr[ecx+12]
		mulss xmm0,dword ptr[eax]
		addss xmm0,dword ptr sse_half
		cvttss2si eax,xmm0
		mov ecx,dstp
		cmp eax,val_max
		cmovnl eax,val_max
		cmp eax,val_min
		cmovng eax,val_min
		mov word ptr[ecx],ax
		
		ret
		
castScale_SSE_16 endp


uc2s64_SSE2 proc ptr_t:dword,pitch:dword,ptr_p:dword

	public uc2s64_SSE2
	
		mov eax,ptr_t
		mov ecx,pitch
		mov edx,ptr_p
		pxor xmm7,xmm7
		movq xmm0,QWORD PTR[eax]
		movq xmm1,QWORD PTR[eax+8]
		movq xmm2,QWORD PTR[eax+ecx*2]
		movq xmm3,QWORD PTR[eax+ecx*2+8]
		punpcklbw xmm0,xmm7
		punpcklbw xmm1,xmm7
		punpcklbw xmm2,xmm7
		punpcklbw xmm3,xmm7
		lea eax,[eax+ecx*4]
		movdqa [edx],xmm0
		movdqa [edx+16],xmm1
		movdqa [edx+32],xmm2
		movdqa [edx+48],xmm3
		movq xmm4,QWORD PTR[eax]
		movq xmm5,QWORD PTR[eax+8]
		movq xmm6,QWORD PTR[eax+ecx*2]
		movq xmm0,QWORD PTR[eax+ecx*2+8]
		punpcklbw xmm4,xmm7
		punpcklbw xmm5,xmm7
		punpcklbw xmm6,xmm7
		punpcklbw xmm0,xmm7
		movdqa [edx+64],xmm4
		movdqa [edx+80],xmm5
		movdqa [edx+96],xmm6
		movdqa [edx+112],xmm0
		
		ret
		
uc2s64_SSE2 endp



computeNetwork0new_SSE2 proc datai:dword,weights:dword,ptr_d:dword

	public computeNetwork0new_SSE2

		mov ecx,datai
		mov eax,weights
		movdqa xmm0,[ecx]
		movdqa xmm1,xmm0
		movdqa xmm2,xmm0
		movdqa xmm3,xmm0
		pmaddwd xmm0,[eax]
		pmaddwd xmm1,[eax+16]
		pmaddwd xmm2,[eax+32]
		pmaddwd xmm3,[eax+48]
		
		movdqa xmm4,[ecx+16]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[eax+64]
		pmaddwd xmm5,[eax+80]
		pmaddwd xmm6,[eax+96]
		pmaddwd xmm7,[eax+112]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[ecx+32]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[eax+128]
		pmaddwd xmm5,[eax+144]
		pmaddwd xmm6,[eax+160]
		pmaddwd xmm7,[eax+176]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[ecx+48]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[eax+192]
		pmaddwd xmm5,[eax+208]
		pmaddwd xmm6,[eax+224]
		pmaddwd xmm7,[eax+240]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[ecx+64]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[eax+256]
		pmaddwd xmm5,[eax+272]
		pmaddwd xmm6,[eax+288]
		pmaddwd xmm7,[eax+304]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[ecx+80]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[eax+320]
		pmaddwd xmm5,[eax+336]
		pmaddwd xmm6,[eax+352]
		pmaddwd xmm7,[eax+368]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[ecx+96]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[eax+384]
		pmaddwd xmm5,[eax+400]
		pmaddwd xmm6,[eax+416]
		pmaddwd xmm7,[eax+432]
		paddd xmm0,xmm4
		paddd xmm1,xmm5
		paddd xmm2,xmm6
		paddd xmm3,xmm7
		
		movdqa xmm4,[ecx+112]
		movdqa xmm5,xmm4
		movdqa xmm6,xmm4
		movdqa xmm7,xmm4
		pmaddwd xmm4,[eax+448]
		pmaddwd xmm5,[eax+464]
		pmaddwd xmm6,[eax+480]
		pmaddwd xmm7,[eax+496]
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
		mulps xmm0,[eax+512]
		addps xmm0,[eax+528]
		movaps xmm1,xmm0
		andps xmm0,oword ptr sign_bits_f
		addps xmm0,oword ptr ones_f
		rcpps xmm0,xmm0
		mulps xmm0,xmm1
		pshufd xmm1,xmm0,0
		pshufd xmm2,xmm0,85
		pshufd xmm3,xmm0,170
		pshufd xmm4,xmm0,255
		mulps xmm1,[eax+544]
		mulps xmm2,[eax+560]
		mulps xmm3,[eax+576]
		mulps xmm4,[eax+592]
		pxor xmm0,xmm0
		addps xmm1,xmm2
		addps xmm3,xmm4
		addps xmm1,xmm3
		mov ecx,ptr_d
		addps xmm1,[eax+608]
		cmpps xmm1,xmm0,1
		packssdw xmm1,xmm0
		packsswb xmm1,xmm0
		movd eax,xmm1
		xor eax,0FFFFFFFFh
		and eax,001010101h
		mov [ecx],eax
		
		ret
		
computeNetwork0new_SSE2 endp

end
