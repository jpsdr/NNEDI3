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


computeNetwork0_AVX proc input:dword,weights:dword,ptr_d:dword

    public computeNetwork0_AVX
	
		mov ecx,input
		mov edx,weights
		mov eax,1
		
		vmovaps xmm7,XMMWORD ptr [ecx]
		vmulps xmm0,xmm7,XMMWORD ptr [edx]
		vmulps xmm1,xmm7,XMMWORD ptr [edx+16]
		vmulps xmm2,xmm7,XMMWORD ptr [edx+32]
		vmulps xmm3,xmm7,XMMWORD ptr [edx+48]
		
		vmovaps xmm7,XMMWORD ptr [ecx+16]
		vmulps xmm4,xmm7,XMMWORD ptr [edx+64]
		vmulps xmm5,xmm7,XMMWORD ptr [edx+80]
		vmulps xmm6,xmm7,XMMWORD ptr [edx+96]
		vmulps xmm7,xmm7,XMMWORD ptr [edx+112]
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7
		
		vmovaps xmm7,XMMWORD ptr [ecx+32]
		vmulps xmm4,xmm7,XMMWORD ptr [edx+128]
		vmulps xmm5,xmm7,XMMWORD ptr [edx+144]
		vmulps xmm6,xmm7,XMMWORD ptr [edx+160]
		vmulps xmm7,xmm7,XMMWORD ptr [edx+176]
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7
		
		vmovaps xmm7,XMMWORD ptr [ecx+48]
		vmulps xmm4,xmm7,XMMWORD ptr [edx+192]
		vmulps xmm5,xmm7,XMMWORD ptr [edx+208]
		vmulps xmm6,xmm7,XMMWORD ptr [edx+224]
		vmulps xmm7,xmm7,XMMWORD ptr [edx+240]
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7
		
		vmovaps xmm7,XMMWORD ptr [ecx+64]
		vmulps xmm4,xmm7,XMMWORD ptr [edx+256]
		vmulps xmm5,xmm7,XMMWORD ptr [edx+272]
		vmulps xmm6,xmm7,XMMWORD ptr [edx+288]
		vmulps xmm7,xmm7,XMMWORD ptr [edx+304]
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7
		
		vmovaps xmm7,XMMWORD ptr [ecx+80]
		vmulps xmm4,xmm7,XMMWORD ptr [edx+320]
		vmulps xmm5,xmm7,XMMWORD ptr [edx+336]
		vmulps xmm6,xmm7,XMMWORD ptr [edx+352]
		vmulps xmm7,xmm7,XMMWORD ptr [edx+368]
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7
		
		vmovaps xmm7,XMMWORD ptr [ecx+96]
		vmulps xmm4,xmm7,XMMWORD ptr [edx+384]
		vmulps xmm5,xmm7,XMMWORD ptr [edx+400]
		vmulps xmm6,xmm7,XMMWORD ptr [edx+416]
		vmulps xmm7,xmm7,XMMWORD ptr [edx+432]
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7
		
		vmovaps xmm7,XMMWORD ptr [ecx+112]
		vmulps xmm4,xmm7,XMMWORD ptr [edx+448]
		vmulps xmm5,xmm7,XMMWORD ptr [edx+464]
		vmulps xmm6,xmm7,XMMWORD ptr [edx+480]
		vmulps xmm7,xmm7,XMMWORD ptr [edx+496]
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7
		
		vmovaps xmm7,XMMWORD ptr [ecx+128]
		vmulps xmm4,xmm7,XMMWORD ptr [edx+512]
		vmulps xmm5,xmm7,XMMWORD ptr [edx+528]
		vmulps xmm6,xmm7,XMMWORD ptr [edx+544]
		vmulps xmm7,xmm7,XMMWORD ptr [edx+560]
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7
		
		vmovaps xmm7,XMMWORD ptr [ecx+144]
		vmulps xmm4,xmm7,XMMWORD ptr [edx+576]
		vmulps xmm5,xmm7,XMMWORD ptr [edx+592]
		vmulps xmm6,xmm7,XMMWORD ptr [edx+608]
		vmulps xmm7,xmm7,XMMWORD ptr [edx+624]
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7
		
		vmovaps xmm7,XMMWORD ptr [ecx+160]
		vmulps xmm4,xmm7,XMMWORD ptr [edx+640]
		vmulps xmm5,xmm7,XMMWORD ptr [edx+656]
		vmulps xmm6,xmm7,XMMWORD ptr [edx+672]
		vmulps xmm7,xmm7,XMMWORD ptr [edx+688]
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7
		
		vmovaps xmm7,XMMWORD ptr [ecx+176]
		vmulps xmm4,xmm7,XMMWORD ptr [edx+704]
		vmulps xmm5,xmm7,XMMWORD ptr [edx+720]
		vmulps xmm6,xmm7,XMMWORD ptr [edx+736]
		vmulps xmm7,xmm7,XMMWORD ptr [edx+752]
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7
		
		vunpckhpd xmm4,xmm0,xmm1
		vunpckhpd xmm5,xmm2,xmm3
		vunpcklpd xmm0,xmm0,xmm1
		vunpcklpd xmm2,xmm2,xmm3
		vaddps xmm0,xmm0,xmm4
		vaddps xmm2,xmm2,xmm5		
		vshufps xmm6,xmm0,xmm2,221
		vshufps xmm0,xmm0,xmm2,136
		
		vaddps xmm0,xmm0,xmm6
		vaddps xmm0,xmm0,XMMWORD ptr [edx+768]
		
		vandps xmm1,xmm0,XMMWORD ptr sign_bits_f_zero_l
		vaddps xmm1,xmm1,XMMWORD ptr ones_f
		vrcpps xmm1,xmm1
		vmulps xmm0,xmm0,xmm1
		vpshufd xmm1,xmm0,0
		vpshufd xmm2,xmm0,85
		vpshufd xmm3,xmm0,170
		vpshufd xmm4,xmm0,255
		vmulps xmm1,xmm1,XMMWORD ptr [edx+784]
		vmulps xmm2,xmm2,XMMWORD ptr [edx+784+16]
		vmulps xmm3,xmm3,XMMWORD ptr [edx+784+32]
		vmulps xmm4,xmm4,XMMWORD ptr [edx+784+48]
		vaddps xmm1,xmm1,xmm2
		vaddps xmm3,xmm3,xmm4
		vaddps xmm1,xmm1,xmm3
		vaddps xmm1,xmm1,XMMWORD ptr [edx+784+64]

		vandps xmm7,xmm1,XMMWORD ptr sign_bits_f
		vmovaps xmm3,xmm0
		vaddps xmm7,xmm7,XMMWORD ptr ones_f
		vrcpps xmm7,xmm7
		vmulps xmm7,xmm7,xmm1
		
		vpshufd xmm0,xmm0,0
		vpshufd xmm1,xmm3,85
		vpshufd xmm2,xmm3,170
		vpshufd xmm3,xmm3,255
		vmulps xmm0,xmm0,XMMWORD ptr [edx+864]
		vmulps xmm1,xmm1,XMMWORD ptr [edx+864+16]
		vmulps xmm2,xmm2,XMMWORD ptr [edx+864+32]
		vmulps xmm3,xmm3,XMMWORD ptr [edx+864+48]
		vpshufd xmm4,xmm7,0
		vpshufd xmm5,xmm7,85
		vpshufd xmm6,xmm7,170
		vpshufd xmm7,xmm7,255
		vmulps xmm4,xmm4,XMMWORD ptr [edx+864+64]
		vmulps xmm5,xmm5,XMMWORD ptr [edx+864+80]
		vmulps xmm6,xmm6,XMMWORD ptr [edx+864+96]
		vmulps xmm7,xmm7,XMMWORD ptr [edx+864+112]
		vaddps xmm0,xmm0,xmm1
		vaddps xmm2,xmm2,xmm3
		vaddps xmm4,xmm4,xmm5
		vaddps xmm6,xmm6,xmm7
		vaddps xmm0,xmm0,xmm2
		vaddps xmm4,xmm4,xmm6
		vaddps xmm0,xmm0,xmm4
		mov ecx,ptr_d
		vaddps xmm0,xmm0,XMMWORD ptr [edx+864+128]
		vmovhlps xmm1,xmm1,xmm0
		vmaxps xmm0,xmm0,xmm1
		vpshuflw xmm1,xmm0,14
		vcomiss xmm1,xmm0
		jbe finish_1_AVX
		xor eax,eax
finish_1_AVX:
		mov BYTE PTR[ecx],al
		
		ret

computeNetwork0_AVX endp


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


computeNetwork0_i16_AVX proc inputf:dword,weightsf:dword,ptr_d:dword

    public computeNetwork0_i16_AVX

		mov ecx,inputf
		mov edx,weightsf
		mov eax,1
		
		vmovdqa xmm7,XMMWORD ptr [ecx]
		vpmaddwd xmm0,xmm7,XMMWORD ptr [edx]
		vpmaddwd xmm1,xmm7,XMMWORD ptr [edx+16]
		vpmaddwd xmm2,xmm7,XMMWORD ptr [edx+32]
		vpmaddwd xmm3,xmm7,XMMWORD ptr [edx+48]
		
		vmovdqa xmm7,XMMWORD ptr [ecx+16]
		vpmaddwd xmm4,xmm7,XMMWORD ptr [edx+64]
		vpmaddwd xmm5,xmm7,XMMWORD ptr [edx+80]
		vpmaddwd xmm6,xmm7,XMMWORD ptr [edx+96]
		vpmaddwd xmm7,xmm7,XMMWORD ptr [edx+112]
		vpaddd xmm0,xmm0,xmm4
		vpaddd xmm1,xmm1,xmm5
		vpaddd xmm2,xmm2,xmm6
		vpaddd xmm3,xmm3,xmm7
		
		vmovdqa xmm7,XMMWORD ptr [ecx+32]
		vpmaddwd xmm4,xmm7,XMMWORD ptr [edx+128]
		vpmaddwd xmm5,xmm7,XMMWORD ptr [edx+144]
		vpmaddwd xmm6,xmm7,XMMWORD ptr [edx+160]
		vpmaddwd xmm7,xmm7,XMMWORD ptr [edx+176]
		vpaddd xmm0,xmm0,xmm4
		vpaddd xmm1,xmm1,xmm5
		vpaddd xmm2,xmm2,xmm6
		vpaddd xmm3,xmm3,xmm7
		
		vmovdqa xmm7,XMMWORD ptr [ecx+48]
		vpmaddwd xmm4,xmm7,XMMWORD ptr [edx+192]
		vpmaddwd xmm5,xmm7,XMMWORD ptr [edx+208]
		vpmaddwd xmm6,xmm7,XMMWORD ptr [edx+224]
		vpmaddwd xmm7,xmm7,XMMWORD ptr [edx+240]
		vpaddd xmm0,xmm0,xmm4
		vpaddd xmm1,xmm1,xmm5
		vpaddd xmm2,xmm2,xmm6
		vpaddd xmm3,xmm3,xmm7
		
		vmovdqa xmm7,XMMWORD ptr [ecx+64]
		vpmaddwd xmm4,xmm7,XMMWORD ptr [edx+256]
		vpmaddwd xmm5,xmm7,XMMWORD ptr [edx+272]
		vpmaddwd xmm6,xmm7,XMMWORD ptr [edx+288]
		vpmaddwd xmm7,xmm7,XMMWORD ptr [edx+304]
		vpaddd xmm0,xmm0,xmm4
		vpaddd xmm1,xmm1,xmm5
		vpaddd xmm2,xmm2,xmm6
		vpaddd xmm3,xmm3,xmm7
		
		vmovdqa xmm7,XMMWORD ptr [ecx+80]
		vpmaddwd xmm4,xmm7,XMMWORD ptr [edx+320]
		vpmaddwd xmm5,xmm7,XMMWORD ptr [edx+336]
		vpmaddwd xmm6,xmm7,XMMWORD ptr [edx+352]
		vpmaddwd xmm7,xmm7,XMMWORD ptr [edx+368]
		vpaddd xmm0,xmm0,xmm4
		vpaddd xmm1,xmm1,xmm5
		vpaddd xmm2,xmm2,xmm6
		vpaddd xmm3,xmm3,xmm7
		
		vpunpckhqdq xmm4,xmm0,xmm1
		vpunpckhqdq xmm5,xmm2,xmm3
		vpunpcklqdq xmm0,xmm0,xmm1
		vpunpcklqdq xmm2,xmm2,xmm3
		vpaddd xmm0,xmm0,xmm4
		vpaddd xmm2,xmm2,xmm5
		vshufps xmm6,xmm0,xmm2,221
		vshufps xmm0,xmm0,xmm2,136
		
		vpaddd xmm0,xmm0,xmm6
		vcvtdq2ps xmm0,xmm0
		vmulps xmm0,xmm0,XMMWORD ptr [edx+384]
		vaddps xmm0,xmm0,XMMWORD ptr [edx+400]

		vandps xmm1,xmm0,XMMWORD ptr sign_bits_f_zero_l
		vaddps xmm1,xmm1,XMMWORD ptr ones_f
		vrcpps xmm1,xmm1
		vmulps xmm0,xmm0,xmm1		
		vpshufd xmm1,xmm0,0
		vpshufd xmm2,xmm0,85
		vpshufd xmm3,xmm0,170
		vpshufd xmm4,xmm0,255
		vmulps xmm1,xmm1,XMMWORD ptr [edx+416]
		vmulps xmm2,xmm2,XMMWORD ptr [edx+416+16]
		vmulps xmm3,xmm3,XMMWORD ptr [edx+416+32]
		vmulps xmm4,xmm4,XMMWORD ptr [edx+416+48]
		vaddps xmm1,xmm1,xmm2
		vaddps xmm3,xmm3,xmm4
		vaddps xmm1,xmm1,xmm3
		vaddps xmm1,xmm1,XMMWORD ptr [edx+416+64]
		
		vandps xmm7,xmm1,XMMWORD ptr sign_bits_f
		vmovaps xmm3,xmm0
		vaddps xmm7,xmm7,XMMWORD ptr ones_f
		vrcpps xmm7,xmm7
		vmulps xmm7,xmm7,xmm1
	
		vpshufd xmm0,xmm0,0
		vpshufd xmm1,xmm3,85
		vpshufd xmm2,xmm3,170
		vpshufd xmm3,xmm3,255
		vmulps xmm0,xmm0,XMMWORD ptr [edx+496]
		vmulps xmm1,xmm1,XMMWORD ptr [edx+496+16]
		vmulps xmm2,xmm2,XMMWORD ptr [edx+496+32]
		vmulps xmm3,xmm3,XMMWORD ptr [edx+496+48]
		vpshufd xmm4,xmm7,0
		vpshufd xmm5,xmm7,85
		vpshufd xmm6,xmm7,170
		vpshufd xmm7,xmm7,255
		vmulps xmm4,xmm4,XMMWORD ptr [edx+496+64]
		vmulps xmm5,xmm5,XMMWORD ptr [edx+496+80]
		vmulps xmm6,xmm6,XMMWORD ptr [edx+496+96]
		vmulps xmm7,xmm7,XMMWORD ptr [edx+496+112]
		vaddps xmm0,xmm0,xmm1
		vaddps xmm2,xmm2,xmm3
		vaddps xmm4,xmm4,xmm5
		vaddps xmm6,xmm6,xmm7
		vaddps xmm0,xmm0,xmm2
		vaddps xmm4,xmm4,xmm6
		vaddps xmm0,xmm0,xmm4
		mov ecx,ptr_d
		vaddps xmm0,xmm0,XMMWORD ptr [edx+496+128]
		vmovhlps xmm1,xmm1,xmm0
		vmaxps xmm0,xmm0,xmm1
		vpshuflw xmm1,xmm0,14
		vcomiss xmm1,xmm0
		jbe finish_2_AVX
		xor eax,eax
finish_2_AVX:
		mov BYTE PTR[ecx],al
		ret
		
computeNetwork0_i16_AVX endp


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


uc2f48_AVX proc ptr_t:dword,pitch:dword,ptr_p:dword

    public uc2f48_AVX

		mov eax,ptr_t
		mov ecx,pitch
		mov edx,ptr_p
		
		vpxor xmm6,xmm6,xmm6
		
		vmovq xmm0,QWORD PTR[eax]
		vmovd xmm4,dword  ptr[eax+8]
		vmovq xmm2,QWORD PTR[eax+ecx*2]
		vmovd xmm5,dword ptr[eax+ecx*2+8]
		vpunpcklbw xmm0,xmm0,xmm6
		vpunpcklbw xmm4,xmm4,xmm6
		vpunpcklbw xmm2,xmm2,xmm6
		vpunpcklbw xmm5,xmm5,xmm6
		
		vpunpcklbw xmm4,xmm4,xmm6
		vpunpcklbw xmm5,xmm5,xmm6
		vpunpckhbw xmm1,xmm0,xmm6
		vpunpckhbw xmm3,xmm2,xmm6
		vpunpcklbw xmm0,xmm0,xmm6
		vpunpcklbw xmm2,xmm2,xmm6
		
		lea eax,[eax+ecx*4]
		vcvtdq2ps xmm4,xmm4
		vcvtdq2ps xmm5,xmm5
		vcvtdq2ps xmm0,xmm0
		vcvtdq2ps xmm1,xmm1
		vcvtdq2ps xmm2,xmm2
		vcvtdq2ps xmm3,xmm3
		
		vmovaps XMMWORD ptr [edx],xmm0
		vmovaps XMMWORD ptr [edx+16],xmm1
		vmovaps XMMWORD ptr [edx+32],xmm4
		vmovaps XMMWORD ptr [edx+48],xmm2
		vmovaps XMMWORD ptr [edx+64],xmm3
		vmovaps XMMWORD ptr [edx+80],xmm5
		
		vmovq xmm0,QWORD PTR[eax]
		vmovd xmm4,dword ptr[eax+8]
		vmovq xmm2,QWORD PTR[eax+ecx*2]
		vmovd xmm5,dword ptr[eax+ecx*2+8]
		
		vpunpcklbw xmm0,xmm0,xmm6
		vpunpcklbw xmm4,xmm4,xmm6
		vpunpcklbw xmm2,xmm2,xmm6
		vpunpcklbw xmm5,xmm5,xmm6
		
		vpunpcklbw xmm4,xmm4,xmm6
		vpunpcklbw xmm5,xmm5,xmm6
		vpunpckhbw xmm1,xmm0,xmm6
		vpunpckhbw xmm3,xmm2,xmm6
		vpunpcklbw xmm0,xmm0,xmm6
		vpunpcklbw xmm2,xmm2,xmm6
		
		vcvtdq2ps xmm4,xmm4
		vcvtdq2ps xmm5,xmm5
		vcvtdq2ps xmm0,xmm0
		vcvtdq2ps xmm1,xmm1
		vcvtdq2ps xmm2,xmm2
		vcvtdq2ps xmm3,xmm3
		
		vmovaps XMMWORD ptr [edx+96],xmm0
		vmovaps XMMWORD ptr [edx+112],xmm1
		vmovaps XMMWORD ptr [edx+128],xmm4
		vmovaps XMMWORD ptr [edx+144],xmm2
		vmovaps XMMWORD ptr [edx+160],xmm3
		vmovaps XMMWORD ptr [edx+176],xmm5
		
		ret
		
uc2f48_AVX endp


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


uc2f48_AVX_16 proc ptr_t:dword,pitch:dword,ptr_p:dword

    public uc2f48_AVX_16

		mov eax,ptr_t
		mov ecx,pitch
		mov edx,ptr_p
		
		vpxor xmm6,xmm6,xmm6
		
		vmovq xmm0,qword ptr[eax]
		vmovq xmm1,qword ptr[eax+8]
		vmovq xmm2,qword ptr[eax+16]
		vmovq xmm3,qword ptr[eax+ecx*2]
		vmovq xmm4,qword ptr[eax+ecx*2+8]
		vmovq xmm5,qword ptr[eax+ecx*2+16]
		
		vpunpcklwd xmm0,xmm0,xmm6
		vpunpcklwd xmm1,xmm1,xmm6
		vpunpcklwd xmm2,xmm2,xmm6
		vpunpcklwd xmm3,xmm3,xmm6
		vpunpcklwd xmm4,xmm4,xmm6
		vpunpcklwd xmm5,xmm5,xmm6
		
		lea eax,[eax+ecx*4]
		vcvtdq2ps xmm0,xmm0
		vcvtdq2ps xmm1,xmm1
		vcvtdq2ps xmm2,xmm2
		vcvtdq2ps xmm3,xmm3
		vcvtdq2ps xmm4,xmm4
		vcvtdq2ps xmm5,xmm5
		vmovaps XMMWORD ptr [edx],xmm0
		vmovaps XMMWORD ptr [edx+16],xmm1
		vmovaps XMMWORD ptr [edx+32],xmm2
		vmovaps XMMWORD ptr [edx+48],xmm3
		vmovaps XMMWORD ptr [edx+64],xmm4
		vmovaps XMMWORD ptr [edx+80],xmm5
		
		vmovq xmm0,qword ptr[eax]
		vmovq xmm1,qword ptr[eax+8]
		vmovq xmm2,qword ptr[eax+16]
		vmovq xmm3,qword ptr[eax+ecx*2]
		vmovq xmm4,qword ptr[eax+ecx*2+8]
		vmovq xmm5,qword ptr[eax+ecx*2+16]
		vpunpcklwd xmm0,xmm0,xmm6
		vpunpcklwd xmm1,xmm1,xmm6
		vpunpcklwd xmm2,xmm2,xmm6
		vpunpcklwd xmm3,xmm3,xmm6
		vpunpcklwd xmm4,xmm4,xmm6
		vpunpcklwd xmm5,xmm5,xmm6
		
		vcvtdq2ps xmm0,xmm0
		vcvtdq2ps xmm1,xmm1
		vcvtdq2ps xmm2,xmm2
		vcvtdq2ps xmm3,xmm3
		vcvtdq2ps xmm4,xmm4
		vcvtdq2ps xmm5,xmm5
		vmovaps XMMWORD ptr [edx+96],xmm0
		vmovaps XMMWORD ptr [edx+112],xmm1
		vmovaps XMMWORD ptr [edx+128],xmm2
		vmovaps XMMWORD ptr [edx+144],xmm3
		vmovaps XMMWORD ptr [edx+160],xmm4
		vmovaps XMMWORD ptr [edx+176],xmm5
		
		ret
		
uc2f48_AVX_16 endp


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


uc2s48_AVX proc ptr_t:dword,pitch:dword,ptr_pf:dword

    public uc2s48_AVX

		mov eax,ptr_t
		mov ecx,pitch
		lea edx,[eax+ecx*4]
		
		vmovq xmm0,QWORD PTR[eax]
		vmovd xmm1,dword ptr[eax+8]
		vmovd xmm2,dword ptr[eax+ecx*2]
		vmovq xmm3,QWORD PTR[eax+ecx*2+4]
		vmovq xmm4,QWORD PTR[edx]
		vmovd xmm5,dword ptr[edx+8]
		vmovd xmm6,dword ptr[edx+ecx*2]
		vmovq xmm7,QWORD PTR[edx+ecx*2+4]
		vpunpckldq xmm1,xmm1,xmm2
		vpxor xmm2,xmm2,xmm2
		vpunpckldq xmm5,xmm5,xmm6
		mov edx,ptr_pf
		vpunpcklbw xmm0,xmm0,xmm2
		vpunpcklbw xmm3,xmm3,xmm2
		vpunpcklbw xmm1,xmm1,xmm2
		vpunpcklbw xmm4,xmm4,xmm2
		vpunpcklbw xmm5,xmm5,xmm2
		vpunpcklbw xmm7,xmm7,xmm2
		vmovdqa XMMWORD ptr [edx],xmm0
		vmovdqa XMMWORD ptr [edx+16],xmm1
		vmovdqa XMMWORD ptr [edx+32],xmm3
		vmovdqa XMMWORD ptr [edx+48],xmm4
		vmovdqa XMMWORD ptr [edx+64],xmm5
		vmovdqa XMMWORD ptr [edx+80],xmm7
		
		ret

uc2s48_AVX endp


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


processLine0_AVX_ASM proc tempu:dword,width_:dword,dstp:dword,src3p:dword,src_pitch:dword,val_min:word,val_max:word

    public processLine0_AVX_ASM
	
		push ebx
		push edi
		push esi

		movzx eax,val_min
		vpinsrw xmm0,xmm0,eax,0
		vpinsrw xmm0,xmm0,eax,1
		vpinsrw xmm0,xmm0,eax,2
		vpinsrw xmm0,xmm0,eax,3
		vpinsrw xmm0,xmm0,eax,4
		vpinsrw xmm0,xmm0,eax,5
		vpinsrw xmm0,xmm0,eax,6
		vpinsrw xmm0,xmm0,eax,7
		vmovdqa XMMWORD ptr w_16,xmm0		
		
		movzx eax,val_max
		vpinsrw xmm0,xmm0,eax,0
		vpinsrw xmm0,xmm0,eax,1
		vpinsrw xmm0,xmm0,eax,2
		vpinsrw xmm0,xmm0,eax,3
		vpinsrw xmm0,xmm0,eax,4
		vpinsrw xmm0,xmm0,eax,5
		vpinsrw xmm0,xmm0,eax,6
		vpinsrw xmm0,xmm0,eax,7
		vmovdqa XMMWORD ptr w_254,xmm0	
				
		mov eax,tempu
		mov ebx,src3p
		mov ecx,width_
		mov edx,src_pitch
		mov esi,dstp
		lea edi,[ebx+edx*4]
		vpxor xmm6,xmm6,xmm6
		vpxor xmm7,xmm7,xmm7
xloop_AVX:
		vmovdqa xmm0,XMMWORD ptr [ebx+edx*2]
		vmovdqa xmm1,XMMWORD ptr [edi]
		vpunpckhbw xmm2,xmm0,xmm7
		vpunpcklbw xmm0,xmm0,xmm7
		vpunpckhbw xmm3,xmm1,xmm7
		vpunpcklbw xmm1,xmm1,xmm7
		
		vpaddw xmm0,xmm0,xmm1
		vpaddw xmm2,xmm2,xmm3
		vpmullw xmm0,xmm0,XMMWORD ptr w_19
		vpmullw xmm2,xmm2,XMMWORD ptr w_19
		vmovdqa xmm1,XMMWORD ptr [ebx]
		vmovdqa xmm3,XMMWORD ptr [edi+edx*2]
		vpunpckhbw xmm4,xmm1,xmm7
		vpunpcklbw xmm1,xmm1,xmm7
		vpunpckhbw xmm5,xmm3,xmm7
		vpunpcklbw xmm3,xmm3,xmm7
		
		vpaddw xmm1,xmm1,xmm3
		vpaddw xmm4,xmm4,xmm5
		vpmullw xmm1,xmm1,XMMWORD ptr w_3
		vpmullw xmm4,xmm4,XMMWORD ptr w_3
		vmovdqa xmm5,XMMWORD ptr [eax]
		vpsubusw xmm0,xmm0,xmm1
		vpsubusw xmm2,xmm2,xmm4
		vpxor xmm5,xmm5,XMMWORD ptr ub_1
		vpaddusw xmm0,xmm0,XMMWORD ptr uw_16
		vpaddusw xmm2,xmm2,XMMWORD ptr uw_16
		vpsadbw xmm5,xmm5,xmm7
		vpsraw xmm0,xmm0,5
		vpsraw xmm2,xmm2,5
		vpminsw xmm0,xmm0,XMMWORD ptr w_254
		vpminsw xmm2,xmm2,XMMWORD ptr w_254
		vpsrldq xmm3,xmm5,8
		vpmaxsw xmm0,xmm0,XMMWORD ptr w_16
		vpmaxsw xmm2,xmm2,XMMWORD ptr w_16
		vpaddusw xmm5,xmm3,xmm5
		vpackuswb xmm0,xmm0,xmm2
		vmovdqa XMMWORD ptr [esi],xmm0
		vpaddusw xmm6,xmm6,xmm5
		add ebx,16
		add edi,16
		add eax,16
		add esi,16
		sub ecx,16
		jnz xloop_AVX
		
		pop esi
		pop edi
		pop ebx
		
		vmovd eax,xmm6
		
		ret
		
processLine0_AVX_ASM endp


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


processLine0_AVX_ASM_16 proc tempu:dword,width_:dword,dstp:dword,src3p:dword,src_pitch:dword,val_min:word,val_max:word

    public processLine0_AVX_ASM_16
	
		push ebx
		push edi
		push esi

		movzx eax,val_min
		vpinsrw xmm0,xmm0,eax,0
		vpinsrw xmm0,xmm0,eax,1
		vpinsrw xmm0,xmm0,eax,2
		vpinsrw xmm0,xmm0,eax,3
		vpinsrw xmm0,xmm0,eax,4
		vpinsrw xmm0,xmm0,eax,5
		vpinsrw xmm0,xmm0,eax,6
		vpinsrw xmm0,xmm0,eax,7
		vmovdqa XMMWORD ptr w_16,xmm0		
		
		movzx eax,val_max
		vpinsrw xmm0,xmm0,eax,0
		vpinsrw xmm0,xmm0,eax,1
		vpinsrw xmm0,xmm0,eax,2
		vpinsrw xmm0,xmm0,eax,3
		vpinsrw xmm0,xmm0,eax,4
		vpinsrw xmm0,xmm0,eax,5
		vpinsrw xmm0,xmm0,eax,6
		vpinsrw xmm0,xmm0,eax,7
		vmovdqa XMMWORD ptr w_254,xmm0		
				
		mov eax,tempu
		mov ebx,src3p
		mov ecx,width_
		mov edx,src_pitch
		mov esi,dstp
		lea edi,[ebx+edx*4]
		vpxor xmm6,xmm6,xmm6
		vpxor xmm7,xmm7,xmm7		
xloop_16_AVX:
		vmovdqa xmm0,XMMWORD ptr [ebx+edx*2]
		vmovdqa xmm1,XMMWORD ptr [edi]
		vpunpckhwd xmm2,xmm0,xmm7
		vpunpcklwd xmm0,xmm0,xmm7
		vpunpckhwd xmm3,xmm1,xmm7
		vpunpcklwd xmm1,xmm1,xmm7
		vpaddd xmm0,xmm0,xmm1
		vpaddd xmm2,xmm2,xmm3
		vpmulld xmm0,xmm0,XMMWORD ptr d_19
		vpmulld xmm2,xmm2,XMMWORD ptr d_19
		vmovdqa xmm1,XMMWORD ptr [ebx]
		vmovdqa xmm3,XMMWORD ptr [edi+edx*2]
		vpunpckhwd xmm4,xmm1,xmm7
		vpunpcklwd xmm1,xmm1,xmm7
		vpunpckhwd xmm5,xmm3,xmm7
		vpunpcklwd xmm3,xmm3,xmm7
		vpaddd xmm1,xmm1,xmm3
		vpaddd xmm4,xmm4,xmm5
		vpmulld xmm1,xmm1,XMMWORD ptr d_3
		vpmulld xmm4,xmm4,XMMWORD ptr d_3
		vmovq xmm5,qword ptr [eax]
		vpsubd xmm0,xmm0,xmm1
		vpunpcklbw xmm5,xmm5,xmm7
		vpsubd xmm2,xmm2,xmm4
		vpxor xmm5,xmm5,XMMWORD ptr uw_1
		vpaddd xmm0,xmm0,XMMWORD ptr ud_16
		vpaddd xmm2,xmm2,XMMWORD ptr ud_16
		vpsadbw xmm5,xmm5,xmm7		
		vpsrad xmm0,xmm0,5
		vpsrad xmm2,xmm2,5
		vpackusdw xmm0,xmm0,xmm2
		vpsrldq xmm3,xmm5,8
		vpminuw xmm0,xmm0,XMMWORD ptr w_254
		vpmaxuw xmm0,xmm0,XMMWORD ptr w_16
		vpaddusw xmm5,xmm3,xmm5
		vmovdqa XMMWORD ptr [esi],xmm0
		vpaddusw xmm6,xmm6,xmm5
		add ebx,16
		add edi,16
		add eax,8
		add esi,16
		sub ecx,8
		jnz xloop_16_AVX
		
		pop esi
		pop edi
		pop ebx
		
		vmovd eax,xmm6
		
		ret
		
processLine0_AVX_ASM_16 endp


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


processLine0_AVX_ASM_32 proc tempu:dword,width_:dword,dstp:dword,src3p:dword,src_pitch:dword

    public processLine0_AVX_ASM_32
	
		push ebx
		push edi
		push esi

		mov eax,tempu
		mov ebx,src3p
		mov ecx,width_
		mov edx,src_pitch
		mov esi,dstp
		lea edi,[ebx+edx*4]
		vpxor xmm5,xmm5,xmm5
		vpxor xmm6,xmm6,xmm6		
		
xloop_32_AVX:
		vmovd xmm4,dword ptr [eax]
		vmovaps xmm2,XMMWORD ptr [ebx]		
		vmovaps xmm0,XMMWORD ptr [ebx+edx*2]
		vpunpcklbw xmm4,xmm4,xmm6		
		vmovaps xmm1,XMMWORD ptr [edi]
		vmovaps xmm3,XMMWORD ptr [edi+edx*2]		
		vpunpcklwd xmm4,xmm4,xmm6
		vaddps xmm0,xmm0,xmm1
		vpxor xmm4,xmm4,XMMWORD ptr dw_1		
		vaddps xmm2,xmm2,xmm3		
		vpsadbw xmm4,xmm4,xmm6
		vmulps xmm0,xmm0,XMMWORD ptr f_19
		vmulps xmm2,xmm2,XMMWORD ptr f_3
		vpsrldq xmm3,xmm4,8
		vsubps xmm0,xmm0,xmm2	
		vpaddusw xmm4,xmm3,xmm4
		vmovaps XMMWORD ptr [esi],xmm0
		vpaddusw xmm5,xmm5,xmm4
		add ebx,16
		add edi,16
		add eax,4
		add esi,16
		sub ecx,4
		jnz xloop_32_AVX
		
		pop esi
		pop edi
		pop ebx
		
		vmovd eax,xmm5
		
		ret
		
processLine0_AVX_ASM_32 endp


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


extract_m8_AVX proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,input:dword

	public extract_m8_AVX
	
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
		vpxor xmm5,xmm5,xmm5
		vpxor xmm6,xmm6,xmm6
		vpxor xmm3,xmm3,xmm3
		
yloop2_AVX:
		xor ecx,ecx
xloop2_AVX:
		vmovq xmm0,QWORD PTR[eax+ecx]
		vmovq xmm2,QWORD PTR[edx+ecx]
		vpunpcklbw xmm0,xmm0,xmm3
		vpunpcklbw xmm2,xmm2,xmm3		
		vpunpckhwd xmm1,xmm0,xmm3
		vpunpcklwd xmm0,xmm0,xmm3
		vpunpckhwd xmm4,xmm2,xmm3
		vpunpcklwd xmm2,xmm2,xmm3		
		vcvtdq2ps xmm0,xmm0
		vcvtdq2ps xmm1,xmm1
		vcvtdq2ps xmm2,xmm2
		vcvtdq2ps xmm4,xmm4
		vmovaps XMMWORD ptr [esi],xmm0
		vmovaps XMMWORD ptr [esi+16],xmm1
		vmovaps XMMWORD ptr [esi+edi*4],xmm2
		vmovaps XMMWORD ptr [esi+edi*4+16],xmm4
		vaddps xmm5,xmm5,xmm0
		vaddps xmm5,xmm5,xmm1
		vaddps xmm5,xmm5,xmm2
		vaddps xmm5,xmm5,xmm4
		vmulps xmm0,xmm0,xmm0
		vmulps xmm1,xmm1,xmm1
		vmulps xmm2,xmm2,xmm2
		vmulps xmm4,xmm4,xmm4
		vaddps xmm0,xmm0,xmm1
		vaddps xmm2,xmm2,xmm4
		vaddps xmm6,xmm6,xmm0
		vaddps xmm6,xmm6,xmm2
		add ecx,8
		add esi,32
		cmp ecx,edi
		jl xloop2_AVX
		lea eax,[eax+ebx*4]
		lea edx,[edx+ebx*4]
		lea esi,[esi+edi*4]
		sub ydia_,2
		jnz yloop2_AVX
		mov eax,ydia
		vmovhlps xmm0,xmm0,xmm5
		vmovhlps xmm1,xmm1,xmm6
		mul edi
		vaddps xmm5,xmm5,xmm0
		vaddps xmm6,xmm6,xmm1
		vcvtsi2ss xmm7,xmm7,eax
		vpshuflw xmm0,xmm5,14
		vpshuflw xmm1,xmm6,14
		vrcpss xmm7,xmm7,xmm7
		vaddss xmm5,xmm5,xmm0
		vaddss xmm6,xmm6,xmm1
		mov eax,mstd
		vmulss xmm5,xmm5,xmm7
		vmulss xmm6,xmm6,xmm7
		vmovss dword ptr[eax],xmm5
		vmulss xmm5,xmm5,xmm5
		vsubss xmm6,xmm6,xmm5
		vcomiss xmm6,dword ptr flt_epsilon_sse
		jbe novarjmp_AVX
		vrsqrtss xmm6,xmm6,xmm6
		vrcpss xmm5,xmm5,xmm6
		vmovss dword ptr[eax+4],xmm5
		vmovss dword ptr[eax+8],xmm6
		jmp finish_3_AVX
novarjmp_AVX:
		vmovss dword ptr[eax+4],xmm3
		vmovss dword ptr[eax+8],xmm3
finish_3_AVX:
		vmovss dword ptr[eax+12],xmm3
		
		pop esi
		pop edi
		pop ebx
		
		ret
		
extract_m8_AVX endp


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


extract_m8_AVX_16 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,input:dword

	public extract_m8_AVX_16
	
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
		vpxor xmm5,xmm5,xmm5
		vpxor xmm6,xmm6,xmm6
		vpxor xmm3,xmm3,xmm3
		
yloop2_16_AVX:
		xor ecx,ecx
xloop2_16_AVX:
		vmovlps xmm0,xmm0,QWORD PTR[eax+2*ecx]
		vmovhps xmm0,xmm0,QWORD PTR[eax+2*ecx+8]
		vmovlps xmm2,xmm2,QWORD PTR[edx+2*ecx]
		vmovhps xmm2,xmm2,QWORD PTR[edx+2*ecx+8]
		vpunpckhwd xmm1,xmm0,xmm3
		vpunpcklwd xmm0,xmm0,xmm3
		vpunpckhwd xmm4,xmm2,xmm3
		vpunpcklwd xmm2,xmm2,xmm3
		vcvtdq2ps xmm0,xmm0
		vcvtdq2ps xmm1,xmm1
		vcvtdq2ps xmm2,xmm2
		vcvtdq2ps xmm4,xmm4
		vmovaps XMMWORD ptr [esi],xmm0
		vmovaps XMMWORD ptr [esi+16],xmm1
		vmovaps XMMWORD ptr [esi+edi*4],xmm2
		vmovaps XMMWORD ptr [esi+edi*4+16],xmm4
		vaddps xmm5,xmm5,xmm0
		vaddps xmm5,xmm5,xmm1
		vaddps xmm5,xmm5,xmm2
		vaddps xmm5,xmm5,xmm4
		vmulps xmm0,xmm0,xmm0
		vmulps xmm1,xmm1,xmm1
		vmulps xmm2,xmm2,xmm2
		vmulps xmm4,xmm4,xmm4
		vaddps xmm0,xmm0,xmm1
		vaddps xmm2,xmm2,xmm4
		vaddps xmm6,xmm6,xmm0
		vaddps xmm6,xmm6,xmm2
		add ecx,8
		add esi,32
		cmp ecx,edi
		jl xloop2_16_AVX
		lea eax,[eax+ebx*4]
		lea edx,[edx+ebx*4]
		lea esi,[esi+edi*4]
		sub ydia_,2
		jnz yloop2_16_AVX
		
		mov eax,ydia
		vmovhlps xmm0,xmm0,xmm5
		vmovhlps xmm1,xmm1,xmm6
		mul edi
		vaddps xmm5,xmm5,xmm0
		vaddps xmm6,xmm6,xmm1
		vcvtsi2ss xmm7,xmm7,eax
		vpshuflw xmm0,xmm5,14
		vpshuflw xmm1,xmm6,14
		vrcpss xmm7,xmm7,xmm7
		vaddss xmm5,xmm5,xmm0
		vaddss xmm6,xmm6,xmm1
		mov eax,mstd
		vmulss xmm5,xmm5,xmm7
		vmulss xmm6,xmm6,xmm7
		vmovss dword ptr[eax],xmm5
		vmulss xmm5,xmm5,xmm5
		vsubss xmm6,xmm6,xmm5
		vcomiss xmm6,dword ptr flt_epsilon_sse
		jbe novarjmp_16_AVX
		vrsqrtss xmm6,xmm6,xmm6
		vrcpss xmm5,xmm5,xmm6
		vmovss dword ptr[eax+4],xmm5
		vmovss dword ptr[eax+8],xmm6
		jmp finish_3_16_AVX
novarjmp_16_AVX:
		vmovss dword ptr[eax+4],xmm3
		vmovss dword ptr[eax+8],xmm3
finish_3_16_AVX:
		vmovss dword ptr[eax+12],xmm3
		
		pop esi
		pop edi
		pop ebx
		
		ret
		
extract_m8_AVX_16 endp


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


extract_m8_AVX_32 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,input:dword

	public extract_m8_AVX_32
	
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
		vpxor xmm5,xmm5,xmm5
		vpxor xmm6,xmm6,xmm6
		vpxor xmm3,xmm3,xmm3
		
yloop2_32_AVX:
		xor ecx,ecx
xloop2_32_AVX:
		vmovlps xmm0,xmm0,QWORD PTR[eax+4*ecx]
		vmovhps xmm0,xmm0,QWORD PTR[eax+4*ecx+8]
		vmovlps xmm2,xmm2,QWORD PTR[edx+4*ecx]
		vmovhps xmm2,xmm2,QWORD PTR[edx+4*ecx+8]
		
		vmovaps XMMWORD ptr [esi],xmm0
		vmovaps XMMWORD ptr [esi+edi*4],xmm2
		vaddps xmm5,xmm5,xmm0
		vaddps xmm5,xmm5,xmm2
		vmulps xmm0,xmm0,xmm0
		vmulps xmm2,xmm2,xmm2
		vaddps xmm6,xmm6,xmm0
		vaddps xmm6,xmm6,xmm2
		add ecx,4
		add esi,16
		cmp ecx,edi
		jl xloop2_32_AVX
		lea eax,[eax+ebx*4]
		lea edx,[edx+ebx*4]
		lea esi,[esi+edi*4]
		sub ydia_,2
		jnz yloop2_32_AVX
		
		mov eax,ydia
		vmovhlps xmm0,xmm0,xmm5
		vmovhlps xmm1,xmm1,xmm6
		mul edi
		vaddps xmm5,xmm5,xmm0
		vaddps xmm6,xmm6,xmm1
		vcvtsi2ss xmm7,xmm7,eax
		vpshuflw xmm0,xmm5,14
		vpshuflw xmm1,xmm6,14
		vrcpss xmm7,xmm7,xmm7
		vaddss xmm5,xmm5,xmm0
		vaddss xmm6,xmm6,xmm1
		mov eax,mstd
		vmulss xmm5,xmm5,xmm7
		vmulss xmm6,xmm6,xmm7
		vmovss dword ptr[eax],xmm5
		vmulss xmm5,xmm5,xmm5
		vsubss xmm6,xmm6,xmm5
		vcomiss xmm6,dword ptr flt_epsilon_sse
		jbe novarjmp_32_AVX
		vrsqrtss xmm6,xmm6,xmm6
		vrcpss xmm5,xmm5,xmm6
		vmovss dword ptr[eax+4],xmm5
		vmovss dword ptr[eax+8],xmm6
		jmp finish_3_32_AVX
novarjmp_32_AVX:
		vmovss dword ptr[eax+4],xmm3
		vmovss dword ptr[eax+8],xmm3
finish_3_32_AVX:
		vmovss dword ptr[eax+12],xmm3
		
		pop esi
		pop edi
		pop ebx
		
		ret
		
extract_m8_AVX_32 endp


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


extract_m8_i16_AVX proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,inputf:dword

	public extract_m8_i16_AVX
	
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
		vpxor xmm4,xmm4,xmm4
		vpxor xmm5,xmm5,xmm5
		vpxor xmm6,xmm6,xmm6
		
yloop_AVX:
		xor ecx,ecx
xloop_2_AVX:
		vmovq xmm0,QWORD PTR[eax+ecx]
		vmovq xmm1,QWORD PTR[esi+ecx]
		vpsadbw xmm2,xmm0,xmm6
		vpsadbw xmm3,xmm1,xmm6
		vpunpcklbw xmm0,xmm0,xmm6
		vpunpcklbw xmm1,xmm1,xmm6
		vmovdqa XMMWORD ptr [edx],xmm0
		vmovdqa XMMWORD ptr [edx+edi*2],xmm1
		vpmaddwd xmm0,xmm0,xmm0
		vpmaddwd xmm1,xmm1,xmm1
		vpaddd xmm4,xmm4,xmm2
		vpaddd xmm5,xmm5,xmm0
		vpaddd xmm4,xmm4,xmm3
		vpaddd xmm5,xmm5,xmm1
		add ecx,8
		add edx,16
		cmp ecx,edi
		jl xloop_2_AVX
		lea eax,[eax+ebx*4]
		lea esi,[esi+ebx*4]
		lea edx,[edx+edi*2]
		sub ydia_,2
		jnz yloop_AVX
		
		vmovhlps xmm1,xmm1,xmm5
		mov eax,ydia
		vpaddd xmm5,xmm5,xmm1
		mul edi
		vpshuflw xmm1,xmm5,14
		vcvtsi2ss xmm7,xmm7,eax
		vpaddd xmm5,xmm5,xmm1
		vrcpss xmm7,xmm7,xmm7
		vcvtdq2ps xmm4,xmm4
		vcvtdq2ps xmm5,xmm5
		mov eax,mstd
		vmulss xmm4,xmm4,xmm7
		vmulss xmm5,xmm5,xmm7
		vmovss dword ptr[eax],xmm4
		vmulss xmm4,xmm4,xmm4
		vsubss xmm5,xmm5,xmm4
		vcomiss xmm5,dword ptr flt_epsilon_sse
		jbe novarjmp_2_AVX
		vrsqrtss xmm5,xmm5,xmm5
		vrcpss xmm4,xmm4,xmm5
		vmovss dword ptr[eax+4],xmm4
		vmovss dword ptr[eax+8],xmm5
		jmp finish_4_AVX
novarjmp_2_AVX:
		vmovss dword ptr[eax+4],xmm6
		vmovss dword ptr[eax+8],xmm6
finish_4_AVX:
		vmovss dword ptr[eax+12],xmm6
		
		pop esi
		pop edi
		pop ebx
		
		ret
		
extract_m8_i16_AVX endp


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


extract_m8_i16_AVX_16 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,inputf:dword

	public extract_m8_i16_AVX_16
	
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
		vpxor xmm4,xmm4,xmm4
		vpxor xmm5,xmm5,xmm5
		vpxor xmm6,xmm6,xmm6
		
yloop_16_AVX:
		xor ecx,ecx
xloop_2_16_AVX:
		vmovlps xmm0,xmm0,QWORD PTR[eax+2*ecx]
		vmovhps xmm0,xmm0,QWORD PTR[eax+2*ecx+8]
		vmovlps xmm1,xmm1,QWORD PTR[esi+2*ecx]
		vmovhps xmm1,xmm1,QWORD PTR[esi+2*ecx+8]

		vmovdqa XMMWORD ptr [edx],xmm0
		vmovdqa XMMWORD ptr [edx+edi*2],xmm1
		
		vpmaddwd xmm2,xmm0,XMMWORD ptr uw_1
		vpmaddwd xmm3,xmm1,XMMWORD ptr uw_1
		
		vpmaddwd xmm0,xmm0,xmm0
		vpmaddwd xmm1,xmm1,xmm1
		
		vpaddd xmm4,xmm4,xmm2
		vpaddd xmm5,xmm5,xmm0
		vpaddd xmm4,xmm4,xmm3
		vpaddd xmm5,xmm5,xmm1
		add ecx,8
		add edx,16
		cmp ecx,edi
		jl xloop_2_16_AVX
		lea eax,[eax+ebx*4]
		lea esi,[esi+ebx*4]
		lea edx,[edx+edi*2]
		sub ydia_,2
		jnz yloop_16_AVX
		
		vmovhlps xmm1,xmm1,xmm5
		vmovhlps xmm2,xmm2,xmm4
		mov eax,ydia
		vpaddd xmm5,xmm5,xmm1
		vpaddd xmm4,xmm4,xmm2
		mul edi
		
		vpshufd xmm1,xmm5,1
		vpshufd xmm2,xmm4,1
		
		vcvtsi2ss xmm7,xmm7,eax
		
		vpaddd xmm5,xmm5,xmm1
		vpaddd xmm4,xmm4,xmm2
		
		vrcpss xmm7,xmm7,xmm7
		vcvtdq2ps xmm4,xmm4
		vcvtdq2ps xmm5,xmm5
		mov eax,mstd
		vmulss xmm4,xmm4,xmm7
		vmulss xmm5,xmm5,xmm7
		vmovss dword ptr[eax],xmm4
		vmulss xmm4,xmm4,xmm4
		vsubss xmm5,xmm5,xmm4
		vcomiss xmm5,dword ptr flt_epsilon_sse
		jbe novarjmp_2_16_AVX
		vrsqrtss xmm5,xmm5,xmm5
		vrcpss xmm4,xmm4,xmm5
		vmovss dword ptr[eax+4],xmm4
		vmovss dword ptr[eax+8],xmm5
		jmp finish_4_16_AVX
novarjmp_2_16_AVX:
		vmovss dword ptr[eax+4],xmm6
		vmovss dword ptr[eax+8],xmm6
finish_4_16_AVX:
		vmovss dword ptr[eax+12],xmm6
		
		pop esi
		pop edi
		pop ebx
		
		ret
		
extract_m8_i16_AVX_16 endp


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


extract_m8_i16_AVX_16_2 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,inputf:dword,sum:dword,sumsq:dword

	public extract_m8_i16_AVX_16_2
	
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
		vpxor xmm4,xmm4,xmm4
		vpxor xmm5,xmm5,xmm5
		vpxor xmm6,xmm6,xmm6
		
yloop_16_2_AVX:
		xor ecx,ecx
xloop_2_16_2_AVX:
		vmovq xmm0,QWORD PTR[eax+2*ecx]
		vmovq xmm1,QWORD PTR[esi+2*ecx]
		
		vmovq qword ptr [edx],xmm0
		vmovq qword ptr [edx+edi*2],xmm1
		
		vpmaddwd xmm2,xmm0,XMMWORD ptr uw_1
		vpmaddwd xmm3,xmm1,XMMWORD ptr uw_1
		
		vpaddd xmm4,xmm4,xmm2
	
		vpunpcklwd xmm0,xmm0,xmm6
		vpunpcklwd xmm1,xmm1,xmm6
		
		vpaddd xmm4,xmm4,xmm3
					
		vpmulld xmm0,xmm0,xmm0
		vpmulld xmm1,xmm1,xmm1
		vmovhlps xmm2,xmm2,xmm0
		vmovhlps xmm3,xmm3,xmm1
		vpunpckldq xmm0,xmm0,xmm6
		vpunpckldq xmm1,xmm1,xmm6
		vpunpckldq xmm2,xmm2,xmm6
		vpunpckldq xmm3,xmm3,xmm6
		vpaddq xmm0,xmm0,xmm2
		vpaddq xmm1,xmm1,xmm3
		
		vpaddq xmm5,xmm5,xmm0
		vmovhlps xmm2,xmm2,xmm0
		vpaddq xmm5,xmm5,xmm1
		vmovhlps xmm3,xmm3,xmm1
		vpaddq xmm5,xmm5,xmm2
		vpaddq xmm5,xmm5,xmm3		
		
		add ecx,4
		add edx,8
		cmp ecx,edi
		jl xloop_2_16_2_AVX
		lea eax,[eax+ebx*4]
		lea esi,[esi+ebx*4]
		lea edx,[edx+edi*2]
		sub ydia_,2
		jnz yloop_16_2_AVX
		
		vmovhlps xmm2,xmm2,xmm4
		mov eax,sum
		vpaddd xmm4,xmm4,xmm2
		mov ebx,sumsq
		vpshufd xmm2,xmm4,1
		vmovq qword ptr [ebx],xmm5		
		vpaddd xmm4,xmm4,xmm2
		vmovd dword ptr [eax],xmm4
	
		pop esi
		pop edi
		pop ebx
		
		ret
		
extract_m8_i16_AVX_16_2 endp


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


dotProd_m32_m16_AVX proc data_:dword,weights:dword,vals:dword,n:dword,len:dword,istd:dword

	public dotProd_m32_m16_AVX

		push edi
		push esi
		push ebx
		
		mov edi,weights
		mov eax,vals
		mov ebx,n
		mov esi,len
nloop_AVX:
		mov ecx,data_
		vxorps xmm0,xmm0,xmm0
		vxorps xmm1,xmm1,xmm1
		vxorps xmm2,xmm2,xmm2
		vxorps xmm3,xmm3,xmm3
		mov edx,esi
lloop_AVX:
		vmovaps xmm7,XMMWORD ptr [ecx]
		vmulps xmm4,xmm7,XMMWORD ptr [edi]
		vmulps xmm5,xmm7,XMMWORD ptr [edi+16]
		vmulps xmm6,xmm7,XMMWORD ptr [edi+32]
		vmulps xmm7,xmm7,XMMWORD ptr [edi+48]
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7
		
		vmovaps xmm7,XMMWORD ptr [ecx+16]
		vmulps xmm4,xmm7,XMMWORD ptr [edi+64]
		vmulps xmm5,xmm7,XMMWORD ptr [edi+80]
		vmulps xmm6,xmm7,XMMWORD ptr [edi+96]
		vmulps xmm7,xmm7,XMMWORD ptr [edi+112]
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7
		
		vmovaps xmm7,XMMWORD ptr [ecx+32]
		vmulps xmm4,xmm7,XMMWORD ptr [edi+128]
		vmulps xmm5,xmm7,XMMWORD ptr [edi+144]
		vmulps xmm6,xmm7,XMMWORD ptr [edi+160]
		vmulps xmm7,xmm7,XMMWORD ptr [edi+176]
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7
		
		vmovaps xmm7,XMMWORD ptr [ecx+48]
		vmulps xmm4,xmm7,XMMWORD ptr [edi+192]
		vmulps xmm5,xmm7,XMMWORD ptr [edi+208]
		vmulps xmm6,xmm7,XMMWORD ptr [edi+224]
		vmulps xmm7,xmm7,XMMWORD ptr [edi+240]
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7
		
		vmovaps xmm7,XMMWORD ptr [ecx+64]
		vmulps xmm4,xmm7,XMMWORD ptr [edi+256]
		vmulps xmm5,xmm7,XMMWORD ptr [edi+272]
		vmulps xmm6,xmm7,XMMWORD ptr [edi+288]
		vmulps xmm7,xmm7,XMMWORD ptr [edi+304]
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7
		
		vmovaps xmm7,XMMWORD ptr [ecx+80]
		vmulps xmm4,xmm7,XMMWORD ptr [edi+320]
		vmulps xmm5,xmm7,XMMWORD ptr [edi+336]
		vmulps xmm6,xmm7,XMMWORD ptr [edi+352]
		vmulps xmm7,xmm7,XMMWORD ptr [edi+368]
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7
		
		vmovaps xmm7,XMMWORD ptr [ecx+96]
		vmulps xmm4,xmm7,XMMWORD ptr [edi+384]
		vmulps xmm5,xmm7,XMMWORD ptr [edi+400]
		vmulps xmm6,xmm7,XMMWORD ptr [edi+416]
		vmulps xmm7,xmm7,XMMWORD ptr [edi+432]
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7
		
		vmovaps xmm7,XMMWORD ptr [ecx+112]
		vmulps xmm4,xmm7,XMMWORD ptr [edi+448]
		vmulps xmm5,xmm7,XMMWORD ptr [edi+464]
		vmulps xmm6,xmm7,XMMWORD ptr [edi+480]
		vmulps xmm7,xmm7,XMMWORD ptr [edi+496]
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7
		
		add ecx,128
		add edi,512
		sub edx,32
		jnz lloop_AVX
		vunpckhpd xmm4,xmm0,xmm1
		vunpckhpd xmm5,xmm2,xmm3
		vunpcklpd xmm0,xmm0,xmm1
		vunpcklpd xmm2,xmm2,xmm3
		vaddps xmm0,xmm0,xmm4
		vaddps xmm2,xmm2,xmm5
		vshufps xmm6,xmm0,xmm2,221
		vshufps xmm0,xmm0,xmm2,136
		vaddps xmm6,xmm6,xmm0
		vmovaps XMMWORD ptr [eax],xmm6
		add eax,16
		sub ebx,4
		jnz nloop_AVX
		mov ecx,istd
		mov eax,vals
		vmovss xmm7,dword ptr[ecx]
		mov edx,n
		vshufps xmm7,xmm7,xmm7,0
		xor ecx,ecx
aloop_AVX:
		vmovaps xmm0,XMMWORD ptr [eax+ecx*4]
		vmovaps xmm1,XMMWORD ptr [eax+ecx*4+16]
		vmovaps xmm2,XMMWORD ptr [eax+ecx*4+32]
		vmovaps xmm3,XMMWORD ptr [eax+ecx*4+48]
		vmulps xmm0,xmm0,xmm7
		vmulps xmm1,xmm1,xmm7
		vmulps xmm2,xmm2,xmm7
		vmulps xmm3,xmm3,xmm7
		vaddps xmm0,xmm0,XMMWORD ptr [edi+ecx*4]
		vaddps xmm1,xmm1,XMMWORD ptr [edi+ecx*4+16]
		vaddps xmm2,xmm2,XMMWORD ptr [edi+ecx*4+32]
		vaddps xmm3,xmm3,XMMWORD ptr [edi+ecx*4+48]
		vmovaps XMMWORD ptr [eax+ecx*4],xmm0
		vmovaps XMMWORD ptr [eax+ecx*4+16],xmm1
		vmovaps XMMWORD ptr [eax+ecx*4+32],xmm2
		vmovaps XMMWORD ptr [eax+ecx*4+48],xmm3
		add ecx,16
		sub edx,16
		jnz aloop_AVX
		
		pop ebx
		pop esi
		pop edi
		
		ret
		
dotProd_m32_m16_AVX endp


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


dotProd_m48_m16_AVX proc data_:dword,weights:dword,vals:dword,n:dword,len:dword,istd:dword

	public dotProd_m48_m16_AVX
	
		push edi
		push esi
		push ebx
		
		mov edi,weights
		mov eax,vals
		mov ebx,n
		mov esi,len
nloop_2_AVX:
		mov ecx,data_
		vxorps xmm0,xmm0,xmm0
		vxorps xmm1,xmm1,xmm1
		vxorps xmm2,xmm2,xmm2
		vxorps xmm3,xmm3,xmm3
		mov edx,esi
lloop_2_AVX:
		vmovaps xmm7,XMMWORD ptr [ecx]
		vmulps xmm4,xmm7,XMMWORD ptr [edi]
		vmulps xmm5,xmm7,XMMWORD ptr [edi+16]
		vmulps xmm6,xmm7,XMMWORD ptr [edi+32]
		vmulps xmm7,xmm7,XMMWORD ptr [edi+48]
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7
		
		vmovaps xmm7,XMMWORD ptr [ecx+16]
		vmulps xmm4,xmm7,XMMWORD ptr [edi+64]
		vmulps xmm5,xmm7,XMMWORD ptr [edi+80]
		vmulps xmm6,xmm7,XMMWORD ptr [edi+96]
		vmulps xmm7,xmm7,XMMWORD ptr [edi+112]
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7
		
		vmovaps xmm7,XMMWORD ptr [ecx+32]
		vmulps xmm4,xmm7,XMMWORD ptr [edi+128]
		vmulps xmm5,xmm7,XMMWORD ptr [edi+144]
		vmulps xmm6,xmm7,XMMWORD ptr [edi+160]
		vmulps xmm7,xmm7,XMMWORD ptr [edi+176]
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7
		
		vmovaps xmm7,XMMWORD ptr [ecx+48]
		vmulps xmm4,xmm7,XMMWORD ptr [edi+192]
		vmulps xmm5,xmm7,XMMWORD ptr [edi+208]
		vmulps xmm6,xmm7,XMMWORD ptr [edi+224]
		vmulps xmm7,xmm7,XMMWORD ptr [edi+240]
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7
		
		vmovaps xmm7,XMMWORD ptr [ecx+64]
		vmulps xmm4,xmm7,XMMWORD ptr [edi+256]
		vmulps xmm5,xmm7,XMMWORD ptr [edi+272]
		vmulps xmm6,xmm7,XMMWORD ptr [edi+288]
		vmulps xmm7,xmm7,XMMWORD ptr [edi+304]
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7
		
		vmovaps xmm7,XMMWORD ptr [ecx+80]
		vmulps xmm4,xmm7,XMMWORD ptr [edi+320]
		vmulps xmm5,xmm7,XMMWORD ptr [edi+336]
		vmulps xmm6,xmm7,XMMWORD ptr [edi+352]
		vmulps xmm7,xmm7,XMMWORD ptr [edi+368]
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7
		
		vmovaps xmm7,XMMWORD ptr [ecx+96]
		vmulps xmm4,xmm7,XMMWORD ptr [edi+384]
		vmulps xmm5,xmm7,XMMWORD ptr [edi+400]
		vmulps xmm6,xmm7,XMMWORD ptr [edi+416]
		vmulps xmm7,xmm7,XMMWORD ptr [edi+432]
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7
		
		vmovaps xmm7,XMMWORD ptr [ecx+112]
		vmulps xmm4,xmm7,XMMWORD ptr [edi+448]
		vmulps xmm5,xmm7,XMMWORD ptr [edi+464]
		vmulps xmm6,xmm7,XMMWORD ptr [edi+480]
		vmulps xmm7,xmm7,XMMWORD ptr [edi+496]
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7
		
		vmovaps xmm7,XMMWORD ptr [ecx+128]
		vmulps xmm4,xmm7,XMMWORD ptr [edi+512]
		vmulps xmm5,xmm7,XMMWORD ptr [edi+528]
		vmulps xmm6,xmm7,XMMWORD ptr [edi+544]
		vmulps xmm7,xmm7,XMMWORD ptr [edi+560]
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7
		
		vmovaps xmm7,XMMWORD ptr [ecx+144]
		vmulps xmm4,xmm7,XMMWORD ptr [edi+576]
		vmulps xmm5,xmm7,XMMWORD ptr [edi+592]
		vmulps xmm6,xmm7,XMMWORD ptr [edi+608]
		vmulps xmm7,xmm7,XMMWORD ptr [edi+624]
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7
		
		vmovaps xmm7,XMMWORD ptr [ecx+160]
		vmulps xmm4,xmm7,XMMWORD ptr [edi+640]
		vmulps xmm5,xmm7,XMMWORD ptr [edi+656]
		vmulps xmm6,xmm7,XMMWORD ptr [edi+672]
		vmulps xmm7,xmm7,XMMWORD ptr [edi+688]
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7
		
		vmovaps xmm7,XMMWORD ptr [ecx+176]
		vmulps xmm4,xmm7,XMMWORD ptr [edi+704]
		vmulps xmm5,xmm7,XMMWORD ptr [edi+720]
		vmulps xmm6,xmm7,XMMWORD ptr [edi+736]
		vmulps xmm7,xmm7,XMMWORD ptr [edi+752]
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7
		
		add ecx,192
		add edi,768
		sub edx,48
		jnz lloop_2_AVX
		vunpckhpd xmm4,xmm0,xmm1
		vunpckhpd xmm5,xmm2,xmm3
		vunpcklpd xmm0,xmm0,xmm1
		vunpcklpd xmm2,xmm2,xmm3
		vaddps xmm0,xmm0,xmm4
		vaddps xmm2,xmm2,xmm5
		vshufps xmm6,xmm0,xmm2,221
		vshufps xmm0,xmm0,xmm2,136
		vaddps xmm6,xmm6,xmm0
		vmovaps XMMWORD ptr [eax],xmm6
		add eax,16
		sub ebx,4
		jnz nloop_2_AVX
		mov ecx,istd
		mov eax,vals
		vmovss xmm7,dword ptr[ecx]
		mov edx,n
		vshufps xmm7,xmm7,xmm7,0
		xor ecx,ecx
aloop_2_AVX:
		vmovaps xmm0,XMMWORD ptr [eax+ecx*4]
		vmovaps xmm1,XMMWORD ptr [eax+ecx*4+16]
		vmovaps xmm2,XMMWORD ptr [eax+ecx*4+32]
		vmovaps xmm3,XMMWORD ptr [eax+ecx*4+48]
		vmulps xmm0,xmm0,xmm7
		vmulps xmm1,xmm1,xmm7
		vmulps xmm2,xmm2,xmm7
		vmulps xmm3,xmm3,xmm7
		vaddps xmm0,xmm0,XMMWORD ptr [edi+ecx*4]
		vaddps xmm1,xmm1,XMMWORD ptr [edi+ecx*4+16]
		vaddps xmm2,xmm2,XMMWORD ptr [edi+ecx*4+32]
		vaddps xmm3,xmm3,XMMWORD ptr [edi+ecx*4+48]
		vmovaps XMMWORD ptr [eax+ecx*4],xmm0
		vmovaps XMMWORD ptr [eax+ecx*4+16],xmm1
		vmovaps XMMWORD ptr [eax+ecx*4+32],xmm2
		vmovaps XMMWORD ptr [eax+ecx*4+48],xmm3
		add ecx,16
		sub edx,16
		jnz aloop_2_AVX
		
		pop ebx
		pop esi
		pop edi
		
		ret
		
dotProd_m48_m16_AVX endp


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


dotProd_m32_m16_i16_AVX proc dataf:dword,weightsf:dword,vals:dword,n:dword,len:dword,istd:dword

	public dotProd_m32_m16_i16_AVX

		push edi
		push esi
		push ebx
		
		mov edi,weightsf
		mov eax,vals
		mov ebx,n
		mov esi,len
nloop_3_AVX:
		mov ecx,dataf
		vpxor xmm0,xmm0,xmm0
		vpxor xmm1,xmm1,xmm1
		vpxor xmm2,xmm2,xmm2
		vpxor xmm3,xmm3,xmm3
		mov edx,esi
lloop_3_AVX:
		vmovdqa xmm7,XMMWORD ptr[ecx]
		vpmaddwd xmm4,xmm7,XMMWORD ptr[edi]
		vpmaddwd xmm5,xmm7,XMMWORD ptr[edi+16]
		vpmaddwd xmm6,xmm7,XMMWORD ptr[edi+32]
		vpmaddwd xmm7,xmm7,XMMWORD ptr[edi+48]
		vpaddd xmm0,xmm0,xmm4
		vpaddd xmm1,xmm1,xmm5
		vpaddd xmm2,xmm2,xmm6
		vpaddd xmm3,xmm3,xmm7
		
		vmovdqa xmm7,XMMWORD ptr[ecx+16]
		vpmaddwd xmm4,xmm7,XMMWORD ptr[edi+64]
		vpmaddwd xmm5,xmm7,XMMWORD ptr[edi+80]
		vpmaddwd xmm6,xmm7,XMMWORD ptr[edi+96]
		vpmaddwd xmm7,xmm7,XMMWORD ptr[edi+112]
		vpaddd xmm0,xmm0,xmm4
		vpaddd xmm1,xmm1,xmm5
		vpaddd xmm2,xmm2,xmm6
		vpaddd xmm3,xmm3,xmm7
		
		vmovdqa xmm7,XMMWORD ptr[ecx+32]
		vpmaddwd xmm4,xmm7,XMMWORD ptr[edi+128]
		vpmaddwd xmm5,xmm7,XMMWORD ptr[edi+144]
		vpmaddwd xmm6,xmm7,XMMWORD ptr[edi+160]
		vpmaddwd xmm7,xmm7,XMMWORD ptr[edi+176]
		vpaddd xmm0,xmm0,xmm4
		vpaddd xmm1,xmm1,xmm5
		vpaddd xmm2,xmm2,xmm6
		vpaddd xmm3,xmm3,xmm7
		
		vmovdqa xmm7,XMMWORD ptr[ecx+48]
		vpmaddwd xmm4,xmm7,XMMWORD ptr[edi+192]
		vpmaddwd xmm5,xmm7,XMMWORD ptr[edi+208]
		vpmaddwd xmm6,xmm7,XMMWORD ptr[edi+224]
		vpmaddwd xmm7,xmm7,XMMWORD ptr[edi+240]
		vpaddd xmm0,xmm0,xmm4
		vpaddd xmm1,xmm1,xmm5
		vpaddd xmm2,xmm2,xmm6
		vpaddd xmm3,xmm3,xmm7
		
		add ecx,64
		add edi,256
		sub edx,32
		jnz lloop_3_AVX
		vpunpckhqdq xmm4,xmm0,xmm1
		vpunpckhqdq xmm5,xmm2,xmm3
		vpunpcklqdq xmm0,xmm0,xmm1
		vpunpcklqdq xmm2,xmm2,xmm3
		vpaddd xmm0,xmm0,xmm4
		vpaddd xmm2,xmm2,xmm5
		vshufps xmm6,xmm0,xmm2,221
		vshufps xmm0,xmm0,xmm2,136
		vpaddd xmm6,xmm6,xmm0
		vmovdqa XMMWORD ptr [eax],xmm6
		add eax,16
		sub ebx,4
		jnz nloop_3_AVX
		mov ecx,istd
		mov eax,vals
		vmovss xmm7,dword ptr[ecx]
		mov edx,n
		vpshufd xmm7,xmm7,0
		xor ecx,ecx
aloop_3_AVX:
		vmovdqa xmm0,XMMWORD ptr[eax+ecx*4]
		vmovdqa xmm1,XMMWORD ptr[eax+ecx*4+16]
		vmovdqa xmm2,XMMWORD ptr[eax+ecx*4+32]
		vmovdqa xmm3,XMMWORD ptr[eax+ecx*4+48]
		vcvtdq2ps xmm0,xmm0
		vcvtdq2ps xmm1,xmm1
		vcvtdq2ps xmm2,xmm2
		vcvtdq2ps xmm3,xmm3
		vmulps xmm0,xmm0,XMMWORD ptr[edi+ecx*8]
		vmulps xmm1,xmm1,XMMWORD ptr[edi+ecx*8+32]
		vmulps xmm2,xmm2,XMMWORD ptr[edi+ecx*8+64]
		vmulps xmm3,xmm3,XMMWORD ptr[edi+ecx*8+96]
		vmulps xmm0,xmm0,xmm7
		vmulps xmm1,xmm1,xmm7
		vmulps xmm2,xmm2,xmm7
		vmulps xmm3,xmm3,xmm7
		vaddps xmm0,xmm0,XMMWORD ptr[edi+ecx*8+16]
		vaddps xmm1,xmm1,XMMWORD ptr[edi+ecx*8+48]
		vaddps xmm2,xmm2,XMMWORD ptr[edi+ecx*8+80]
		vaddps xmm3,xmm3,XMMWORD ptr[edi+ecx*8+112]
		vmovaps XMMWORD ptr[eax+ecx*4],xmm0
		vmovaps XMMWORD ptr[eax+ecx*4+16],xmm1
		vmovaps XMMWORD ptr[eax+ecx*4+32],xmm2
		vmovaps XMMWORD ptr[eax+ecx*4+48],xmm3
		add ecx,16
		sub edx,16
		jnz aloop_3_AVX
		
		pop ebx
		pop esi
		pop edi
		
		ret
		
dotProd_m32_m16_i16_AVX endp


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


dotProd_m48_m16_i16_AVX proc dataf:dword,weightsf:dword,vals:dword,n:dword,len:dword,istd:dword

	public dotProd_m48_m16_i16_AVX

		push edi
		push esi
		push ebx
		
		mov edi,weightsf
		mov eax,vals
		mov ebx,n
		mov esi,len
nloop_4_AVX:
		mov ecx,dataf
		vpxor xmm0,xmm0,xmm0
		vpxor xmm1,xmm1,xmm1
		vpxor xmm2,xmm2,xmm2
		vpxor xmm3,xmm3,xmm3
		mov edx,esi
lloop_4_AVX:
		vmovdqa xmm7,XMMWORD ptr[ecx]
		vpmaddwd xmm4,xmm7,XMMWORD ptr[edi]
		vpmaddwd xmm5,xmm7,XMMWORD ptr[edi+16]
		vpmaddwd xmm6,xmm7,XMMWORD ptr[edi+32]
		vpmaddwd xmm7,xmm7,XMMWORD ptr[edi+48]
		vpaddd xmm0,xmm0,xmm4
		vpaddd xmm1,xmm1,xmm5
		vpaddd xmm2,xmm2,xmm6
		vpaddd xmm3,xmm3,xmm7
		
		vmovdqa xmm7,XMMWORD ptr[ecx+16]
		vpmaddwd xmm4,xmm7,XMMWORD ptr[edi+64]
		vpmaddwd xmm5,xmm7,XMMWORD ptr[edi+80]
		vpmaddwd xmm6,xmm7,XMMWORD ptr[edi+96]
		vpmaddwd xmm7,xmm7,XMMWORD ptr[edi+112]
		vpaddd xmm0,xmm0,xmm4
		vpaddd xmm1,xmm1,xmm5
		vpaddd xmm2,xmm2,xmm6
		vpaddd xmm3,xmm3,xmm7
		
		vmovdqa xmm7,XMMWORD ptr[ecx+32]
		vpmaddwd xmm4,xmm7,XMMWORD ptr[edi+128]
		vpmaddwd xmm5,xmm7,XMMWORD ptr[edi+144]
		vpmaddwd xmm6,xmm7,XMMWORD ptr[edi+160]
		vpmaddwd xmm7,xmm7,XMMWORD ptr[edi+176]
		vpaddd xmm0,xmm0,xmm4
		vpaddd xmm1,xmm1,xmm5
		vpaddd xmm2,xmm2,xmm6
		vpaddd xmm3,xmm3,xmm7
		
		vmovdqa xmm7,XMMWORD ptr[ecx+48]
		vpmaddwd xmm4,xmm7,XMMWORD ptr[edi+192]
		vpmaddwd xmm5,xmm7,XMMWORD ptr[edi+208]
		vpmaddwd xmm6,xmm7,XMMWORD ptr[edi+224]
		vpmaddwd xmm7,xmm7,XMMWORD ptr[edi+240]
		vpaddd xmm0,xmm0,xmm4
		vpaddd xmm1,xmm1,xmm5
		vpaddd xmm2,xmm2,xmm6
		vpaddd xmm3,xmm3,xmm7
		
		vmovdqa xmm7,XMMWORD ptr[ecx+64]
		vpmaddwd xmm4,xmm7,XMMWORD ptr[edi+256]
		vpmaddwd xmm5,xmm7,XMMWORD ptr[edi+272]
		vpmaddwd xmm6,xmm7,XMMWORD ptr[edi+288]
		vpmaddwd xmm7,xmm7,XMMWORD ptr[edi+304]
		vpaddd xmm0,xmm0,xmm4
		vpaddd xmm1,xmm1,xmm5
		vpaddd xmm2,xmm2,xmm6
		vpaddd xmm3,xmm3,xmm7
		
		vmovdqa xmm7,XMMWORD ptr[ecx+80]
		vpmaddwd xmm4,xmm7,XMMWORD ptr[edi+320]
		vpmaddwd xmm5,xmm7,XMMWORD ptr[edi+336]
		vpmaddwd xmm6,xmm7,XMMWORD ptr[edi+352]
		vpmaddwd xmm7,xmm7,XMMWORD ptr[edi+368]
		vpaddd xmm0,xmm0,xmm4
		vpaddd xmm1,xmm1,xmm5
		vpaddd xmm2,xmm2,xmm6
		vpaddd xmm3,xmm3,xmm7
		
		add ecx,96
		add edi,384
		sub edx,48
		jnz lloop_4_AVX
		vpunpckhqdq xmm4,xmm0,xmm1
		vpunpckhqdq xmm5,xmm2,xmm3
		vpunpcklqdq xmm0,xmm0,xmm1
		vpunpcklqdq xmm2,xmm2,xmm3
		vpaddd xmm0,xmm0,xmm4
		vpaddd xmm2,xmm2,xmm5
		vshufps xmm6,xmm0,xmm2,221
		vshufps xmm0,xmm0,xmm2,136
		vpaddd xmm6,xmm6,xmm0
		vmovdqa XMMWORD ptr[eax],xmm6
		add eax,16
		sub ebx,4
		jnz nloop_4_AVX
		mov ecx,istd
		mov eax,vals
		vmovss xmm7,dword ptr[ecx]
		mov edx,n
		vpshufd xmm7,xmm7,0
		xor ecx,ecx
aloop_4_AVX:
		vmovdqa xmm0,XMMWORD ptr[eax+ecx*4]
		vmovdqa xmm1,XMMWORD ptr[eax+ecx*4+16]
		vmovdqa xmm2,XMMWORD ptr[eax+ecx*4+32]
		vmovdqa xmm3,XMMWORD ptr[eax+ecx*4+48]
		vcvtdq2ps xmm0,xmm0
		vcvtdq2ps xmm1,xmm1
		vcvtdq2ps xmm2,xmm2
		vcvtdq2ps xmm3,xmm3
		vmulps xmm0,xmm0,XMMWORD ptr[edi+ecx*8]
		vmulps xmm1,xmm1,XMMWORD ptr[edi+ecx*8+32]
		vmulps xmm2,xmm2,XMMWORD ptr[edi+ecx*8+64]
		vmulps xmm3,xmm3,XMMWORD ptr[edi+ecx*8+96]
		vmulps xmm0,xmm0,xmm7
		vmulps xmm1,xmm1,xmm7
		vmulps xmm2,xmm2,xmm7
		vmulps xmm3,xmm3,xmm7
		vaddps xmm0,xmm0,XMMWORD ptr[edi+ecx*8+16]
		vaddps xmm1,xmm1,XMMWORD ptr[edi+ecx*8+48]
		vaddps xmm2,xmm2,XMMWORD ptr[edi+ecx*8+80]
		vaddps xmm3,xmm3,XMMWORD ptr[edi+ecx*8+112]
		vmovaps XMMWORD ptr[eax+ecx*4],xmm0
		vmovaps XMMWORD ptr[eax+ecx*4+16],xmm1
		vmovaps XMMWORD ptr[eax+ecx*4+32],xmm2
		vmovaps XMMWORD ptr[eax+ecx*4+48],xmm3
		add ecx,16
		sub edx,16
		jnz aloop_4_AVX
		
		pop ebx
		pop esi
		pop edi
		
		ret

dotProd_m48_m16_i16_AVX endp


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


e0_m16_AVX proc ptr_s:dword,n:dword

	public e0_m16_AVX
	
		mov eax,ptr_s
		mov ecx,n
		
		vmovdqa xmm4,XMMWORD ptr exp_hi
		vmovdqa xmm5,XMMWORD ptr exp_lo
		vmovdqa xmm6,XMMWORD ptr e0_mult
		vmovdqa xmm7,XMMWORD ptr e0_bias
		
eloop16_AVX:
		vmovaps xmm0,XMMWORD ptr[eax]
		vmovaps xmm1,XMMWORD ptr[eax+16]
		vmovaps xmm2,XMMWORD ptr[eax+32]
		vmovaps xmm3,XMMWORD ptr[eax+48]
		vminps xmm0,xmm0,xmm4
		vminps xmm1,xmm1,xmm4
		vminps xmm2,xmm2,xmm4
		vminps xmm3,xmm3,xmm4
		vmaxps xmm0,xmm0,xmm5
		vmaxps xmm1,xmm1,xmm5
		vmaxps xmm2,xmm2,xmm5
		vmaxps xmm3,xmm3,xmm5
		vmulps xmm0,xmm0,xmm6
		vmulps xmm1,xmm1,xmm6
		vmulps xmm2,xmm2,xmm6
		vmulps xmm3,xmm3,xmm6
		vaddps xmm0,xmm0,xmm7
		vaddps xmm1,xmm1,xmm7
		vaddps xmm2,xmm2,xmm7
		vaddps xmm3,xmm3,xmm7
		vcvtps2dq xmm0,xmm0
		vcvtps2dq xmm1,xmm1
		vcvtps2dq xmm2,xmm2
		vcvtps2dq xmm3,xmm3
		vmovaps XMMWORD ptr[eax],xmm0
		vmovaps XMMWORD ptr[eax+16],xmm1
		vmovaps XMMWORD ptr[eax+32],xmm2
		vmovaps XMMWORD ptr[eax+48],xmm3
		add eax,64
		sub ecx,16
		
		jnz eloop16_AVX
		
		ret

e0_m16_AVX endp


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


e1_m16_AVX proc ptr_s:dword,n:dword

	public e1_m16_AVX

		mov eax,ptr_s
		mov ecx,n
eloop8_AVX:
		vmovaps xmm0,XMMWORD ptr[eax]
		vmovaps xmm4,XMMWORD ptr[eax+16]
		vminps xmm0,xmm0,XMMWORD ptr exp_hi
		vminps xmm4,xmm4,XMMWORD ptr exp_hi
		vmaxps xmm0,xmm0,XMMWORD ptr exp_lo
		vmaxps xmm4,xmm4,XMMWORD ptr exp_lo
		vmulps xmm0,xmm0,XMMWORD ptr e1_scale
		vmulps xmm4,xmm4,XMMWORD ptr e1_scale
		vmovaps xmm1,xmm0
		vmovaps xmm5,xmm4
		vaddps xmm0,xmm0,XMMWORD ptr e1_bias
		vaddps xmm4,xmm4,XMMWORD ptr e1_bias
		vpslld xmm2,xmm0,23
		vpslld xmm6,xmm4,23
		vsubps xmm0,xmm0,XMMWORD ptr e1_bias
		vsubps xmm4,xmm4,XMMWORD ptr e1_bias
		vsubps xmm1,xmm1,xmm0
		vsubps xmm5,xmm5,xmm4
		
		vmulps xmm0,xmm1,oword ptr e1_c1
		vmulps xmm4,xmm5,oword ptr e1_c1
		vmulps xmm1,xmm1,xmm1
		vmulps xmm5,xmm5,xmm5
		vmulps xmm1,xmm1,oword ptr e1_c2
		vmulps xmm5,xmm5,oword ptr e1_c2
		vaddps xmm0,xmm0,oword ptr e1_c0
		vaddps xmm4,xmm4,oword ptr e1_c0
		
		vaddps xmm0,xmm0,xmm1
		vaddps xmm4,xmm4,xmm5
		vpaddd xmm0,xmm0,xmm2
		vpaddd xmm4,xmm4,xmm6
		vmovaps XMMWORD ptr[eax],xmm0
		vmovaps XMMWORD ptr[eax+16],xmm4
		add eax,32
		sub ecx,8
		jnz eloop8_AVX
		
		ret
		
e1_m16_AVX endp


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


e2_m16_AVX proc ptr_s:dword,n:dword

	public e2_m16_AVX

		mov eax,ptr_s
		mov ecx,n
eloop4_AVX:
		vmovaps xmm0,XMMWORD ptr[eax]
		vminps xmm0,xmm0,XMMWORD ptr exp_hi
		vmaxps xmm0,xmm0,XMMWORD ptr exp_lo
		vmovaps xmm1,XMMWORD ptr exp_rln2
		vmulps xmm1,xmm1,xmm0
		vxorps xmm2,xmm2,xmm2
		vaddps xmm1,xmm1,XMMWORD ptr am_0p5
		vcmpnltps xmm2,xmm2,xmm1
		vpand xmm2,xmm2,XMMWORD ptr epi32_1
		vcvttps2dq xmm1,xmm1
		vmovaps xmm4,XMMWORD ptr exp_c2
		vpsubd xmm1,xmm1,xmm2
		vmovaps xmm5,XMMWORD ptr exp_c1
		vcvtdq2ps xmm3,xmm1
		vmulps xmm4,xmm4,xmm3
		vmulps xmm5,xmm5,xmm3
		vmovaps xmm6,XMMWORD ptr exp_q0
		vsubps xmm0,xmm0,xmm4
		vmovaps xmm4,XMMWORD ptr exp_p0
		vsubps xmm0,xmm0,xmm5
		vpaddd xmm1,xmm1,XMMWORD ptr epi32_0x7f
		vmovaps xmm2,xmm0
		vmulps xmm0,xmm0,xmm0
		vmulps xmm6,xmm6,xmm0
		vmulps xmm4,xmm4,xmm0
		vaddps xmm6,xmm6,XMMWORD ptr exp_q1
		vaddps xmm4,xmm4,XMMWORD ptr exp_p1
		vmulps xmm6,xmm6,xmm0
		vmulps xmm4,xmm4,xmm0
		vaddps xmm6,xmm6,XMMWORD ptr exp_q2
		vmulps xmm4,xmm4,xmm2
		vmulps xmm6,xmm6,xmm0
		vmovaps xmm0,XMMWORD ptr am_1
		vaddps xmm2,xmm2,xmm4
		vaddps xmm6,xmm6,XMMWORD ptr exp_q3
		vpslld xmm1,xmm1,23
		vsubps xmm6,xmm6,xmm2
		vrcpps xmm6,xmm6
		vmulps xmm2,xmm2,xmm6
		vaddps xmm2,xmm2,xmm2
		vaddps xmm0,xmm0,xmm2
		vmulps xmm0,xmm0,xmm1
		vmovaps XMMWORD ptr[eax],xmm0
		add eax,16
		sub ecx,4
		jnz eloop4_AVX
		
		ret
		
e2_m16_AVX endp


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


weightedAvgElliottMul5_m16_AVX proc ptr_w:dword,n:dword,mstd:dword

	public weightedAvgElliottMul5_m16_AVX

		push edi
		
		mov eax,ptr_w
		mov ecx,n
		lea edx,[eax+ecx*4]
		xor edi,edi
		vxorps xmm0,xmm0,xmm0
		vxorps xmm1,xmm1,xmm1
nloop_5_AVX:
		vmovaps xmm2,XMMWORD ptr[eax+edi*4]
		vmovaps xmm3,XMMWORD ptr[eax+edi*4+16]
		vmovaps xmm4,XMMWORD ptr[edx+edi*4]
		vmovaps xmm5,XMMWORD ptr[edx+edi*4+16]
		vaddps xmm0,xmm0,xmm2
		vmovaps xmm6,xmm4
		vmovaps xmm7,xmm5
		vaddps xmm0,xmm0,xmm3
		vandps xmm4,xmm4,XMMWORD ptr sign_bits_f
		vandps xmm5,xmm5,XMMWORD ptr sign_bits_f
		vaddps xmm4,xmm4,XMMWORD ptr ones_f
		vaddps xmm5,xmm5,XMMWORD ptr ones_f
		vrcpps xmm4,xmm4
		vrcpps xmm5,xmm5
		vmulps xmm6,xmm6,xmm4
		vmulps xmm7,xmm7,xmm5
		vmulps xmm6,xmm6,xmm2
		vmulps xmm7,xmm7,xmm3
		vaddps xmm1,xmm1,xmm6
		vaddps xmm1,xmm1,xmm7
		vmovaps xmm2,XMMWORD ptr[eax+edi*4+32]
		vmovaps xmm3,XMMWORD ptr[eax+edi*4+48]
		vmovaps xmm4,XMMWORD ptr[edx+edi*4+32]
		vmovaps xmm5,XMMWORD ptr[edx+edi*4+48]
		vaddps xmm0,xmm0,xmm2
		vmovaps xmm6,xmm4
		vmovaps xmm7,xmm5
		vaddps xmm0,xmm0,xmm3
		vandps xmm4,xmm4,XMMWORD ptr sign_bits_f
		vandps xmm5,xmm5,XMMWORD ptr sign_bits_f
		vaddps xmm4,xmm4,XMMWORD ptr ones_f
		vaddps xmm5,xmm5,XMMWORD ptr ones_f
		vrcpps xmm4,xmm4
		vrcpps xmm5,xmm5
		vmulps xmm6,xmm6,xmm4
		vmulps xmm7,xmm7,xmm5
		vmulps xmm6,xmm6,xmm2
		vmulps xmm7,xmm7,xmm3
		vaddps xmm1,xmm1,xmm6
		vaddps xmm1,xmm1,xmm7
		add edi,16
		sub ecx,16
		jnz nloop_5_AVX
		vmovhlps xmm2,xmm2,xmm0
		vmovhlps xmm3,xmm3,xmm1
		vaddps xmm0,xmm0,xmm2
		vaddps xmm1,xmm1,xmm3
		vpshuflw xmm2,xmm0,14
		vpshuflw xmm3,xmm1,14
		vaddss xmm0,xmm0,xmm2
		vaddss xmm1,xmm1,xmm3
		vcomiss xmm0,dword ptr min_weight_sum
		jbe nodiv_AVX
		vmulss xmm1,xmm1,dword ptr five_f
		vrcpss xmm0,xmm0,xmm0
		vmulss xmm1,xmm1,xmm0
		jmp finish_5_AVX
nodiv_AVX:
		vxorps xmm1,xmm1,xmm1
finish_5_AVX:
		mov eax,mstd
		vmulss xmm1,xmm1,dword ptr[eax+4]
		vaddss xmm1,xmm1,dword ptr[eax]
		vaddss xmm1,xmm1,dword ptr[eax+12]
		vmovss dword ptr[eax+12],xmm1
		
		pop edi
		
		ret
		
weightedAvgElliottMul5_m16_AVX endp


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


castScale_AVX proc val:dword,scale:dword,dstp:dword,val_min:dword,val_max:dword

	public castScale_AVX
	
		mov ecx,val
		mov eax,scale
		
		vmovss xmm0,dword ptr[ecx+12]
		vmulss xmm0,xmm0,dword ptr[eax]
		vaddss xmm0,xmm0,dword ptr sse_half
		vcvttss2si eax,xmm0
		mov ecx,dstp
		cmp eax,val_max
		cmovnl eax,val_max
		cmp eax,val_min
		cmovng eax,val_min
		mov byte ptr[ecx],al
		
		ret
		
castScale_AVX endp


castScale_AVX_16 proc val:dword,scale:dword,dstp:dword,val_min:dword,val_max:dword

	public castScale_AVX_16
	
		mov ecx,val
		mov eax,scale
		
		vmovss xmm0,dword ptr[ecx+12]
		vmulss xmm0,xmm0,dword ptr[eax]
		vaddss xmm0,xmm0,dword ptr sse_half
		vcvttss2si eax,xmm0
		mov ecx,dstp
		cmp eax,val_max
		cmovnl eax,val_max
		cmp eax,val_min
		cmovng eax,val_min
		mov word ptr[ecx],ax
		
		ret
		
castScale_AVX_16 endp


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


uc2s64_AVX proc ptr_t:dword,pitch:dword,ptr_p:dword

	public uc2s64_AVX
	
		mov eax,ptr_t
		mov ecx,pitch
		mov edx,ptr_p
		vpxor xmm7,xmm7,xmm7
		vmovq xmm0,QWORD PTR[eax]
		vmovq xmm1,QWORD PTR[eax+8]
		vmovq xmm2,QWORD PTR[eax+ecx*2]
		vmovq xmm3,QWORD PTR[eax+ecx*2+8]
		vpunpcklbw xmm0,xmm0,xmm7
		vpunpcklbw xmm1,xmm1,xmm7
		vpunpcklbw xmm2,xmm2,xmm7
		vpunpcklbw xmm3,xmm3,xmm7
		lea eax,[eax+ecx*4]
		vmovdqa XMMWORD ptr[edx],xmm0
		vmovdqa XMMWORD ptr[edx+16],xmm1
		vmovdqa XMMWORD ptr[edx+32],xmm2
		vmovdqa XMMWORD ptr[edx+48],xmm3
		vmovq xmm4,QWORD PTR[eax]
		vmovq xmm5,QWORD PTR[eax+8]
		vmovq xmm6,QWORD PTR[eax+ecx*2]
		vmovq xmm0,QWORD PTR[eax+ecx*2+8]
		vpunpcklbw xmm4,xmm4,xmm7
		vpunpcklbw xmm5,xmm5,xmm7
		vpunpcklbw xmm6,xmm6,xmm7
		vpunpcklbw xmm0,xmm0,xmm7
		vmovdqa XMMWORD ptr[edx+64],xmm4
		vmovdqa XMMWORD ptr[edx+80],xmm5
		vmovdqa XMMWORD ptr[edx+96],xmm6
		vmovdqa XMMWORD ptr[edx+112],xmm0
		
		ret
		
uc2s64_AVX endp


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


computeNetwork0new_AVX proc datai:dword,weights:dword,ptr_d:dword

	public computeNetwork0new_AVX

		mov ecx,datai
		mov eax,weights
		vmovdqa xmm7,XMMWORD ptr[ecx]
		vpmaddwd xmm0,xmm7,XMMWORD ptr[eax]
		vpmaddwd xmm1,xmm7,XMMWORD ptr[eax+16]
		vpmaddwd xmm2,xmm7,XMMWORD ptr[eax+32]
		vpmaddwd xmm3,xmm7,XMMWORD ptr[eax+48]
		
		vmovdqa xmm7,XMMWORD ptr[ecx+16]
		vpmaddwd xmm4,xmm7,XMMWORD ptr[eax+64]
		vpmaddwd xmm5,xmm7,XMMWORD ptr[eax+80]
		vpmaddwd xmm6,xmm7,XMMWORD ptr[eax+96]
		vpmaddwd xmm7,xmm7,XMMWORD ptr[eax+112]
		vpaddd xmm0,xmm0,xmm4
		vpaddd xmm1,xmm1,xmm5
		vpaddd xmm2,xmm2,xmm6
		vpaddd xmm3,xmm3,xmm7
		
		vmovdqa xmm7,XMMWORD ptr[ecx+32]
		vpmaddwd xmm4,xmm7,XMMWORD ptr[eax+128]
		vpmaddwd xmm5,xmm7,XMMWORD ptr[eax+144]
		vpmaddwd xmm6,xmm7,XMMWORD ptr[eax+160]
		vpmaddwd xmm7,xmm7,XMMWORD ptr[eax+176]
		vpaddd xmm0,xmm0,xmm4
		vpaddd xmm1,xmm1,xmm5
		vpaddd xmm2,xmm2,xmm6
		vpaddd xmm3,xmm3,xmm7
		
		vmovdqa xmm7,XMMWORD ptr[ecx+48]
		vpmaddwd xmm4,xmm7,XMMWORD ptr[eax+192]
		vpmaddwd xmm5,xmm7,XMMWORD ptr[eax+208]
		vpmaddwd xmm6,xmm7,XMMWORD ptr[eax+224]
		vpmaddwd xmm7,xmm7,XMMWORD ptr[eax+240]
		vpaddd xmm0,xmm0,xmm4
		vpaddd xmm1,xmm1,xmm5
		vpaddd xmm2,xmm2,xmm6
		vpaddd xmm3,xmm3,xmm7
		
		vmovdqa xmm7,XMMWORD ptr[ecx+64]
		vpmaddwd xmm4,xmm7,XMMWORD ptr[eax+256]
		vpmaddwd xmm5,xmm7,XMMWORD ptr[eax+272]
		vpmaddwd xmm6,xmm7,XMMWORD ptr[eax+288]
		vpmaddwd xmm7,xmm7,XMMWORD ptr[eax+304]
		vpaddd xmm0,xmm0,xmm4
		vpaddd xmm1,xmm1,xmm5
		vpaddd xmm2,xmm2,xmm6
		vpaddd xmm3,xmm3,xmm7
		
		vmovdqa xmm7,XMMWORD ptr[ecx+80]
		vpmaddwd xmm4,xmm7,XMMWORD ptr[eax+320]
		vpmaddwd xmm5,xmm7,XMMWORD ptr[eax+336]
		vpmaddwd xmm6,xmm7,XMMWORD ptr[eax+352]
		vpmaddwd xmm7,xmm7,XMMWORD ptr[eax+368]
		vpaddd xmm0,xmm0,xmm4
		vpaddd xmm1,xmm1,xmm5
		vpaddd xmm2,xmm2,xmm6
		vpaddd xmm3,xmm3,xmm7
		
		vmovdqa xmm7,XMMWORD ptr[ecx+96]
		vpmaddwd xmm4,xmm7,XMMWORD ptr[eax+384]
		vpmaddwd xmm5,xmm7,XMMWORD ptr[eax+400]
		vpmaddwd xmm6,xmm7,XMMWORD ptr[eax+416]
		vpmaddwd xmm7,xmm7,XMMWORD ptr[eax+432]
		vpaddd xmm0,xmm0,xmm4
		vpaddd xmm1,xmm1,xmm5
		vpaddd xmm2,xmm2,xmm6
		vpaddd xmm3,xmm3,xmm7
		
		vmovdqa xmm7,XMMWORD ptr[ecx+112]
		vpmaddwd xmm4,xmm7,XMMWORD ptr[eax+448]
		vpmaddwd xmm5,xmm7,XMMWORD ptr[eax+464]
		vpmaddwd xmm6,xmm7,XMMWORD ptr[eax+480]
		vpmaddwd xmm7,xmm7,XMMWORD ptr[eax+496]
		vpaddd xmm0,xmm0,xmm4
		vpaddd xmm1,xmm1,xmm5
		vpaddd xmm2,xmm2,xmm6
		vpaddd xmm3,xmm3,xmm7
		
		vpunpckhqdq xmm4,xmm0,xmm1
		vpunpckhqdq xmm5,xmm2,xmm3
		vpunpcklqdq xmm0,xmm0,xmm1
		vpunpcklqdq xmm2,xmm2,xmm3
		vpaddd xmm0,xmm0,xmm4
		vpaddd xmm2,xmm2,xmm5
		vshufps xmm6,xmm0,xmm2,221
		vshufps xmm0,xmm0,xmm2,136
		
		vpaddd xmm0,xmm0,xmm6
		vcvtdq2ps xmm0,xmm0
		vmulps xmm0,xmm0,XMMWORD ptr[eax+512]
		vaddps xmm0,xmm0,XMMWORD ptr[eax+528]
		vmovaps xmm1,xmm0
		vandps xmm0,xmm0,XMMWORD ptr sign_bits_f
		vaddps xmm0,xmm0,XMMWORD ptr ones_f
		vrcpps xmm0,xmm0
		vmulps xmm0,xmm0,xmm1
		vpshufd xmm1,xmm0,0
		vpshufd xmm2,xmm0,85
		vpshufd xmm3,xmm0,170
		vpshufd xmm4,xmm0,255
		vmulps xmm1,xmm1,XMMWORD ptr[eax+544]
		vmulps xmm2,xmm2,XMMWORD ptr[eax+560]
		vmulps xmm3,xmm3,XMMWORD ptr[eax+576]
		vmulps xmm4,xmm4,XMMWORD ptr[eax+592]
		vpxor xmm0,xmm0,xmm0
		vaddps xmm1,xmm1,xmm2
		vaddps xmm3,xmm3,xmm4
		vaddps xmm1,xmm1,xmm3
		mov ecx,ptr_d
		vaddps xmm1,xmm1,XMMWORD ptr[eax+608]
		vcmpps xmm1,xmm1,xmm0,1
		vpackssdw xmm1,xmm1,xmm0
		vpacksswb xmm1,xmm1,xmm0
		vmovd eax,xmm1
		xor eax,0FFFFFFFFh
		and eax,001010101h
		mov [ecx],eax
		
		ret
		
computeNetwork0new_AVX endp

end
