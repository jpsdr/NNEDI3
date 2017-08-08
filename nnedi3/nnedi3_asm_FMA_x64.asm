.data

FLT_EPSILON  equ   1.192092896e-07

align 16

sign_bits_f_zero_l qword 7FFFFFFF00000000h,7FFFFFFF7FFFFFFFh
sign_bits_f qword 2 dup(7FFFFFFF7FFFFFFFh)
ones_f real4 4 dup(1.0)

flt_epsilon_sse real4 4 dup(FLT_EPSILON)

min_weight_sum real4 4 dup(1.0e-10)
five_f real4 4 dup(5.0)

sse_half real4 4 dup(0.5)

data segment align(32)

exp_hi real4 8 dup(80.0)
exp_lo real4 8 dup(-80.0)

; exp from:  A Fast, Compact Approximation of the Exponential Function (1998)
;            Nicol N. Schraudolph

e0_mult real4 8 dup(12102203.161561486)   ; (1.0/ln(2))*(2^23)
e0_bias real4 8 dup(1064866805.0)         ; (2^23)*127.0-486411.0

; exp from Loren Merritt

e1_scale real4 8 dup(1.4426950409)        ; 1/ln(2)
e1_bias real4 8 dup(12582912.0)           ; 3<<22
e1_c1 real4 8 dup(0.701277797)
e1_c2 real4 8 dup(0.237348593)
e1_c0 real4 8 dup(1.00035)

; exp from Intel Approximate Math (AM) Library

exp_rln2 real4 8 dup(1.442695041)
am_0p5 real4 8 dup(0.5)
epi32_1 sdword 8 dup(1)
exp_c2 real4 8 dup(1.428606820e-6)
exp_c1 real4 8 dup(6.931457520e-1)
exp_q0 real4 8 dup(3.001985051e-6)
exp_p0 real4 8 dup(1.261771931e-4)
epi32_0x7f sdword 8 dup(7Fh)
exp_q1 real4 8 dup(2.524483403e-3)
exp_p1 real4 8 dup(3.029944077e-2)
exp_q2 real4 8 dup(2.272655482e-1)
am_1 real4 8 dup(1.0)
exp_q3 real4 8 dup(2.0)


w_19 sword 16 dup(19)
w_3 sword 16 dup(3)
uw_16 word 16 dup(16)
ub_1 byte 32 dup(1)

d_19 sdword 8 dup(19)
d_3 sdword 8 dup(3)
ud_16 dword 16 dup(16)
uw_1 word 16 dup(1)

f_19 real4 8 dup(0.59375)
f_3 real4 8 dup(0.09375)

sign_bits_f_32 qword 4 dup(7FFFFFFF7FFFFFFFh)
ones_f_32 real4 8 dup(1.0)

.code


;computeNetwork0_AVX2 proc input:dword,weights:dword,ptr_d:dword
; input = rcx
; weights = rdx
; ptr_d = r8

computeNetwork0_AVX2 proc public frame

	sub rsp,32
	.allocstack 32
	vmovdqu XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqu XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog
	
		mov rax,1
		vmovaps ymm7,YMMWORD ptr [rcx]
		vmulps ymm0,ymm7,YMMWORD ptr [rdx]
		vmulps ymm1,ymm7,YMMWORD ptr [rdx+32]
		vmulps ymm2,ymm7,YMMWORD ptr [rdx+64]
		vmulps ymm3,ymm7,YMMWORD ptr [rdx+96]
		
		vmovaps ymm7,YMMWORD ptr [rcx+32]
		vmulps ymm4,ymm7,YMMWORD ptr [rdx+128]
		vmulps ymm5,ymm7,YMMWORD ptr [rdx+160]
		vmulps ymm6,ymm7,YMMWORD ptr [rdx+192]
		vmulps ymm7,ymm7,YMMWORD ptr [rdx+224]
		vaddps ymm0,ymm0,ymm4
		vaddps ymm1,ymm1,ymm5
		vaddps ymm2,ymm2,ymm6
		vaddps ymm3,ymm3,ymm7
		
		vmovaps ymm7,YMMWORD ptr [rcx+64]
		vmulps ymm4,ymm7,YMMWORD ptr [rdx+256]
		vmulps ymm5,ymm7,YMMWORD ptr [rdx+288]
		vmulps ymm6,ymm7,YMMWORD ptr [rdx+320]
		vmulps ymm7,ymm7,YMMWORD ptr [rdx+352]
		vaddps ymm0,ymm0,ymm4
		vaddps ymm1,ymm1,ymm5
		vaddps ymm2,ymm2,ymm6
		vaddps ymm3,ymm3,ymm7
		
		vmovaps ymm7,YMMWORD ptr [rcx+96]
		vmulps ymm4,ymm7,YMMWORD ptr [rdx+384]
		vmulps ymm5,ymm7,YMMWORD ptr [rdx+416]
		vmulps ymm6,ymm7,YMMWORD ptr [rdx+448]
		vmulps ymm7,ymm7,YMMWORD ptr [rdx+480]
		vaddps ymm0,ymm0,ymm4
		vaddps ymm1,ymm1,ymm5
		vaddps ymm2,ymm2,ymm6
		vaddps ymm3,ymm3,ymm7
		
		vmovaps ymm7,YMMWORD ptr [rcx+128]
		vmulps ymm4,ymm7,YMMWORD ptr [rdx+512]
		vmulps ymm5,ymm7,YMMWORD ptr [rdx+544]
		vmulps ymm6,ymm7,YMMWORD ptr [rdx+576]
		vmulps ymm7,ymm7,YMMWORD ptr [rdx+608]
		vaddps ymm0,ymm0,ymm4
		vaddps ymm1,ymm1,ymm5
		vaddps ymm2,ymm2,ymm6
		vaddps ymm3,ymm3,ymm7
		
		vmovaps ymm7,YMMWORD ptr [rcx+160]
		vmulps ymm4,ymm7,YMMWORD ptr [rdx+640]
		vmulps ymm5,ymm7,YMMWORD ptr [rdx+672]
		vmulps ymm6,ymm7,YMMWORD ptr [rdx+704]
		vmulps ymm7,ymm7,YMMWORD ptr [rdx+736]
		vaddps ymm0,ymm0,ymm4
		vaddps ymm1,ymm1,ymm5
		vaddps ymm2,ymm2,ymm6
		vaddps ymm3,ymm3,ymm7
		
		vunpckhpd ymm4,ymm0,ymm1
		vunpckhpd ymm5,ymm2,ymm3
		vunpcklpd ymm0,ymm0,ymm1
		vunpcklpd ymm2,ymm2,ymm3
		vaddps ymm0,ymm0,ymm4
		vaddps ymm2,ymm2,ymm5
		
		vextractf128 xmm4,ymm0,1
		vextractf128 xmm5,ymm2,1
		vaddps xmm0,xmm0,xmm4
		vaddps xmm2,xmm2,xmm5
		
		vshufps xmm6,xmm0,xmm2,221
		vshufps xmm0,xmm0,xmm2,136
		vaddps xmm0,xmm0,xmm6
		vaddps xmm0,xmm0,XMMWORD ptr [rdx+768]
		
		vmovaps xmm1,xmm0
		vandps xmm0,xmm0,XMMWORD ptr sign_bits_f_zero_l
		vaddps xmm0,xmm0,ones_f
		vrcpps xmm0,xmm0
		vmulps xmm0,xmm0,xmm1
		vpshufd xmm1,xmm0,0
		vpshufd xmm2,xmm0,85
		vpshufd xmm3,xmm0,170
		vpshufd xmm4,xmm0,255			
		vmulps xmm1,xmm1,XMMWORD ptr [rdx+784]
		vmulps xmm2,xmm2,XMMWORD ptr [rdx+784+16]
		vmulps xmm3,xmm3,XMMWORD ptr [rdx+784+32]
		vmulps xmm4,xmm4,XMMWORD ptr [rdx+784+48]
		vaddps xmm1,xmm1,xmm2
		vaddps xmm3,xmm3,xmm4
		vaddps xmm1,xmm1,xmm3
		vaddps xmm1,xmm1,XMMWORD ptr [rdx+784+64]
		vmovaps xmm7,xmm1
		vandps xmm1,xmm1,XMMWORD ptr  sign_bits_f
		vmovaps xmm3,xmm0
		vaddps xmm1,xmm1,XMMWORD ptr  ones_f
		vrcpps xmm1,xmm1
		vmulps xmm7,xmm7,xmm1
		vpshufd xmm0,xmm0,0
		vpshufd xmm1,xmm3,85
		vpshufd xmm2,xmm3,170
		vpshufd xmm3,xmm3,255
		vmulps xmm0,xmm0,XMMWORD ptr [rdx+864]
		vmulps xmm1,xmm1,XMMWORD ptr [rdx+864+16]
		vmulps xmm2,xmm2,XMMWORD ptr [rdx+864+32]
		vmulps xmm3,xmm3,XMMWORD ptr [rdx+864+48]
		vpshufd xmm4,xmm7,0
		vpshufd xmm5,xmm7,85
		vpshufd xmm6,xmm7,170
		vpshufd xmm7,xmm7,255
		vmulps xmm4,xmm4,XMMWORD ptr [rdx+864+64]
		vmulps xmm5,xmm5,XMMWORD ptr [rdx+864+80]
		vmulps xmm6,xmm6,XMMWORD ptr [rdx+864+96]
		vmulps xmm7,xmm7,XMMWORD ptr [rdx+864+112]
		vaddps xmm0,xmm0,xmm1
		vaddps xmm2,xmm2,xmm3
		vaddps xmm4,xmm4,xmm5
		vaddps xmm6,xmm6,xmm7
		vaddps xmm0,xmm0,xmm2
		vaddps xmm4,xmm4,xmm6
		vaddps xmm0,xmm0,xmm4
		mov rcx,r8
		vaddps xmm0,xmm0,XMMWORD ptr [rdx+864+128]
		vmovhlps xmm1,xmm1,xmm0
		vmaxps xmm0,xmm0,xmm1
		vpshuflw xmm1,xmm0,14
		vcomiss xmm1,xmm0
		jbe finish_1
		xor rax,rax
finish_1:
		mov BYTE PTR[rcx],al
				
	vmovdqu xmm7,XMMWORD ptr[rsp+16]
	vmovdqu xmm6,XMMWORD ptr[rsp]
	add rsp,32		
		
		vzeroupper
		
		ret

computeNetwork0_AVX2 endp


;computeNetwork0_i16_AVX2 proc inputf:dword,weightsf:dword,ptr_d:dword
; inputf = rcx
; weightsf = rdx
; ptr_d = r8

computeNetwork0_i16_AVX2 proc public frame

	sub rsp,32
	.allocstack 32
	vmovdqu XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqu XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog

		mov rax,1
		
		vmovdqa ymm7,YMMWORD ptr [rcx]
		vpmaddwd ymm0,ymm7,YMMWORD ptr [rdx]
		vpmaddwd ymm1,ymm7,YMMWORD ptr [rdx+32]
		vpmaddwd ymm2,ymm7,YMMWORD ptr [rdx+64]
		vpmaddwd ymm3,ymm7,YMMWORD ptr [rdx+96]
		
		vmovdqa ymm7,YMMWORD ptr [rcx+32]
		vpmaddwd ymm4,ymm7,YMMWORD ptr [rdx+128]
		vpmaddwd ymm5,ymm7,YMMWORD ptr [rdx+160]
		vpmaddwd ymm6,ymm7,YMMWORD ptr [rdx+192]
		vpmaddwd ymm7,ymm7,YMMWORD ptr [rdx+224]		
		vpaddd ymm0,ymm0,ymm4
		vpaddd ymm1,ymm1,ymm5
		vpaddd ymm2,ymm2,ymm6
		vpaddd ymm3,ymm3,ymm7
		
		vmovdqa ymm7,YMMWORD ptr [rcx+64]
		vpmaddwd ymm4,ymm7,YMMWORD ptr [rdx+256]
		vpmaddwd ymm5,ymm7,YMMWORD ptr [rdx+288]
		vpmaddwd ymm6,ymm7,YMMWORD ptr [rdx+320]
		vpmaddwd ymm7,ymm7,YMMWORD ptr [rdx+352]
		vpaddd ymm0,ymm0,ymm4
		vpaddd ymm1,ymm1,ymm5
		vpaddd ymm2,ymm2,ymm6
		vpaddd ymm3,ymm3,ymm7
		
		vpunpckhqdq ymm4,ymm0,ymm1
		vpunpckhqdq ymm5,ymm2,ymm3
		vpunpcklqdq ymm0,ymm0,ymm1
		vpunpcklqdq ymm2,ymm2,ymm3
		vpaddd ymm0,ymm0,ymm4
		vpaddd ymm2,ymm2,ymm5

		vextracti128 xmm4,ymm0,1
		vextracti128 xmm5,ymm2,1
		vpaddd xmm0,xmm0,xmm4
		vpaddd xmm2,xmm2,xmm5
		
		vshufps xmm6,xmm0,xmm2,221
		vshufps xmm0,xmm0,xmm2,136
		vpaddd xmm0,xmm0,xmm6
		vcvtdq2ps xmm0,xmm0
		vmulps xmm0,xmm0,XMMWORD ptr [rdx+384]
		vaddps xmm0,xmm0,XMMWORD ptr [rdx+400]
		vmovaps xmm1,xmm0
		vandps xmm0,xmm0,XMMWORD ptr sign_bits_f_zero_l
		vaddps xmm0,xmm0,XMMWORD ptr ones_f
		vrcpps xmm0,xmm0
		vmulps xmm0,xmm0,xmm1
		vpshufd xmm1,xmm0,0
		vpshufd xmm2,xmm0,85
		vpshufd xmm3,xmm0,170
		vpshufd xmm4,xmm0,255
		vmulps xmm1,xmm1,XMMWORD ptr [rdx+416]
		vmulps xmm2,xmm2,XMMWORD ptr [rdx+416+16]
		vmulps xmm3,xmm3,XMMWORD ptr [rdx+416+32]
		vmulps xmm4,xmm4,XMMWORD ptr [rdx+416+48]
		vaddps xmm1,xmm1,xmm2
		vaddps xmm3,xmm3,xmm4
		vaddps xmm1,xmm1,xmm3
		vaddps xmm1,xmm1,XMMWORD ptr [rdx+416+64]
		vmovaps xmm7,xmm1
		vandps xmm1,xmm1,XMMWORD ptr sign_bits_f
		vmovaps xmm3,xmm0
		vaddps xmm1,xmm1,XMMWORD ptr ones_f
		vrcpps xmm1,xmm1
		vmulps xmm7,xmm7,xmm1
		vpshufd xmm0,xmm0,0
		vpshufd xmm1,xmm3,85
		vpshufd xmm2,xmm3,170
		vpshufd xmm3,xmm3,255
		vmulps xmm0,xmm0,XMMWORD ptr [rdx+496]
		vmulps xmm1,xmm1,XMMWORD ptr [rdx+496+16]
		vmulps xmm2,xmm2,XMMWORD ptr [rdx+496+32]
		vmulps xmm3,xmm3,XMMWORD ptr [rdx+496+48]
		vpshufd xmm4,xmm7,0
		vpshufd xmm5,xmm7,85
		vpshufd xmm6,xmm7,170
		vpshufd xmm7,xmm7,255
		vmulps xmm4,xmm4,XMMWORD ptr [rdx+496+64]
		vmulps xmm5,xmm5,XMMWORD ptr [rdx+496+80]
		vmulps xmm6,xmm6,XMMWORD ptr [rdx+496+96]
		vmulps xmm7,xmm7,XMMWORD ptr [rdx+496+112]
		vaddps xmm0,xmm0,xmm1
		vaddps xmm2,xmm2,xmm3
		vaddps xmm4,xmm4,xmm5
		vaddps xmm6,xmm6,xmm7
		vaddps xmm0,xmm0,xmm2
		vaddps xmm4,xmm4,xmm6
		vaddps xmm0,xmm0,xmm4
		mov rcx,r8
		vaddps xmm0,xmm0,XMMWORD ptr [rdx+496+128]
		vmovhlps xmm1,xmm1,xmm0
		vmaxps xmm0,xmm0,xmm1
		vpshuflw xmm1,xmm0,14
		vcomiss xmm1,xmm0
		jbe finish_2
		xor rax,rax
finish_2:
		mov BYTE PTR[rcx],al
			
	vmovdqu xmm7,XMMWORD ptr[rsp+16]
	vmovdqu xmm6,XMMWORD ptr[rsp]
	add rsp,32		
		
		vzeroupper
		
		ret
		
computeNetwork0_i16_AVX2 endp


;computeNetwork0new_AVX2 proc datai:dword,weights:dword,ptr_d:dword
; datai = rcx
; weights = rdx
; ptr_d = r8

computeNetwork0new_AVX2 proc public frame

	sub rsp,32
	.allocstack 32
	vmovdqu XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqu XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog

		mov rax,rdx
		
		vmovdqa ymm7,YMMWORD ptr [rcx]
		vpmaddwd ymm0,ymm7,YMMWORD ptr [rax]
		vpmaddwd ymm1,ymm7,YMMWORD ptr [rax+32]
		vpmaddwd ymm2,ymm7,YMMWORD ptr [rax+64]
		vpmaddwd ymm3,ymm7,YMMWORD ptr [rax+96]
		
		vmovdqa ymm7,YMMWORD ptr [rcx+32]
		vpmaddwd ymm4,ymm7,YMMWORD ptr [rax+128]
		vpmaddwd ymm5,ymm7,YMMWORD ptr [rax+160]
		vpmaddwd ymm6,ymm7,YMMWORD ptr [rax+192]
		vpmaddwd ymm7,ymm7,YMMWORD ptr [rax+224]
		vpaddd ymm0,ymm0,ymm4
		vpaddd ymm1,ymm1,ymm5
		vpaddd ymm2,ymm2,ymm6
		vpaddd ymm3,ymm3,ymm7
		
		vmovdqa ymm7,YMMWORD ptr [rcx+64]
		vpmaddwd ymm4,ymm7,YMMWORD ptr [rax+256]
		vpmaddwd ymm5,ymm7,YMMWORD ptr [rax+288]
		vpmaddwd ymm6,ymm7,YMMWORD ptr [rax+320]
		vpmaddwd ymm7,ymm7,YMMWORD ptr [rax+352]
		vpaddd ymm0,ymm0,ymm4
		vpaddd ymm1,ymm1,ymm5
		vpaddd ymm2,ymm2,ymm6
		vpaddd ymm3,ymm3,ymm7
		
		vmovdqa ymm7,YMMWORD ptr [rcx+96]
		vpmaddwd ymm4,ymm7,YMMWORD ptr [rax+384]
		vpmaddwd ymm5,ymm7,YMMWORD ptr [rax+416]
		vpmaddwd ymm6,ymm7,YMMWORD ptr [rax+448]
		vpmaddwd ymm7,ymm7,YMMWORD ptr [rax+480]
		vpaddd ymm0,ymm0,ymm4
		vpaddd ymm1,ymm1,ymm5
		vpaddd ymm2,ymm2,ymm6
		vpaddd ymm3,ymm3,ymm7
		
		vpunpckhqdq ymm4,ymm0,ymm1
		vpunpckhqdq ymm5,ymm2,ymm3
		vpunpcklqdq ymm0,ymm0,ymm1
		vpunpcklqdq ymm2,ymm2,ymm3
		vpaddd ymm0,ymm0,ymm4
		vpaddd ymm2,ymm2,ymm5

		vextracti128 xmm4,ymm0,1
		vextracti128 xmm5,ymm2,1
		vpaddd xmm0,xmm0,xmm4
		vpaddd xmm2,xmm2,xmm5
		
		vshufps xmm6,xmm0,xmm2,221
		vshufps xmm0,xmm0,xmm2,136	
		
		vpaddd xmm0,xmm0,xmm6
		vcvtdq2ps xmm0,xmm0		
		vmulps xmm0,xmm0,XMMWORD ptr [rax+512]
		vaddps xmm0,xmm0,XMMWORD ptr [rax+528]
		vmovaps xmm1,xmm0
		vandps xmm0,xmm0,XMMWORD ptr sign_bits_f
		vaddps xmm0,xmm0,XMMWORD ptr ones_f
		vrcpps xmm0,xmm0
		vmulps xmm0,xmm0,xmm1
		vpshufd xmm1,xmm0,0
		vpshufd xmm2,xmm0,85
		vpshufd xmm3,xmm0,170
		vpshufd xmm4,xmm0,255
		vmulps xmm1,xmm1,XMMWORD ptr [rax+544]
		vmulps xmm2,xmm2,XMMWORD ptr [rax+560]
		vmulps xmm3,xmm3,XMMWORD ptr [rax+576]
		vmulps xmm4,xmm4,XMMWORD ptr [rax+592]
		vpxor xmm0,xmm0,xmm0
		vaddps xmm1,xmm1,xmm2
		vaddps xmm3,xmm3,xmm4
		vaddps xmm1,xmm1,xmm3
		mov rcx,r8
		vaddps xmm1,xmm1,XMMWORD ptr [rax+608]
		vcmpps xmm1,xmm1,xmm0,1
		vpackssdw xmm1,xmm1,xmm0
		vpacksswb xmm1,xmm1,xmm0
				
		vmovd eax,xmm1
		xor eax,0FFFFFFFFh
		and eax,001010101h
		mov [rcx],eax
		
	vmovdqu xmm7,XMMWORD ptr[rsp+16]
	vmovdqu xmm6,XMMWORD ptr[rsp]	
	add rsp,32				
		
		vzeroupper
		
		ret
		
computeNetwork0new_AVX2 endp


;processLine0_AVX2_ASM proc tempu:dword,width_:dword,dstp:dword,src3p:dword,src_pitch:dword,val_min:word,val_max:word
; tempu = rcx
; width_ = edx
; dstp = r8
; src3p = r9

processLine0_AVX2_ASM proc public frame

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
	vmovdqu XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqu XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	vmovdqu XMMWORD ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	vmovdqu XMMWORD ptr[rsp+48],xmm9
	.savexmm128 xmm9,48
	vmovdqu XMMWORD ptr[rsp+64],xmm10
	.savexmm128 xmm10,64
	vmovdqu XMMWORD ptr[rsp+80],xmm11
	.savexmm128 xmm11,80
	vmovdqu XMMWORD ptr[rsp+96],xmm12
	.savexmm128 xmm12,96
	vmovdqu XMMWORD ptr[rsp+112],xmm13
	.savexmm128 xmm13,112
	.endprolog
		
		vpbroadcastw ymm12,val_min
		vpbroadcastw ymm13,val_max
				
		mov rax,rcx
		mov rbx,r9
		xor rcx,rcx
		mov ecx,edx
		movsxd rdx,src_pitch
		mov rsi,r8
		mov r8,32
		
		lea rdi,[rbx+rdx*4]
		
		vmovdqa ymm8,YMMWORD ptr w_19
		vmovdqa ymm9,YMMWORD ptr w_3
		vmovdqa ymm10,YMMWORD ptr ub_1
		vmovdqa ymm11,YMMWORD ptr uw_16		
		vpxor ymm6,ymm6,ymm6
		vpxor ymm7,ymm7,ymm7
		
xloop:
		vmovdqa ymm0,YMMWORD PTR [rbx+rdx*2]
		vmovdqa ymm1,YMMWORD PTR [rdi]
		vpunpckhbw ymm2,ymm0,ymm7
		vpunpckhbw ymm3,ymm1,ymm7
		vpunpcklbw ymm0,ymm0,ymm7
		vpunpcklbw ymm1,ymm1,ymm7
		vpaddw ymm0,ymm0,ymm1
		vpaddw ymm2,ymm2,ymm3
		vpmullw ymm0,ymm0,ymm8
		vpmullw ymm2,ymm2,ymm8
		vmovdqa ymm1,YMMWORD PTR [rbx]
		vmovdqa ymm3,YMMWORD PTR [rdi+rdx*2]
		vpunpckhbw ymm4,ymm1,ymm7
		vpunpckhbw ymm5,ymm3,ymm7
		vpunpcklbw ymm1,ymm1,ymm7
		vpunpcklbw ymm3,ymm3,ymm7
		vpaddw ymm1,ymm1,ymm3
		vpaddw ymm4,ymm4,ymm5
		vpmullw ymm1,ymm1,ymm9
		vpmullw ymm4,ymm4,ymm9
		vmovdqa ymm5,YMMWORD PTR [rax]
		vpsubusw ymm0,ymm0,ymm1
		vpsubusw ymm2,ymm2,ymm4
		vpxor ymm5,ymm5,ymm10
		vpaddusw ymm0,ymm0,ymm11
		vpaddusw ymm2,ymm2,ymm11
		vpsadbw ymm5,ymm5,ymm7		
		vpsraw ymm0,ymm0,5
		vpsraw ymm2,ymm2,5
		vmovdqa ymm3,ymm5
		vpminsw ymm0,ymm0,ymm13
		vpsrldq ymm5,ymm5,8
		vpminsw ymm2,ymm2,ymm13
		vpaddusw ymm5,ymm5,ymm3
		vpmaxsw ymm0,ymm0,ymm12
		vpmaxsw ymm2,ymm2,ymm12
		vextracti128 xmm3,ymm5,1
		vpackuswb ymm0,ymm0,ymm2
		vpaddusw xmm5,xmm5,xmm3
		vmovdqa YMMWORD PTR [rsi],ymm0
		vpaddusw xmm6,xmm6,xmm5		
		
		add rbx,r8
		add rdi,r8
		add rax,r8
		add rsi,r8
		sub rcx,r8
		jnz xloop
					
		xor  rax,rax
		vmovd eax,xmm6		
		
	vmovdqu xmm13,XMMWORD ptr[rsp+112]
	vmovdqu xmm12,XMMWORD ptr[rsp+96]
	vmovdqu xmm11,XMMWORD ptr[rsp+80]
	vmovdqu xmm10,XMMWORD ptr[rsp+64]
	vmovdqu xmm9,XMMWORD ptr[rsp+48]
	vmovdqu xmm8,XMMWORD ptr[rsp+32]
	vmovdqu xmm7,XMMWORD ptr[rsp+16]
	vmovdqu xmm6,XMMWORD ptr[rsp]	
	add rsp,128	
	pop rdi
	pop rsi
	pop rbx
	pop rbp
	
	vzeroupper
	
		ret
		
processLine0_AVX2_ASM endp


;processLine0_AVX2_ASM_16 proc tempu:dword,width_:dword,dstp:dword,src3p:dword,src_pitch:dword,val_min:word,val_max:word
; tempu = rcx
; width_ = edx
; dstp = r8
; src3p = r9

processLine0_AVX2_ASM_16 proc public frame

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
	vmovdqu XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqu XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	vmovdqu XMMWORD ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	vmovdqu XMMWORD ptr[rsp+48],xmm9
	.savexmm128 xmm9,48
	vmovdqu XMMWORD ptr[rsp+64],xmm10
	.savexmm128 xmm10,64
	vmovdqu XMMWORD ptr[rsp+80],xmm11
	.savexmm128 xmm11,80
	vmovdqu XMMWORD ptr[rsp+96],xmm12
	.savexmm128 xmm12,96
	vmovdqu XMMWORD ptr[rsp+112],xmm13
	.savexmm128 xmm13,112
	.endprolog
		
		vpbroadcastw ymm12,val_min
		vpbroadcastw ymm13,val_max
				
		mov rax,rcx
		mov rbx,r9
		xor rcx,rcx
		mov ecx,edx
		movsxd rdx,src_pitch
		mov rsi,r8
		mov r8,32
		mov r9,16
			
		lea rdi,[rbx+rdx*4]
		
		vmovdqa ymm8,YMMWORD ptr d_19
		vmovdqa ymm9,YMMWORD ptr d_3
		vmovdqa xmm10,XMMWORD ptr ub_1
		vmovdqa ymm11,YMMWORD ptr ud_16		
		vpxor ymm6,ymm6,ymm6
		vpxor ymm7,ymm7,ymm7
		
xloop_16:
		vmovdqa ymm0,YMMWORD ptr[rbx+rdx*2]
		vmovdqa ymm1,YMMWORD ptr[rdi]
		vpunpckhwd ymm2,ymm0,ymm7
		vpunpckhwd ymm3,ymm1,ymm7
		vpunpcklwd ymm0,ymm0,ymm7
		vpunpcklwd ymm1,ymm1,ymm7
		vpaddd ymm0,ymm0,ymm1
		vpaddd ymm2,ymm2,ymm3
		vpmulld ymm0,ymm0,ymm8
		vpmulld ymm2,ymm2,ymm8
		vmovdqa ymm1,YMMWORD ptr[rbx]
		vmovdqa ymm3,YMMWORD ptr[rdi+rdx*2]
		vpunpckhwd ymm4,ymm1,ymm7
		vpunpckhwd ymm5,ymm3,ymm7
		vpunpcklwd ymm1,ymm1,ymm7
		vpunpcklwd ymm3,ymm3,ymm7
		vpaddd ymm1,ymm1,ymm3
		vpaddd ymm4,ymm4,ymm5
		vpmulld ymm1,ymm1,ymm9
		vpmulld ymm4,ymm4,ymm9
		vpsubd ymm0,ymm0,ymm1
		vpsubd ymm2,ymm2,ymm4
		vmovdqa xmm5,XMMWORD ptr [rax]
		vpaddd ymm0,ymm0,ymm11
		vpaddd ymm2,ymm2,ymm11
		vpxor xmm5,xmm5,xmm10
		vpsrad ymm0,ymm0,5		
		vpsrad ymm2,ymm2,5
		vpsadbw xmm5,xmm5,xmm7
		vpackusdw ymm0,ymm0,ymm2
		vmovdqa xmm3,xmm5
		vpminuw ymm0,ymm0,ymm13
		vpsrldq xmm5,xmm5,8
		vpmaxuw ymm0,ymm0,ymm12
		vpaddusw xmm5,xmm5,xmm3
		vmovdqa YMMWORD ptr [rsi],ymm0
		vpaddusw xmm6,xmm6,xmm5
		
		add rbx,r8
		add rdi,r8
		add rax,r9
		add rsi,r8
		sub rcx,r9
		jnz xloop_16
					
		xor  rax,rax
		vmovd eax,xmm6		
		
	vmovdqu xmm13,XMMWORD ptr[rsp+112]
	vmovdqu xmm12,XMMWORD ptr[rsp+96]
	vmovdqu xmm11,XMMWORD ptr[rsp+80]
	vmovdqu xmm10,XMMWORD ptr[rsp+64]
	vmovdqu xmm9,XMMWORD ptr[rsp+48]
	vmovdqu xmm8,XMMWORD ptr[rsp+32]
	vmovdqu xmm7,XMMWORD ptr[rsp+16]
	vmovdqu xmm6,XMMWORD ptr[rsp]	
	add rsp,128	
	pop rdi
	pop rsi
	pop rbx
	pop rbp
	
	vzeroupper
	
		ret
		
processLine0_AVX2_ASM_16 endp


;processLine0_AVX2_ASM_32 proc tempu:dword,width_:dword,dstp:dword,src3p:dword,src_pitch:dword
; tempu = rcx
; width_ = edx
; dstp = r8
; src3p = r9

processLine0_AVX2_ASM_32 proc public frame

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
	vmovdqu XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqu XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	vmovdqu XMMWORD ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	vmovdqu XMMWORD ptr[rsp+48],xmm9
	.savexmm128 xmm9,48
	.endprolog

		mov rax,rcx
		mov rbx,r9
		xor rcx,rcx
		mov ecx,edx
		movsxd rdx,src_pitch
		mov rsi,r8
		mov r8,32
		mov r9,8
		
		lea rdi,[rbx+rdx*4]
		vpxor ymm5,ymm5,ymm5
		vpxor ymm6,ymm6,ymm6
		vmovaps ymm7,YMMWORD ptr f_19
		vmovaps ymm8,YMMWORD ptr f_3
		vmovdqa xmm9,XMMWORD ptr uw_1
		
xloop_32:
		vmovq xmm4,qword ptr [rax]
		vmovaps ymm2,YMMWORD ptr[rbx]		
		vmovaps ymm0,YMMWORD ptr[rbx+rdx*2]
		vpunpcklbw xmm4,xmm4,xmm6		
		vmovaps ymm1,YMMWORD ptr[rdi]
		vmovaps ymm3,YMMWORD ptr[rdi+rdx*2]		
		vaddps ymm0,ymm0,ymm1
		vpxor xmm4,xmm4,xmm9		
		vaddps ymm2,ymm2,ymm3		
		vpsadbw xmm4,xmm4,xmm6
		vmulps ymm0,ymm0,ymm7
		vmovdqa xmm3,xmm4
		vmulps ymm2,ymm2,ymm8
		vpsrldq xmm4,xmm4,8
		vsubps ymm0,ymm0,ymm2	
		vpaddusw xmm4,xmm4,xmm3
		vmovaps YMMWORD ptr[rsi],ymm0
		vpaddusw xmm5,xmm5,xmm4		
		add rbx,r8
		add rdi,r8
		add rax,r9
		add rsi,r8
		sub rcx,r9
		jnz xloop_32
				
		xor  rax,rax
		vmovd eax,xmm5
		
	vmovdqu xmm9,XMMWORD ptr[rsp+48]
	vmovdqu xmm8,XMMWORD ptr[rsp+32]
	vmovdqu xmm7,XMMWORD ptr[rsp+16]
	vmovdqu xmm6,XMMWORD ptr[rsp]	
	add rsp,64
	pop rdi
	pop rsi
	pop rbx
	pop rbp
			
	vzeroupper		
			
		ret
		
processLine0_AVX2_ASM_32 endp


;uc2f48_AVX2 proc ptr_t:dword,pitch:dword,ptr_p:dword
; ptr_t = rcx
; pitch = edx
; ptr_p = r8

uc2f48_AVX2 proc public frame

		.endprolog

		mov rax,rcx
		movsxd rcx,edx		
		vpxor ymm4,ymm4,ymm4
		
		test rax,15
		jnz unaligned_1
		
		vmovdqa xmm0,XMMWORD PTR[rax]
		vmovdqa xmm2,XMMWORD PTR[rax+rcx*2]		
		vmovhlps xmm1,xmm4,xmm0
		vmovhlps xmm3,xmm4,xmm2
		vinserti128 ymm0,ymm0,xmm1,1
		vinserti128 ymm2,ymm2,xmm3,1		
		
		vpunpcklbw ymm1,ymm0,ymm4
		vpunpcklbw ymm3,ymm2,ymm4
		
		vpunpcklwd ymm0,ymm1,ymm4				
		vpunpcklwd ymm2,ymm3,ymm4
		vpunpckhwd ymm1,ymm1,ymm4
		vpunpckhwd ymm3,ymm3,ymm4		
		lea rax,[rax+rcx*4]
		vcvtdq2ps ymm0,ymm0
		vcvtdq2ps xmm1,xmm1		
		vcvtdq2ps ymm2,ymm2
		vcvtdq2ps xmm3,xmm3
		vmovaps XMMWORD ptr[r8],xmm0
		vextractf128 xmm5,ymm0,1
		vmovaps XMMWORD ptr[r8+16],xmm1
		vmovaps XMMWORD ptr[r8+32],xmm5
		vmovaps XMMWORD ptr[r8+48],xmm2
		vextractf128 xmm5,ymm2,1
		vmovaps XMMWORD ptr[r8+64],xmm3
		vmovaps XMMWORD ptr[r8+80],xmm5
		
		vmovdqa xmm0,XMMWORD PTR[rax]
		vmovdqa xmm2,XMMWORD PTR[rax+rcx*2]
		jmp suite_1		

unaligned_1:		
		vmovdqu xmm0,XMMWORD PTR[rax]
		vmovdqu xmm2,XMMWORD PTR[rax+rcx*2]		
		vmovhlps xmm1,xmm4,xmm0
		vmovhlps xmm3,xmm4,xmm2
		vinserti128 ymm0,ymm0,xmm1,1
		vinserti128 ymm2,ymm2,xmm3,1				
		
		vpunpcklbw ymm1,ymm0,ymm4
		vpunpcklbw ymm3,ymm2,ymm4
		
		vpunpcklwd ymm0,ymm1,ymm4
		vpunpcklwd ymm2,ymm3,ymm4
		vpunpckhwd ymm1,ymm1,ymm4
		vpunpckhwd ymm3,ymm3,ymm4		
		lea rax,[rax+rcx*4]
		vcvtdq2ps ymm0,ymm0
		vcvtdq2ps xmm1,xmm1
		vcvtdq2ps ymm2,ymm2
		vcvtdq2ps xmm3,xmm3
		vmovaps XMMWORD ptr[r8],xmm0
		vextractf128 xmm5,ymm0,1
		vmovaps XMMWORD ptr[r8+16],xmm1
		vmovaps XMMWORD ptr[r8+32],xmm5
		vmovaps XMMWORD ptr[r8+48],xmm2
		vextractf128 xmm5,ymm2,1
		vmovaps XMMWORD ptr[r8+64],xmm3
		vmovaps XMMWORD ptr[r8+80],xmm5
				
		vmovdqu xmm0,XMMWORD PTR[rax]
		vmovdqu xmm2,XMMWORD PTR[rax+rcx*2]				
suite_1:		
		vmovhlps xmm1,xmm4,xmm0
		vmovhlps xmm3,xmm4,xmm2
		vinserti128 ymm0,ymm0,xmm1,1
		vinserti128 ymm2,ymm2,xmm3,1				

		vpunpcklbw ymm1,ymm0,ymm4
		vpunpcklbw ymm3,ymm2,ymm4
		
		vpunpcklwd ymm0,ymm1,ymm4
		vpunpcklwd ymm2,ymm3,ymm4
		vpunpckhwd ymm1,ymm1,ymm4
		vpunpckhwd ymm3,ymm3,ymm4		
		vcvtdq2ps ymm0,ymm0
		vcvtdq2ps xmm1,xmm1
		vcvtdq2ps ymm2,ymm2
		vcvtdq2ps xmm3,xmm3
		vmovaps XMMWORD ptr[r8+96],xmm0
		vextractf128 xmm5,ymm0,1
		vmovaps XMMWORD ptr[r8+112],xmm1
		vmovaps XMMWORD ptr[r8+128],xmm5		
		vmovaps XMMWORD ptr[r8+144],xmm2
		vextractf128 xmm5,ymm2,1
		vmovaps XMMWORD ptr[r8+160],xmm3
		vmovaps XMMWORD ptr[r8+176],xmm5		
		
		vzeroupper
		
		ret
		
uc2f48_AVX2 endp


;uc2f48_AVX2_16 proc ptr_t:dword,pitch:dword,ptr_p:dword
; ptr_t = rcx
; pitch = edx
; ptr_p = r8

uc2f48_AVX2_16 proc public frame

		.endprolog

		mov rax,rcx
		movsxd rcx,edx		
		vpxor ymm4,ymm4,ymm4
		
		test rax,31
		jnz short unaligned_2
				
		vmovdqa ymm1,YMMWORD ptr[rax]
		vmovdqa ymm3,YMMWORD ptr[rax+rcx*2]	
		vpunpcklwd ymm0,ymm1,ymm4
		vpunpcklwd ymm2,ymm3,ymm4
		vpunpckhwd ymm1,ymm1,ymm4
		vpunpckhwd ymm3,ymm3,ymm4		
		lea rax,[rax+rcx*4]		
		vcvtdq2ps ymm0,ymm0
		vcvtdq2ps xmm1,xmm1
		vcvtdq2ps ymm2,ymm2
		vcvtdq2ps xmm3,xmm3
		vmovaps XMMWORD ptr[r8],xmm0
		vextractf128 xmm5,ymm0,1
		vmovaps XMMWORD ptr[r8+16],xmm1
		vmovaps XMMWORD ptr[r8+32],xmm5		
		vmovaps XMMWORD ptr[r8+48],xmm2
		vextractf128 xmm5,ymm2,1
		vmovaps XMMWORD ptr[r8+64],xmm3
		vmovaps XMMWORD ptr[r8+80],xmm5
		
		vmovdqa ymm1,YMMWORD ptr[rax]
		vmovdqa ymm3,YMMWORD ptr[rax+rcx*2]
		jmp short suite_2

unaligned_2:
		vmovdqu ymm1,YMMWORD ptr[rax]
		vmovdqu ymm3,YMMWORD ptr[rax+rcx*2]
		vpunpcklwd ymm0,ymm1,ymm4
		vpunpcklwd ymm2,ymm3,ymm4
		vpunpckhwd ymm1,ymm1,ymm4
		vpunpckhwd ymm3,ymm3,ymm4		
		lea rax,[rax+rcx*4]		
		vcvtdq2ps ymm0,ymm0
		vcvtdq2ps xmm1,xmm1
		vcvtdq2ps ymm2,ymm2
		vcvtdq2ps xmm3,xmm3
		vmovaps XMMWORD ptr[r8],xmm0
		vextractf128 xmm5,ymm0,1
		vmovaps XMMWORD ptr[r8+16],xmm1
		vmovaps XMMWORD ptr[r8+32],xmm5		
		vmovaps XMMWORD ptr[r8+48],xmm2
		vextractf128 xmm5,ymm2,1
		vmovaps XMMWORD ptr[r8+64],xmm3
		vmovaps XMMWORD ptr[r8+80],xmm5
		
		vmovdqu ymm1,YMMWORD ptr[rax]
		vmovdqu ymm3,YMMWORD ptr[rax+rcx*2]
		
suite_2:		
		vpunpcklwd ymm0,ymm1,ymm4
		vpunpcklwd ymm2,ymm3,ymm4
		vpunpckhwd ymm1,ymm1,ymm4
		vpunpckhwd ymm3,ymm3,ymm4		
		vcvtdq2ps ymm0,ymm0
		vcvtdq2ps xmm1,xmm1
		vcvtdq2ps ymm2,ymm2
		vcvtdq2ps xmm3,xmm3
		vmovaps XMMWORD ptr[r8+96],xmm0
		vextractf128 xmm5,ymm0,1
		vmovaps XMMWORD ptr[r8+112],xmm1
		vmovaps XMMWORD ptr[r8+128],xmm5		
		vmovaps XMMWORD ptr[r8+144],xmm2
		vextractf128 xmm5,ymm2,1
		vmovaps XMMWORD ptr[r8+160],xmm3
		vmovaps XMMWORD ptr[r8+176],xmm5

		vzeroupper
		
		ret
		
uc2f48_AVX2_16 endp



;uc2s48_AVX2 proc ptr_t:dword,pitch:dword,ptr_pf:dword
; ptr_t = rcx
; pitch = edx
; ptr_pf = r8

uc2s48_AVX2 proc public frame

	sub rsp,32
	.allocstack 32
	vmovdqu XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqu XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog

		mov rax,rcx
		movsxd rcx,edx
		lea rdx,[rax+rcx*4]
		vmovq xmm0,QWORD PTR[rax]
		vmovd xmm1,dword ptr[rax+8]
		vmovd xmm2,dword ptr[rax+rcx*2]
		vmovq xmm3,QWORD PTR[rax+rcx*2+4]
		vmovq xmm4,QWORD PTR[rdx]
		vmovd xmm5,dword ptr[rdx+8]
		vmovd xmm6,dword ptr[rdx+rcx*2]
		vmovq xmm7,QWORD PTR[rdx+rcx*2+4]
		vpunpckldq xmm1,xmm1,xmm2
		vpxor xmm2,xmm2,xmm2
		vpunpckldq xmm5,xmm5,xmm6
		vpunpcklbw xmm0,xmm0,xmm2
		vpunpcklbw xmm3,xmm3,xmm2
		vpunpcklbw xmm1,xmm1,xmm2
		vpunpcklbw xmm4,xmm4,xmm2
		vpunpcklbw xmm5,xmm5,xmm2
		vpunpcklbw xmm7,xmm7,xmm2
		vmovdqa XMMWORD ptr[r8],xmm0
		vmovdqa XMMWORD ptr[r8+16],xmm1
		vmovdqa XMMWORD ptr[r8+32],xmm3
		vmovdqa XMMWORD ptr[r8+48],xmm4
		vmovdqa XMMWORD ptr[r8+64],xmm5
		vmovdqa XMMWORD ptr[r8+80],xmm7
		
	vmovdqu xmm7,XMMWORD ptr[rsp+16]
	vmovdqu xmm6,XMMWORD ptr[rsp]
	add rsp,32				
		
		vzeroupper
		
		ret

uc2s48_AVX2 endp

;uc2s64_AVX2 proc ptr_t:dword,pitch:dword,ptr_p:dword
; ptr_t = rcx
; pitch = edx
; ptr_p = r8

uc2s64_AVX2 proc public frame

		.endprolog
	
		mov rax,rcx
		movsxd rcx,edx
		lea rdx,[rax+rcx*4]
		vpxor ymm4,ymm4,ymm4
		
		test rax,15
		jnz short unaligned_3		
		
		vmovdqa xmm0,XMMWORD ptr[rax]
		vmovdqa xmm1,XMMWORD PTR[rax+rcx*2]
		vmovdqa xmm2,XMMWORD ptr[rdx]
		vmovdqa xmm3,XMMWORD PTR[rdx+rcx*2]
		jmp short suite_3
		
unaligned_3:		
		vmovdqu xmm0,XMMWORD ptr[rax]
		vmovdqu xmm1,XMMWORD PTR[rax+rcx*2]
		vmovdqu xmm2,XMMWORD ptr[rdx]
		vmovdqu xmm3,XMMWORD PTR[rdx+rcx*2]		
suite_3:				
		vmovhlps xmm5,xmm4,xmm0
		vinserti128 ymm0,ymm0,xmm5,1
		vmovhlps xmm5,xmm4,xmm1
		vinserti128 ymm1,ymm1,xmm5,1
		vmovhlps xmm5,xmm4,xmm2
		vinserti128 ymm2,ymm2,xmm5,1
		vmovhlps xmm5,xmm4,xmm3
		vinserti128 ymm3,ymm3,xmm5,1
		
		vpunpcklbw ymm0,ymm0,ymm4
		vpunpcklbw ymm1,ymm1,ymm4		
		vpunpcklbw ymm2,ymm2,ymm4
		vpunpcklbw ymm3,ymm3,ymm4
		vmovdqa YMMWORD ptr [r8],ymm0
		vmovdqa YMMWORD ptr [r8+32],ymm1
		vmovdqa YMMWORD ptr [r8+64],ymm2
		vmovdqa YMMWORD ptr [r8+96],ymm3
		
		vzeroupper

		ret
		
uc2s64_AVX2 endp


;computeNetwork0_FMA3 proc input:dword,weights:dword,ptr_d:dword
; input = rcx
; weights = rdx
; ptr_d = r8

computeNetwork0_FMA3 proc public frame

	sub rsp,32
	.allocstack 32
	vmovdqu XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqu XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog
	
		mov rax,1
		vmovaps ymm4,YMMWORD ptr [rcx]
		vmulps ymm0,ymm4,YMMWORD ptr [rdx]
		vmulps ymm1,ymm4,YMMWORD ptr [rdx+32]
		vmulps ymm2,ymm4,YMMWORD ptr [rdx+64]
		vmulps ymm3,ymm4,YMMWORD ptr [rdx+96]
		
		vmovaps ymm4,YMMWORD ptr [rcx+32]
		
		vfmadd231ps ymm0,ymm4,YMMWORD ptr [rdx+128]
		vfmadd231ps ymm1,ymm4,YMMWORD ptr [rdx+160]
		vfmadd231ps ymm2,ymm4,YMMWORD ptr [rdx+192]
		vfmadd231ps ymm3,ymm4,YMMWORD ptr [rdx+224]
		
		vmovaps ymm4,YMMWORD ptr [rcx+64]
		
		vfmadd231ps ymm0,ymm4,YMMWORD ptr [rdx+256]
		vfmadd231ps ymm1,ymm4,YMMWORD ptr [rdx+288]
		vfmadd231ps ymm2,ymm4,YMMWORD ptr [rdx+320]
		vfmadd231ps ymm3,ymm4,YMMWORD ptr [rdx+352]
		
		vmovaps ymm4,YMMWORD ptr [rcx+96]
		
		vfmadd231ps ymm0,ymm4,YMMWORD ptr [rdx+384]
		vfmadd231ps ymm1,ymm4,YMMWORD ptr [rdx+416]
		vfmadd231ps ymm2,ymm4,YMMWORD ptr [rdx+448]
		vfmadd231ps ymm3,ymm4,YMMWORD ptr [rdx+480]
		
		vmovaps ymm4,YMMWORD ptr [rcx+128]
		
		vfmadd231ps ymm0,ymm4,YMMWORD ptr [rdx+512]
		vfmadd231ps ymm1,ymm4,YMMWORD ptr [rdx+544]
		vfmadd231ps ymm2,ymm4,YMMWORD ptr [rdx+576]
		vfmadd231ps ymm3,ymm4,YMMWORD ptr [rdx+608]
		
		vmovaps ymm4,YMMWORD ptr [rcx+160]
		
		vfmadd231ps ymm0,ymm4,YMMWORD ptr [rdx+640]
		vfmadd231ps ymm1,ymm4,YMMWORD ptr [rdx+672]
		vfmadd231ps ymm2,ymm4,YMMWORD ptr [rdx+704]
		vfmadd231ps ymm3,ymm4,YMMWORD ptr [rdx+736]		
		
		vhaddps ymm0,ymm0,ymm1
		vhaddps ymm2,ymm2,ymm3
		vhaddps ymm0,ymm0,ymm2
		
		vextractf128 xmm4,ymm0,1
		vaddps xmm0,xmm0,xmm4
		
		vaddps xmm0,xmm0,XMMWORD ptr [rdx+768]
		
		vmovaps xmm1,xmm0
		vandps xmm0,xmm0,XMMWORD ptr sign_bits_f_zero_l
		vaddps xmm0,xmm0,XMMWORD ptr ones_f
		vrcpps xmm0,xmm0
		vmulps xmm0,xmm0,xmm1
		
		vpshufd xmm1,xmm0,0
		vpshufd xmm2,xmm0,85
		vpshufd xmm3,xmm0,170
		vpshufd xmm4,xmm0,255
		
		vmulps xmm1,xmm1,XMMWORD ptr [rdx+784]
		vfmadd231ps xmm1,xmm2,XMMWORD ptr [rdx+784+16]
		vmulps xmm3,xmm3,XMMWORD ptr [rdx+784+32]
		vfmadd231ps xmm3,xmm4,XMMWORD ptr [rdx+784+48]
		vaddps xmm1,xmm1,xmm3
		vaddps xmm1,xmm1,XMMWORD ptr [rdx+784+64]
		
		vmovaps xmm7,xmm1
		vandps xmm1,xmm1, XMMWORD ptr sign_bits_f
		vmovaps xmm3,xmm0
		vaddps xmm1,xmm1,XMMWORD ptr ones_f
		vrcpps xmm1,xmm1
		vmulps xmm7,xmm7,xmm1

		vpshufd xmm0,xmm0,0
		vpshufd xmm1,xmm3,85
		vpshufd xmm2,xmm3,170
		vpshufd xmm3,xmm3,255
		vmulps xmm0,xmm0,XMMWORD ptr [rdx+864]
		vfmadd231ps xmm0,xmm1,XMMWORD ptr [rdx+864+16]
		vmulps xmm2,xmm2,XMMWORD ptr [rdx+864+32]
		vfmadd231ps xmm2,xmm3,XMMWORD ptr [rdx+864+48]
		
		vpshufd xmm4,xmm7,0
		vpshufd xmm5,xmm7,85
		vpshufd xmm6,xmm7,170
		vpshufd xmm7,xmm7,255
		
		vmulps xmm4,xmm4,XMMWORD ptr [rdx+864+64]
		vfmadd231ps xmm4,xmm5,XMMWORD ptr [rdx+864+80]
		vmulps xmm6,xmm6,XMMWORD ptr [rdx+864+96]
		vfmadd231ps xmm6,xmm7,XMMWORD ptr [rdx+864+112]		
		
		vaddps xmm0,xmm0,xmm2
		vaddps xmm4,xmm4,xmm6
		vaddps xmm0,xmm0,xmm4
		mov rcx,r8
		vaddps xmm0,xmm0,XMMWORD ptr [rdx+864+128]
		vmovhlps xmm1,xmm1,xmm0
		vmaxps xmm0,xmm0,xmm1
		vpshuflw xmm1,xmm0,14
		vcomiss xmm1,xmm0
		jbe finish_1a
		xor rax,rax
finish_1a:
		mov BYTE PTR[rcx],al
				
	vmovdqu xmm7,XMMWORD ptr[rsp+16]
	vmovdqu xmm6,XMMWORD ptr[rsp]
	add rsp,32		
		
	vzeroupper
		
		ret

computeNetwork0_FMA3 endp


;computeNetwork0_FMA4 proc input:dword,weights:dword,ptr_d:dword
; input = rcx
; weights = rdx
; ptr_d = r8

computeNetwork0_FMA4 proc public frame

	sub rsp,32
	.allocstack 32
	vmovdqu XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqu XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog
	
		mov rax,1
		vmovaps ymm4,YMMWORD ptr [rcx]
		vmulps ymm0,ymm4,YMMWORD ptr [rdx]
		vmulps ymm1,ymm4,YMMWORD ptr [rdx+32]
		vmulps ymm2,ymm4,YMMWORD ptr [rdx+64]
		vmulps ymm3,ymm4,YMMWORD ptr [rdx+96]
		
		vmovaps ymm4,YMMWORD ptr [rcx+32]
		vfmaddps ymm0,ymm4,YMMWORD ptr [rdx+128],ymm0
		vfmaddps ymm1,ymm4,YMMWORD ptr [rdx+160],ymm1
		vfmaddps ymm2,ymm4,YMMWORD ptr [rdx+192],ymm2
		vfmaddps ymm3,ymm4,YMMWORD ptr [rdx+224],ymm3		
		
		vmovaps ymm4,YMMWORD ptr [rcx+64]		
		vfmaddps ymm0,ymm4,YMMWORD ptr [rdx+256],ymm0
		vfmaddps ymm1,ymm4,YMMWORD ptr [rdx+288],ymm1
		vfmaddps ymm2,ymm4,YMMWORD ptr [rdx+320],ymm2
		vfmaddps ymm3,ymm4,YMMWORD ptr [rdx+352],ymm3
				
		vmovaps ymm4,YMMWORD ptr [rcx+96]		
		vfmaddps ymm0,ymm4,YMMWORD ptr [rdx+384],ymm0
		vfmaddps ymm1,ymm4,YMMWORD ptr [rdx+416],ymm1
		vfmaddps ymm2,ymm4,YMMWORD ptr [rdx+448],ymm2
		vfmaddps ymm3,ymm4,YMMWORD ptr [rdx+480],ymm3
				
		vmovaps ymm4,YMMWORD ptr [rcx+128]		
		vfmaddps ymm0,ymm4,YMMWORD ptr [rdx+512],ymm0
		vfmaddps ymm1,ymm4,YMMWORD ptr [rdx+544],ymm1
		vfmaddps ymm2,ymm4,YMMWORD ptr [rdx+576],ymm2
		vfmaddps ymm3,ymm4,YMMWORD ptr [rdx+608],ymm3
				
		vmovaps ymm4,YMMWORD ptr [rcx+160]		
		vfmaddps ymm0,ymm4,YMMWORD ptr [rdx+640],ymm0
		vfmaddps ymm1,ymm4,YMMWORD ptr [rdx+672],ymm1
		vfmaddps ymm2,ymm4,YMMWORD ptr [rdx+704],ymm2
		vfmaddps ymm3,ymm4,YMMWORD ptr [rdx+736],ymm3
				
		vhaddps ymm0,ymm0,ymm1
		vhaddps ymm2,ymm2,ymm3
		vhaddps ymm0,ymm0,ymm2
		
		vextractf128 xmm4,ymm0,1
		vaddps xmm0,xmm0,xmm4
		
		vaddps xmm0,xmm0,XMMWORD ptr [rdx+768]
		
		vmovaps xmm1,xmm0
		vandps xmm0,xmm0,XMMWORD ptr sign_bits_f_zero_l
		vaddps xmm0,xmm0,XMMWORD ptr ones_f
		vrcpps xmm0,xmm0
		vmulps xmm0,xmm0,xmm1
		
		vpshufd xmm1,xmm0,0
		vpshufd xmm2,xmm0,85
		vpshufd xmm3,xmm0,170
		vpshufd xmm4,xmm0,255
		
		vmulps xmm1,xmm1,XMMWORD ptr [rdx+784]
		vfmaddps xmm1,xmm2,XMMWORD ptr [rdx+784+16],xmm1
		vmulps xmm3,xmm3,XMMWORD ptr [rdx+784+32]
		vfmaddps xmm3,xmm4,XMMWORD ptr [rdx+784+48],xmm3
		vaddps xmm1,xmm1,xmm3
		vaddps xmm1,xmm1,XMMWORD ptr [rdx+784+64]
		
		vmovaps xmm7,xmm1
		vandps xmm1,xmm1, XMMWORD ptr sign_bits_f
		vmovaps xmm3,xmm0
		vaddps xmm1,xmm1,XMMWORD ptr ones_f
		vrcpps xmm1,xmm1
		vmulps xmm7,xmm7,xmm1

		vpshufd xmm0,xmm0,0
		vpshufd xmm1,xmm3,85
		vpshufd xmm2,xmm3,170
		vpshufd xmm3,xmm3,255
		vmulps xmm0,xmm0,XMMWORD ptr [rdx+864]
		vfmaddps xmm0,xmm1,XMMWORD ptr [rdx+864+16],xmm0
		vmulps xmm2,xmm2,XMMWORD ptr [rdx+864+32]
		vfmaddps xmm2,xmm3,XMMWORD ptr [rdx+864+48],xmm2	

		vpshufd xmm4,xmm7,0
		vpshufd xmm5,xmm7,85
		vpshufd xmm6,xmm7,170
		vpshufd xmm7,xmm7,255
		
		vmulps xmm4,xmm4,XMMWORD ptr [rdx+864+64]
		vfmaddps xmm4,xmm5,XMMWORD ptr [rdx+864+80],xmm4
		vmulps xmm6,xmm6,XMMWORD ptr [rdx+864+96]
		vfmaddps xmm6,xmm7,XMMWORD ptr [rdx+864+112],xmm6

		vaddps xmm0,xmm0,xmm2
		vaddps xmm4,xmm4,xmm6
		vaddps xmm0,xmm0,xmm4
		mov rcx,r8
		vaddps xmm0,xmm0,XMMWORD ptr [rdx+864+128]
		vmovhlps xmm1,xmm1,xmm0
		vmaxps xmm0,xmm0,xmm1
		vpshuflw xmm1,xmm0,14
		vcomiss xmm1,xmm0
		jbe finish_1b
		xor rax,rax
finish_1b:
		mov BYTE PTR[rcx],al
		
	vmovdqu xmm7,XMMWORD ptr[rsp+16]
	vmovdqu xmm6,XMMWORD ptr[rsp]
	add rsp,32		
	
	vzeroupper
		
		ret

computeNetwork0_FMA4 endp


;weightedAvgElliottMul5_m16_AVX2 proc ptr_w:dword,n:dword,mstd:dword
; ptr_w = rcx
; n = edx
; mstd = r8

weightedAvgElliottMul5_m16_AVX2 proc public frame

	push rdi
	.pushreg rdi
	sub rsp,32
	.allocstack 32
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog

		mov rax,rcx
		xor rcx,rcx
		mov ecx,edx
		
		mov r9,16
		vmovdqa ymm6,YMMWORD ptr sign_bits_f_32
		vmovdqa ymm7,YMMWORD ptr ones_f_32
	
		lea rdx,[rax+rcx*4]
		xor rdi,rdi
		vxorps ymm0,ymm0,ymm0
		vxorps ymm1,ymm1,ymm1
		
nloop_5:
		vmovaps ymm2,YMMWORD ptr [rax+rdi*4]
		vmovaps ymm4,YMMWORD ptr [rdx+rdi*4]
		vaddps ymm0,ymm0,ymm2
		vandps ymm5,ymm4,ymm6
		vaddps ymm5,ymm5,ymm7
		vrcpps ymm5,ymm5
		vmulps ymm4,ymm4,ymm5
		vmulps ymm4,ymm4,ymm2
		vaddps ymm1,ymm1,ymm4
		
		vmovaps ymm2,YMMWORD ptr [rax+rdi*4+32]
		vmovaps ymm4,YMMWORD ptr [rdx+rdi*4+32]
		vaddps ymm0,ymm0,ymm2
		vandps ymm5,ymm4,ymm6
		vaddps ymm5,ymm5,ymm7
		vrcpps ymm5,ymm5
		vmulps ymm4,ymm4,ymm5
		vmulps ymm4,ymm4,ymm2
		vaddps ymm1,ymm1,ymm4
		add rdi,r9
		sub rcx,r9
		jnz nloop_5
		
		vextractf128 xmm2,ymm0,1
		vextractf128 xmm3,ymm1,1
		vaddps xmm0,xmm0,xmm2
		vaddps xmm1,xmm1,xmm3
		
		vmovhlps xmm2,xmm2,xmm0
		vmovhlps xmm3,xmm3,xmm1
		vaddps xmm0,xmm0,xmm2
		vaddps xmm1,xmm1,xmm3
		vpshuflw xmm2,xmm0,14
		vpshuflw xmm3,xmm1,14
		vaddss xmm0,xmm0,xmm2
		vaddss xmm1,xmm1,xmm3
		vcomiss xmm0,dword ptr min_weight_sum
		jbe nodiv
		vmulss xmm1,xmm1,dword ptr five_f
		vrcpss xmm0,xmm0,xmm0
		vmulss xmm1,xmm1,xmm0
		jmp finish_5
nodiv:
		vxorps xmm1,xmm1,xmm1
finish_5:
		vmulss xmm1,xmm1,dword ptr[r8+4]
		vaddss xmm1,xmm1,dword ptr[r8]
		vaddss xmm1,xmm1,dword ptr[r8+12]
		vmovss dword ptr[r8+12],xmm1
		
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]	
	add rsp,32
		
		pop rdi
		
		ret
		
weightedAvgElliottMul5_m16_AVX2 endp


;weightedAvgElliottMul5_m16_FMA3 proc ptr_w:dword,n:dword,mstd:dword
; ptr_w = rcx
; n = edx
; mstd = r8

weightedAvgElliottMul5_m16_FMA3 proc public frame

	push rdi
	.pushreg rdi
	sub rsp,32
	.allocstack 32
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog

		mov rax,rcx
		xor rcx,rcx
		mov ecx,edx
		
		mov r9,16
		vmovdqa ymm6,YMMWORD ptr sign_bits_f_32
		vmovdqa ymm7,YMMWORD ptr ones_f_32
	
		lea rdx,[rax+rcx*4]
		xor rdi,rdi
		vxorps ymm0,ymm0,ymm0
		vxorps ymm1,ymm1,ymm1
		
nloop_52:
		vmovaps ymm2,YMMWORD ptr [rax+rdi*4]
		vmovaps ymm4,YMMWORD ptr [rdx+rdi*4]
		vaddps ymm0,ymm0,ymm2
		vandps ymm5,ymm4,ymm6
		vaddps ymm5,ymm5,ymm7
		vrcpps ymm5,ymm5
		vmulps ymm4,ymm4,ymm5
		vfmadd231ps ymm1,ymm2,ymm4
		
		vmovaps ymm2,YMMWORD ptr [rax+rdi*4+32]
		vmovaps ymm4,YMMWORD ptr [rdx+rdi*4+32]
		vaddps ymm0,ymm0,ymm2
		vandps ymm5,ymm4,ymm6
		vaddps ymm5,ymm5,ymm7
		vrcpps ymm5,ymm5
		vmulps ymm4,ymm4,ymm5
		vfmadd231ps ymm1,ymm2,ymm4
		
		add rdi,r9
		sub rcx,r9
		jnz nloop_52
		
		vextractf128 xmm2,ymm0,1
		vextractf128 xmm3,ymm1,1
		vaddps xmm0,xmm0,xmm2
		vaddps xmm1,xmm1,xmm3
		
		vmovhlps xmm2,xmm2,xmm0
		vmovhlps xmm3,xmm3,xmm1
		vaddps xmm0,xmm0,xmm2
		vaddps xmm1,xmm1,xmm3
		vpshuflw xmm2,xmm0,14
		vpshuflw xmm3,xmm1,14
		vaddss xmm0,xmm0,xmm2
		vaddss xmm1,xmm1,xmm3
		vcomiss xmm0,dword ptr min_weight_sum
		jbe nodiv2
		vmulss xmm1,xmm1,dword ptr five_f
		vrcpss xmm0,xmm0,xmm0
		vmulss xmm1,xmm1,xmm0
		jmp finish_52
nodiv2:
		vxorps xmm1,xmm1,xmm1
finish_52:
		vmulss xmm1,xmm1,dword ptr[r8+4]
		vaddss xmm1,xmm1,dword ptr[r8]
		vaddss xmm1,xmm1,dword ptr[r8+12]
		vmovss dword ptr[r8+12],xmm1
		
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]	
	add rsp,32
		
		pop rdi
		
		ret
		
weightedAvgElliottMul5_m16_FMA3 endp


;weightedAvgElliottMul5_m16_FMA4 proc ptr_w:dword,n:dword,mstd:dword
; ptr_w = rcx
; n = edx
; mstd = r8

weightedAvgElliottMul5_m16_FMA4 proc public frame

	push rdi
	.pushreg rdi
	sub rsp,32
	.allocstack 32
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog

		mov rax,rcx
		xor rcx,rcx
		mov ecx,edx
		
		mov r9,16
		vmovdqa ymm6,YMMWORD ptr sign_bits_f_32
		vmovdqa ymm7,YMMWORD ptr ones_f_32
	
		lea rdx,[rax+rcx*4]
		xor rdi,rdi
		vxorps ymm0,ymm0,ymm0
		vxorps ymm1,ymm1,ymm1
		
nloop_53:
		vmovaps ymm2,YMMWORD ptr [rax+rdi*4]
		vmovaps ymm4,YMMWORD ptr [rdx+rdi*4]
		vaddps ymm0,ymm0,ymm2
		vandps ymm5,ymm4,ymm6
		vaddps ymm5,ymm5,ymm7
		vrcpps ymm5,ymm5
		vmulps ymm4,ymm4,ymm5
		vfmaddps ymm1,ymm2,ymm4,ymm1
		
		vmovaps ymm2,YMMWORD ptr [rax+rdi*4+32]
		vmovaps ymm4,YMMWORD ptr [rdx+rdi*4+32]
		vaddps ymm0,ymm0,ymm2
		vandps ymm5,ymm4,ymm6
		vaddps ymm5,ymm5,ymm7
		vrcpps ymm5,ymm5
		vmulps ymm4,ymm4,ymm5
		vfmaddps ymm1,ymm2,ymm4,ymm1
		
		add rdi,r9
		sub rcx,r9
		jnz nloop_53
		
		vextractf128 xmm2,ymm0,1
		vextractf128 xmm3,ymm1,1
		vaddps xmm0,xmm0,xmm2
		vaddps xmm1,xmm1,xmm3
		
		vmovhlps xmm2,xmm2,xmm0
		vmovhlps xmm3,xmm3,xmm1
		vaddps xmm0,xmm0,xmm2
		vaddps xmm1,xmm1,xmm3
		vpshuflw xmm2,xmm0,14
		vpshuflw xmm3,xmm1,14
		vaddss xmm0,xmm0,xmm2
		vaddss xmm1,xmm1,xmm3
		vcomiss xmm0,dword ptr min_weight_sum
		jbe nodiv3
		vmulss xmm1,xmm1,dword ptr five_f
		vrcpss xmm0,xmm0,xmm0
		vmulss xmm1,xmm1,xmm0
		jmp finish_53
nodiv3:
		vxorps xmm1,xmm1,xmm1
finish_53:
		vmulss xmm1,xmm1,dword ptr[r8+4]
		vaddss xmm1,xmm1,dword ptr[r8]
		vaddss xmm1,xmm1,dword ptr[r8+12]
		vmovss dword ptr[r8+12],xmm1
		
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]	
	add rsp,32
		
		pop rdi
		
		ret
		
weightedAvgElliottMul5_m16_FMA4 endp


;extract_m8_i16_AVX2 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,inputf:dword
; srcp = rcx
; stride = edx
; xdia = r8d
; ydia = r9d

extract_m8_i16_AVX2 proc public frame

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
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
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
		mov r11,16
		mov r12,32
			
		lea rsi,[rax+rbx*2]
		
		vpxor ymm4,ymm4,ymm4
		vpxor ymm5,ymm5,ymm5
		vpxor ymm6,ymm6,ymm6
		
		cmp edi,8
		jg short suite_0
		
yloop_:
		vmovq xmm2,QWORD PTR[rax]
		vmovq xmm3,QWORD PTR[rsi]
		vpunpcklbw xmm0,xmm2,xmm6
		vpunpcklbw xmm1,xmm3,xmm6
		vpsadbw xmm2,xmm2,xmm6
		vpsadbw xmm3,xmm3,xmm6
		vmovdqa XMMWORD ptr [rdx],xmm0
		vmovdqa XMMWORD ptr [rdx+rdi*2],xmm1
		vpmaddwd xmm0,xmm0,xmm0
		vpmaddwd xmm1,xmm1,xmm1
		vpaddd xmm4,xmm4,xmm2
		vpaddd xmm5,xmm5,xmm0
		vpaddd xmm4,xmm4,xmm3
		vpaddd xmm5,xmm5,xmm1
		add rdx,r11
		lea rax,[rax+rbx*4]
		lea rsi,[rsi+rbx*4]
		lea rdx,[rdx+rdi*2]
		sub r8d,r10d
		jnz short yloop_
		jmp suite0
		
suite_0:		
		test rax,15
		jnz yloop__
		
yloop:
		xor rcx,rcx			
xloop_2:
		vmovdqa xmm2,XMMWORD PTR[rax+rcx]
		vmovdqa xmm3,XMMWORD PTR[rsi+rcx]
		vmovhlps xmm0,xmm6,xmm2
		vmovhlps xmm1,xmm6,xmm3
		vinserti128 ymm2,ymm2,xmm0,1
		vinserti128 ymm3,ymm3,xmm1,1		
		vpunpcklbw ymm0,ymm2,ymm6
		vpunpcklbw ymm1,ymm3,ymm6
		vpsadbw xmm2,xmm2,xmm6
		vpsadbw xmm3,xmm3,xmm6
		vmovdqa YMMWORD PTR[rdx],ymm0
		vmovdqa YMMWORD PTR[rdx+rdi*2],ymm1
		vpmaddwd ymm0,ymm0,ymm0
		vpmaddwd ymm1,ymm1,ymm1
		vpaddd xmm4,xmm4,xmm2
		vpaddd ymm5,ymm5,ymm0
		vpaddd xmm4,xmm4,xmm3
		vpaddd ymm5,ymm5,ymm1
		add rcx,r11
		add rdx,r12
		cmp rcx,rdi
		jl short xloop_2
		lea rax,[rax+rbx*4]
		lea rsi,[rsi+rbx*4]
		lea rdx,[rdx+rdi*2]
		sub r8d,r10d
		jnz short yloop
		
		vmovhlps xmm1,xmm1,xmm4
		vextracti128 xmm2,ymm5,1
		vpaddd xmm4,xmm4,xmm1
		vpaddd xmm5,xmm5,xmm2
		
		jmp suite0
		
yloop__:
		xor rcx,rcx			
xloop_2_:
		vmovdqu xmm2,XMMWORD PTR[rax+rcx]
		vmovdqu xmm3,XMMWORD PTR[rsi+rcx]
		vmovhlps xmm0,xmm6,xmm2
		vmovhlps xmm1,xmm6,xmm3
		vinserti128 ymm2,ymm2,xmm0,1
		vinserti128 ymm3,ymm3,xmm1,1				
		vpunpcklbw ymm0,ymm2,ymm6
		vpunpcklbw ymm1,ymm3,ymm6
		vpsadbw xmm2,xmm2,xmm6
		vpsadbw xmm3,xmm3,xmm6
		vmovdqa YMMWORD PTR[rdx],ymm0
		vmovdqa YMMWORD PTR[rdx+rdi*2],ymm1
		vpmaddwd ymm0,ymm0,ymm0
		vpmaddwd ymm1,ymm1,ymm1
		vpaddd xmm4,xmm4,xmm2
		vpaddd ymm5,ymm5,ymm0
		vpaddd xmm4,xmm4,xmm3
		vpaddd ymm5,ymm5,ymm1
		add rcx,r11
		add rdx,r12
		cmp rcx,rdi
		jl short xloop_2_
		lea rax,[rax+rbx*4]
		lea rsi,[rsi+rbx*4]
		lea rdx,[rdx+rdi*2]
		sub r8d,r10d
		jnz short yloop__
		
		vmovhlps xmm1,xmm1,xmm4
		vextracti128 xmm2,ymm5,1
		vpaddd xmm4,xmm4,xmm1
		vpaddd xmm5,xmm5,xmm2
		
suite0:				
		vmovhlps xmm1,xmm1,xmm5
		mov eax,r9d
		vpaddd xmm5,xmm5,xmm1
		mul edi
		vpshuflw xmm1,xmm5,14
		vcvtsi2ss xmm7,xmm7,eax
		vpaddd xmm5,xmm5,xmm1
		vrcpss xmm7,xmm7,xmm7
		vcvtdq2ps xmm4,xmm4
		vcvtdq2ps xmm5,xmm5
		mov rax,mstd
		vmulss xmm4,xmm4,xmm7
		vmulss xmm5,xmm5,xmm7
		vmovss dword ptr[rax],xmm4
		vmulss xmm4,xmm4,xmm4
		vsubss xmm5,xmm5,xmm4
		vcomiss xmm5,dword ptr flt_epsilon_sse
		jbe short novarjmp_2
		vrsqrtss xmm5,xmm5,xmm5
		vrcpss xmm4,xmm4,xmm5
		vmovss dword ptr[rax+4],xmm4
		vmovss dword ptr[rax+8],xmm5
		jmp short finish_4
novarjmp_2:
		vmovss dword ptr[rax+4],xmm6
		vmovss dword ptr[rax+8],xmm6
finish_4:
		vmovss dword ptr[rax+12],xmm6
				
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]	
	add rsp,32	
		
	vzeroupper
	
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp
		
		ret
		
extract_m8_i16_AVX2 endp


;extract_m8_AVX2 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,input:dword
; srcp = rcx
; stride = edx
; xdia = r8d
; ydia = r9d

extract_m8_AVX2 proc public frame
	
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
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
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
		
		vpxor ymm5,ymm5,ymm5
		vpxor ymm6,ymm6,ymm6
		vpxor ymm4,ymm4,ymm4
				
yloop2:
		xor rcx,rcx
xloop2:				
		vmovq xmm0,QWORD PTR[rax+rcx]
		vmovq xmm2,QWORD PTR[rdx+rcx]
		vpunpcklbw xmm0,xmm0,xmm4
		vpunpcklbw xmm2,xmm2,xmm4
		vmovhlps xmm1,xmm4,xmm0
		vmovhlps xmm3,xmm4,xmm2
		vinserti128 ymm0,ymm0,xmm1,1
		vinserti128 ymm2,ymm2,xmm3,1
		vpunpcklwd ymm0,ymm0,ymm4
		vpunpcklwd ymm2,ymm2,ymm4
		vcvtdq2ps ymm0,ymm0
		vcvtdq2ps ymm2,ymm2
		vmovaps YMMWORD PTR[rsi],ymm0
		vmovaps YMMWORD PTR[rsi+rdi*4],ymm2
		vaddps ymm5,ymm5,ymm0
		vaddps ymm5,ymm5,ymm2
		vmulps ymm0,ymm0,ymm0
		vmulps ymm2,ymm2,ymm2
		vaddps ymm6,ymm6,ymm0
		vaddps ymm6,ymm6,ymm2
		add rcx,r11
		add rsi,r12
		cmp rcx,rdi
		jl short xloop2
		lea rax,[rax+rbx*4]
		lea rdx,[rdx+rbx*4]
		lea rsi,[rsi+rdi*4]
		sub r8d,r10d
		jnz short yloop2
		
		vextractf128 xmm0,ymm5,1
		vextractf128 xmm2,ymm6,1
		vaddps xmm5,xmm5,xmm0
		vaddps xmm6,xmm6,xmm2
		
		mov eax,r9d		
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
		mov rax,mstd
		vmulss xmm5,xmm5,xmm7
		vmulss xmm6,xmm6,xmm7
		vmovss dword ptr[rax],xmm5
		vmulss xmm5,xmm5,xmm5
		vsubss xmm6,xmm6,xmm5
		vcomiss xmm6,dword ptr flt_epsilon_sse
		jbe short novarjmp
		vrsqrtss xmm6,xmm6,xmm6
		vrcpss xmm5,xmm5,xmm6
		vmovss dword ptr[rax+4],xmm5
		vmovss dword ptr[rax+8],xmm6
		jmp short finish_3
novarjmp:
		vmovss dword ptr[rax+4],xmm4
		vmovss dword ptr[rax+8],xmm4
finish_3:
		vmovss dword ptr[rax+12],xmm4
				
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]	
	add rsp,32	
		
	vzeroupper
		
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp
		
		ret
		
extract_m8_AVX2 endp


;extract_m8_FMA3 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,input:dword
; srcp = rcx
; stride = edx
; xdia = r8d
; ydia = r9d

extract_m8_FMA3 proc public frame
	
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
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
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
		
		vpxor ymm5,ymm5,ymm5
		vpxor ymm6,ymm6,ymm6
		vpxor ymm4,ymm4,ymm4
				
yloop2a:
		xor rcx,rcx
xloop2a:				
		vmovq xmm0,QWORD PTR[rax+rcx]
		vmovq xmm2,QWORD PTR[rdx+rcx]
		vpunpcklbw xmm0,xmm0,xmm4
		vpunpcklbw xmm2,xmm2,xmm4
		vmovhlps xmm1,xmm4,xmm0
		vmovhlps xmm3,xmm4,xmm2
		vinserti128 ymm0,ymm0,xmm1,1
		vinserti128 ymm2,ymm2,xmm3,1		
		vpunpcklwd ymm0,ymm0,ymm4
		vpunpcklwd ymm2,ymm2,ymm4
		vcvtdq2ps ymm0,ymm0
		vcvtdq2ps ymm2,ymm2
		vmovaps YMMWORD PTR[rsi],ymm0
		vmovaps YMMWORD PTR[rsi+rdi*4],ymm2
		vaddps ymm5,ymm5,ymm0
		vaddps ymm5,ymm5,ymm2
		vfmadd231ps ymm6,ymm0,ymm0
		vfmadd231ps ymm6,ymm2,ymm2
		add rcx,r11
		add rsi,r12
		cmp rcx,rdi
		jl short xloop2a
		lea rax,[rax+rbx*4]
		lea rdx,[rdx+rbx*4]
		lea rsi,[rsi+rdi*4]
		sub r8d,r10d
		jnz short yloop2a
		
		vextractf128 xmm0,ymm5,1
		vextractf128 xmm2,ymm6,1
		vaddps xmm5,xmm5,xmm0
		vaddps xmm6,xmm6,xmm2
		
		mov eax,r9d		
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
		mov rax,mstd
		vmulss xmm5,xmm5,xmm7
		vmulss xmm6,xmm6,xmm7
		vmovss dword ptr[rax],xmm5
		vmulss xmm5,xmm5,xmm5
		vsubss xmm6,xmm6,xmm5
		vcomiss xmm6,dword ptr flt_epsilon_sse
		jbe short novarjmpa
		vrsqrtss xmm6,xmm6,xmm6
		vrcpss xmm5,xmm5,xmm6
		vmovss dword ptr[rax+4],xmm5
		vmovss dword ptr[rax+8],xmm6
		jmp short finish_3a
novarjmpa:
		vmovss dword ptr[rax+4],xmm4
		vmovss dword ptr[rax+8],xmm4
finish_3a:
		vmovss dword ptr[rax+12],xmm4
				
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]	
	add rsp,32	
		
	vzeroupper
		
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp
		
		ret
		
extract_m8_FMA3 endp


;extract_m8_FMA4 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,input:dword
; srcp = rcx
; stride = edx
; xdia = r8d
; ydia = r9d

extract_m8_FMA4 proc public frame
	
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
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
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
		
		vpxor ymm5,ymm5,ymm5
		vpxor ymm6,ymm6,ymm6
		vpxor ymm4,ymm4,ymm4
				
yloop2b:
		xor rcx,rcx
xloop2b:				
		vmovq xmm0,QWORD PTR[rax+rcx]
		vmovq xmm2,QWORD PTR[rdx+rcx]
		vpunpcklbw xmm0,xmm0,xmm4
		vpunpcklbw xmm2,xmm2,xmm4
		vmovhlps xmm1,xmm4,xmm0
		vmovhlps xmm3,xmm4,xmm2
		vinserti128 ymm0,ymm0,xmm1,1
		vinserti128 ymm2,ymm2,xmm3,1		
		vpunpcklwd ymm0,ymm0,ymm4
		vpunpcklwd ymm2,ymm2,ymm4
		vcvtdq2ps ymm0,ymm0
		vcvtdq2ps ymm2,ymm2
		vmovaps YMMWORD PTR[rsi],ymm0
		vmovaps YMMWORD PTR[rsi+rdi*4],ymm2
		vaddps ymm5,ymm5,ymm0
		vaddps ymm5,ymm5,ymm2
		vfmaddps ymm6,ymm0,ymm0,ymm6
		vfmaddps ymm6,ymm2,ymm2,ymm6
		add rcx,r11
		add rsi,r12
		cmp rcx,rdi
		jl short xloop2b
		lea rax,[rax+rbx*4]
		lea rdx,[rdx+rbx*4]
		lea rsi,[rsi+rdi*4]
		sub r8d,r10d
		jnz short yloop2b
		
		vextractf128 xmm0,ymm5,1
		vextractf128 xmm2,ymm6,1
		vaddps xmm5,xmm5,xmm0
		vaddps xmm6,xmm6,xmm2
		
		mov eax,r9d		
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
		mov rax,mstd
		vmulss xmm5,xmm5,xmm7
		vmulss xmm6,xmm6,xmm7
		vmovss dword ptr[rax],xmm5
		vmulss xmm5,xmm5,xmm5
		vsubss xmm6,xmm6,xmm5
		vcomiss xmm6,dword ptr flt_epsilon_sse
		jbe short novarjmpb
		vrsqrtss xmm6,xmm6,xmm6
		vrcpss xmm5,xmm5,xmm6
		vmovss dword ptr[rax+4],xmm5
		vmovss dword ptr[rax+8],xmm6
		jmp short finish_3b
novarjmpb:
		vmovss dword ptr[rax+4],xmm4
		vmovss dword ptr[rax+8],xmm4
finish_3b:
		vmovss dword ptr[rax+12],xmm4
				
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]	
	add rsp,32	
		
	vzeroupper
		
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp
		
		ret
		
extract_m8_FMA4 endp


;extract_m8_AVX2_16 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,input:dword
; srcp = rcx
; stride = edx
; xdia = r8d
; ydia = r9d

extract_m8_AVX2_16 proc public frame
	
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
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
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
		
		vpxor ymm5,ymm5,ymm5
		vpxor ymm6,ymm6,ymm6
		vpxor ymm4,ymm4,ymm4
		
		test rax,15
		jnz short yloop2_16_		
		
yloop2_16:
		xor rcx,rcx
xloop2_16:
		vmovdqa xmm0,XMMWORD PTR[rax+2*rcx]
		vmovdqa xmm2,XMMWORD PTR[rdx+2*rcx]
		vmovhlps xmm1,xmm4,xmm0
		vmovhlps xmm3,xmm4,xmm2
		vinserti128 ymm0,ymm0,xmm1,1
		vinserti128 ymm2,ymm2,xmm3,1		
		vpunpcklwd ymm0,ymm0,ymm4
		vpunpcklwd ymm2,ymm2,ymm4
		vcvtdq2ps ymm0,ymm0
		vcvtdq2ps ymm2,ymm2
		vmovaps YMMWORD PTR[rsi],ymm0
		vmovaps YMMWORD PTR[rsi+rdi*4],ymm2
		vaddps ymm5,ymm5,ymm0
		vaddps ymm5,ymm5,ymm2
		vmulps ymm0,ymm0,ymm0
		vmulps ymm2,ymm2,ymm2
		vaddps ymm6,ymm6,ymm0
		vaddps ymm6,ymm6,ymm2
		add rcx,r11
		add rsi,r12
		cmp rcx,rdi
		jl short xloop2_16
		lea rax,[rax+rbx*4]
		lea rdx,[rdx+rbx*4]
		lea rsi,[rsi+rdi*4]
		sub r8d,r10d
		jnz short yloop2_16
		jmp short suite1
		
yloop2_16_:
		xor rcx,rcx
xloop2_16_:
		vmovdqu xmm0,XMMWORD PTR[rax+2*rcx]
		vmovdqu xmm2,XMMWORD PTR[rdx+2*rcx]
		vmovhlps xmm1,xmm4,xmm0
		vmovhlps xmm3,xmm4,xmm2
		vinserti128 ymm0,ymm0,xmm1,1
		vinserti128 ymm2,ymm2,xmm3,1				
		vpunpcklwd ymm0,ymm0,ymm4
		vpunpcklwd ymm2,ymm2,ymm4
		vcvtdq2ps ymm0,ymm0
		vcvtdq2ps ymm2,ymm2
		vmovaps YMMWORD PTR[rsi],ymm0
		vmovaps YMMWORD PTR[rsi+rdi*4],ymm2
		vaddps ymm5,ymm5,ymm0
		vaddps ymm5,ymm5,ymm2
		vmulps ymm0,ymm0,ymm0
		vmulps ymm2,ymm2,ymm2
		vaddps ymm6,ymm6,ymm0
		vaddps ymm6,ymm6,ymm2
		add rcx,r11
		add rsi,r12
		cmp rcx,rdi
		jl short xloop2_16_
		lea rax,[rax+rbx*4]
		lea rdx,[rdx+rbx*4]
		lea rsi,[rsi+rdi*4]
		sub r8d,r10d
		jnz short yloop2_16_		
		
suite1:		
		vextractf128 xmm0,ymm5,1
		vextractf128 xmm2,ymm6,1
		vaddps xmm5,xmm5,xmm0
		vaddps xmm6,xmm6,xmm2

		mov eax,r9d		
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
		mov rax,mstd
		vmulss xmm5,xmm5,xmm7
		vmulss xmm6,xmm6,xmm7
		vmovss dword ptr[rax],xmm5
		vmulss xmm5,xmm5,xmm5
		vsubss xmm6,xmm6,xmm5
		vcomiss xmm6,dword ptr flt_epsilon_sse
		jbe short novarjmp_16
		vrsqrtss xmm6,xmm6,xmm6
		vrcpss xmm5,xmm5,xmm6
		vmovss dword ptr[rax+4],xmm5
		vmovss dword ptr[rax+8],xmm6
		jmp short finish_3_16
novarjmp_16:
		vmovss dword ptr[rax+4],xmm4
		vmovss dword ptr[rax+8],xmm4
finish_3_16:
		vmovss dword ptr[rax+12],xmm4
				
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]	
	add rsp,32	
	
	vzeroupper
		
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp
		
		ret
		
extract_m8_AVX2_16 endp


;extract_m8_FMA3_16 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,input:dword
; srcp = rcx
; stride = edx
; xdia = r8d
; ydia = r9d

extract_m8_FMA3_16 proc public frame
	
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
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
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
		
		vpxor ymm5,ymm5,ymm5
		vpxor ymm6,ymm6,ymm6
		vpxor ymm4,ymm4,ymm4
		
		test rax,15
		jnz short yloop2_16a_		
		
yloop2_16a:
		xor rcx,rcx
xloop2_16a:
		vmovdqa xmm0,XMMWORD PTR[rax+2*rcx]
		vmovdqa xmm2,XMMWORD PTR[rdx+2*rcx]
		vmovhlps xmm1,xmm4,xmm0
		vmovhlps xmm3,xmm4,xmm2
		vinserti128 ymm0,ymm0,xmm1,1
		vinserti128 ymm2,ymm2,xmm3,1				
		vpunpcklwd ymm0,ymm0,ymm4
		vpunpcklwd ymm2,ymm2,ymm4
		vcvtdq2ps ymm0,ymm0
		vcvtdq2ps ymm2,ymm2
		vmovaps YMMWORD PTR[rsi],ymm0
		vmovaps YMMWORD PTR[rsi+rdi*4],ymm2
		vaddps ymm5,ymm5,ymm0
		vaddps ymm5,ymm5,ymm2
		vfmadd231ps ymm6,ymm0,ymm0
		vfmadd231ps ymm6,ymm2,ymm2
		add rcx,r11
		add rsi,r12
		cmp rcx,rdi
		jl short xloop2_16a
		lea rax,[rax+rbx*4]
		lea rdx,[rdx+rbx*4]
		lea rsi,[rsi+rdi*4]
		sub r8d,r10d
		jnz short yloop2_16a
		jmp short suite1a
		
yloop2_16a_:
		xor rcx,rcx
xloop2_16a_:
		vmovdqu xmm0,XMMWORD PTR[rax+2*rcx]
		vmovdqu xmm2,XMMWORD PTR[rdx+2*rcx]
		vmovhlps xmm1,xmm4,xmm0
		vmovhlps xmm3,xmm4,xmm2
		vinserti128 ymm0,ymm0,xmm1,1
		vinserti128 ymm2,ymm2,xmm3,1				
		vpunpcklwd ymm0,ymm0,ymm4
		vpunpcklwd ymm2,ymm2,ymm4
		vcvtdq2ps ymm0,ymm0
		vcvtdq2ps ymm2,ymm2
		vmovaps YMMWORD PTR[rsi],ymm0
		vmovaps YMMWORD PTR[rsi+rdi*4],ymm2
		vaddps ymm5,ymm5,ymm0
		vaddps ymm5,ymm5,ymm2
		vfmadd231ps ymm6,ymm0,ymm0
		vfmadd231ps ymm6,ymm2,ymm2
		add rcx,r11
		add rsi,r12
		cmp rcx,rdi
		jl short xloop2_16a_
		lea rax,[rax+rbx*4]
		lea rdx,[rdx+rbx*4]
		lea rsi,[rsi+rdi*4]
		sub r8d,r10d
		jnz short yloop2_16a_		
		
suite1a:		
		vextractf128 xmm0,ymm5,1
		vextractf128 xmm2,ymm6,1
		vaddps xmm5,xmm5,xmm0
		vaddps xmm6,xmm6,xmm2

		mov eax,r9d		
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
		mov rax,mstd
		vmulss xmm5,xmm5,xmm7
		vmulss xmm6,xmm6,xmm7
		vmovss dword ptr[rax],xmm5
		vmulss xmm5,xmm5,xmm5
		vsubss xmm6,xmm6,xmm5
		vcomiss xmm6,dword ptr flt_epsilon_sse
		jbe short novarjmp_16a
		vrsqrtss xmm6,xmm6,xmm6
		vrcpss xmm5,xmm5,xmm6
		vmovss dword ptr[rax+4],xmm5
		vmovss dword ptr[rax+8],xmm6
		jmp short finish_3_16a
novarjmp_16a:
		vmovss dword ptr[rax+4],xmm4
		vmovss dword ptr[rax+8],xmm4
finish_3_16a:
		vmovss dword ptr[rax+12],xmm4
				
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]	
	add rsp,32	
	
	vzeroupper
		
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp
		
		ret
		
extract_m8_FMA3_16 endp


;extract_m8_FMA4_16 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,input:dword
; srcp = rcx
; stride = edx
; xdia = r8d
; ydia = r9d

extract_m8_FMA4_16 proc public frame
	
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
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
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
		
		vpxor ymm5,ymm5,ymm5
		vpxor ymm6,ymm6,ymm6
		vpxor ymm4,ymm4,ymm4
		
		test rax,15
		jnz short yloop2_16b_		
		
yloop2_16b:
		xor rcx,rcx
xloop2_16b:
		vmovdqa xmm0,XMMWORD PTR[rax+2*rcx]
		vmovdqa xmm2,XMMWORD PTR[rdx+2*rcx]
		vmovhlps xmm1,xmm4,xmm0
		vmovhlps xmm3,xmm4,xmm2
		vinserti128 ymm0,ymm0,xmm1,1
		vinserti128 ymm2,ymm2,xmm3,1				
		vpunpcklwd ymm0,ymm0,ymm4
		vpunpcklwd ymm2,ymm2,ymm4
		vcvtdq2ps ymm0,ymm0
		vcvtdq2ps ymm2,ymm2
		vmovaps YMMWORD PTR[rsi],ymm0
		vmovaps YMMWORD PTR[rsi+rdi*4],ymm2
		vaddps ymm5,ymm5,ymm0
		vaddps ymm5,ymm5,ymm2
		vfmaddps ymm6,ymm0,ymm0,ymm6
		vfmaddps ymm6,ymm2,ymm2,ymm6
		add rcx,r11
		add rsi,r12
		cmp rcx,rdi
		jl short xloop2_16b
		lea rax,[rax+rbx*4]
		lea rdx,[rdx+rbx*4]
		lea rsi,[rsi+rdi*4]
		sub r8d,r10d
		jnz short yloop2_16b
		jmp short suite1b
		
yloop2_16b_:
		xor rcx,rcx
xloop2_16b_:
		vmovdqu xmm0,XMMWORD PTR[rax+2*rcx]
		vmovdqu xmm2,XMMWORD PTR[rdx+2*rcx]
		vmovhlps xmm1,xmm4,xmm0
		vmovhlps xmm3,xmm4,xmm2
		vinserti128 ymm0,ymm0,xmm1,1
		vinserti128 ymm2,ymm2,xmm3,1				
		vpunpcklwd ymm0,ymm0,ymm4
		vpunpcklwd ymm2,ymm2,ymm4
		vcvtdq2ps ymm0,ymm0
		vcvtdq2ps ymm2,ymm2
		vmovaps YMMWORD PTR[rsi],ymm0
		vmovaps YMMWORD PTR[rsi+rdi*4],ymm2
		vaddps ymm5,ymm5,ymm0
		vaddps ymm5,ymm5,ymm2
		vfmaddps ymm6,ymm0,ymm0,ymm6
		vfmaddps ymm6,ymm2,ymm2,ymm6
		add rcx,r11
		add rsi,r12
		cmp rcx,rdi
		jl short xloop2_16b_
		lea rax,[rax+rbx*4]
		lea rdx,[rdx+rbx*4]
		lea rsi,[rsi+rdi*4]
		sub r8d,r10d
		jnz short yloop2_16b_		
		
suite1b:		
		vextractf128 xmm0,ymm5,1
		vextractf128 xmm2,ymm6,1
		vaddps xmm5,xmm5,xmm0
		vaddps xmm6,xmm6,xmm2

		mov eax,r9d		
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
		mov rax,mstd
		vmulss xmm5,xmm5,xmm7
		vmulss xmm6,xmm6,xmm7
		vmovss dword ptr[rax],xmm5
		vmulss xmm5,xmm5,xmm5
		vsubss xmm6,xmm6,xmm5
		vcomiss xmm6,dword ptr flt_epsilon_sse
		jbe short novarjmp_16b
		vrsqrtss xmm6,xmm6,xmm6
		vrcpss xmm5,xmm5,xmm6
		vmovss dword ptr[rax+4],xmm5
		vmovss dword ptr[rax+8],xmm6
		jmp short finish_3_16b
novarjmp_16b:
		vmovss dword ptr[rax+4],xmm4
		vmovss dword ptr[rax+8],xmm4
finish_3_16b:
		vmovss dword ptr[rax+12],xmm4
				
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]	
	add rsp,32	
	
	vzeroupper
		
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp
		
		ret
		
extract_m8_FMA4_16 endp


;extract_m8_AVX2_32 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,input:dword
; srcp = rcx
; stride = edx
; xdia = r8d
; ydia = r9d

extract_m8_AVX2_32 proc public frame
	
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
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
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
		vpxor ymm5,ymm5,ymm5
		vpxor ymm6,ymm6,ymm6
		vpxor ymm3,ymm3,ymm3
		
		test rax,31
		jnz short yloop2_32_				
		
yloop2_32:
		xor rcx,rcx
xloop2_32:
		vmovaps ymm0,YMMWORD PTR[rax+4*rcx]
		vmovaps ymm2,YMMWORD PTR[rdx+4*rcx]		
		vmovaps YMMWORD PTR[rsi],ymm0
		vmovaps YMMWORD PTR[rsi+rdi*4],ymm2
		vaddps ymm5,ymm5,ymm0
		vaddps ymm5,ymm5,ymm2
		vmulps ymm0,ymm0,ymm0
		vmulps ymm2,ymm2,ymm2
		vaddps ymm6,ymm6,ymm0
		vaddps ymm6,ymm6,ymm2
		add rcx,r11
		add rsi,r12
		cmp rcx,rdi
		jl short xloop2_32
		lea rax,[rax+rbx*4]
		lea rdx,[rdx+rbx*4]
		lea rsi,[rsi+rdi*4]
		sub r8d,r10d
		jnz short yloop2_32
		jmp short suite2
		
yloop2_32_:
		xor rcx,rcx
xloop2_32_:
		vmovups ymm0,YMMWORD PTR[rax+4*rcx]
		vmovups ymm2,YMMWORD PTR[rdx+4*rcx]		
		vmovaps YMMWORD PTR[rsi],ymm0
		vmovaps YMMWORD PTR[rsi+rdi*4],ymm2
		vaddps ymm5,ymm5,ymm0
		vaddps ymm5,ymm5,ymm2
		vmulps ymm0,ymm0,ymm0
		vmulps ymm2,ymm2,ymm2
		vaddps ymm6,ymm6,ymm0
		vaddps ymm6,ymm6,ymm2
		add rcx,r11
		add rsi,r12
		cmp rcx,rdi
		jl short xloop2_32_
		lea rax,[rax+rbx*4]
		lea rdx,[rdx+rbx*4]
		lea rsi,[rsi+rdi*4]
		sub r8d,r10d
		jnz short yloop2_32_
		
suite2:		
		vextractf128 xmm0,ymm5,1
		vextractf128 xmm2,ymm6,1
		vaddps xmm5,xmm5,xmm0
		vaddps xmm6,xmm6,xmm2

		mov eax,r9d		
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
		mov rax,mstd
		vmulss xmm5,xmm5,xmm7
		vmulss xmm6,xmm6,xmm7
		vmovss dword ptr[rax],xmm5
		vmulss xmm5,xmm5,xmm5
		vsubss xmm6,xmm6,xmm5
		vcomiss xmm6,dword ptr flt_epsilon_sse
		jbe short novarjmp_32
		vrsqrtss xmm6,xmm6,xmm6
		vrcpss xmm5,xmm5,xmm6
		vmovss dword ptr[rax+4],xmm5
		vmovss dword ptr[rax+8],xmm6
		jmp short finish_3_32
novarjmp_32:
		vmovss dword ptr[rax+4],xmm3
		vmovss dword ptr[rax+8],xmm3
finish_3_32:
		vmovss dword ptr[rax+12],xmm3
		
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]	
	add rsp,32
	
	vzeroupper
		
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp
		
		ret
		
extract_m8_AVX2_32 endp


;extract_m8_FMA3_32 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,input:dword
; srcp = rcx
; stride = edx
; xdia = r8d
; ydia = r9d

extract_m8_FMA3_32 proc public frame
	
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
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
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
		vpxor ymm5,ymm5,ymm5
		vpxor ymm6,ymm6,ymm6
		vpxor ymm3,ymm3,ymm3
		
		test rax,31
		jnz short yloop2_32a_				
		
yloop2_32a:
		xor rcx,rcx
xloop2_32a:
		vmovaps ymm0,YMMWORD PTR[rax+4*rcx]
		vmovaps ymm2,YMMWORD PTR[rdx+4*rcx]		
		vmovaps YMMWORD PTR[rsi],ymm0
		vmovaps YMMWORD PTR[rsi+rdi*4],ymm2
		vaddps ymm5,ymm5,ymm0
		vaddps ymm5,ymm5,ymm2
		vfmadd231ps ymm6,ymm0,ymm0
		vfmadd231ps ymm6,ymm2,ymm2
		add rcx,r11
		add rsi,r12
		cmp rcx,rdi
		jl short xloop2_32a
		lea rax,[rax+rbx*4]
		lea rdx,[rdx+rbx*4]
		lea rsi,[rsi+rdi*4]
		sub r8d,r10d
		jnz short yloop2_32a
		jmp short suite2a
		
yloop2_32a_:
		xor rcx,rcx
xloop2_32a_:
		vmovups ymm0,YMMWORD PTR[rax+4*rcx]
		vmovups ymm2,YMMWORD PTR[rdx+4*rcx]		
		vmovaps YMMWORD PTR[rsi],ymm0
		vmovaps YMMWORD PTR[rsi+rdi*4],ymm2
		vaddps ymm5,ymm5,ymm0
		vaddps ymm5,ymm5,ymm2
		vfmadd231ps ymm6,ymm0,ymm0
		vfmadd231ps ymm6,ymm2,ymm2
		add rcx,r11
		add rsi,r12
		cmp rcx,rdi
		jl short xloop2_32a_
		lea rax,[rax+rbx*4]
		lea rdx,[rdx+rbx*4]
		lea rsi,[rsi+rdi*4]
		sub r8d,r10d
		jnz short yloop2_32a_
		
suite2a:		
		vextractf128 xmm0,ymm5,1
		vextractf128 xmm2,ymm6,1
		vaddps xmm5,xmm5,xmm0
		vaddps xmm6,xmm6,xmm2

		mov eax,r9d		
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
		mov rax,mstd
		vmulss xmm5,xmm5,xmm7
		vmulss xmm6,xmm6,xmm7
		vmovss dword ptr[rax],xmm5
		vmulss xmm5,xmm5,xmm5
		vsubss xmm6,xmm6,xmm5
		vcomiss xmm6,dword ptr flt_epsilon_sse
		jbe short novarjmp_32a
		vrsqrtss xmm6,xmm6,xmm6
		vrcpss xmm5,xmm5,xmm6
		vmovss dword ptr[rax+4],xmm5
		vmovss dword ptr[rax+8],xmm6
		jmp short finish_3_32a
novarjmp_32a:
		vmovss dword ptr[rax+4],xmm3
		vmovss dword ptr[rax+8],xmm3
finish_3_32a:
		vmovss dword ptr[rax+12],xmm3
		
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]	
	add rsp,32
	
	vzeroupper
		
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp
		
		ret
		
extract_m8_FMA3_32 endp


;extract_m8_FMA4_32 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,input:dword
; srcp = rcx
; stride = edx
; xdia = r8d
; ydia = r9d

extract_m8_FMA4_32 proc public frame
	
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
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
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
		vpxor ymm5,ymm5,ymm5
		vpxor ymm6,ymm6,ymm6
		vpxor ymm3,ymm3,ymm3
		
		test rax,31
		jnz short yloop2_32b_				
		
yloop2_32b:
		xor rcx,rcx
xloop2_32b:
		vmovaps ymm0,YMMWORD PTR[rax+4*rcx]
		vmovaps ymm2,YMMWORD PTR[rdx+4*rcx]		
		vmovaps YMMWORD PTR[rsi],ymm0
		vmovaps YMMWORD PTR[rsi+rdi*4],ymm2
		vaddps ymm5,ymm5,ymm0
		vaddps ymm5,ymm5,ymm2
		vfmaddps ymm6,ymm0,ymm0,ymm6
		vfmaddps ymm6,ymm2,ymm2,ymm6
		add rcx,r11
		add rsi,r12
		cmp rcx,rdi
		jl short xloop2_32b
		lea rax,[rax+rbx*4]
		lea rdx,[rdx+rbx*4]
		lea rsi,[rsi+rdi*4]
		sub r8d,r10d
		jnz short yloop2_32b
		jmp short suite2b
		
yloop2_32b_:
		xor rcx,rcx
xloop2_32b_:
		vmovups ymm0,YMMWORD PTR[rax+4*rcx]
		vmovups ymm2,YMMWORD PTR[rdx+4*rcx]		
		vmovaps YMMWORD PTR[rsi],ymm0
		vmovaps YMMWORD PTR[rsi+rdi*4],ymm2
		vaddps ymm5,ymm5,ymm0
		vaddps ymm5,ymm5,ymm2
		vfmaddps ymm6,ymm0,ymm0,ymm6
		vfmaddps ymm6,ymm2,ymm2,ymm6
		add rcx,r11
		add rsi,r12
		cmp rcx,rdi
		jl short xloop2_32b_
		lea rax,[rax+rbx*4]
		lea rdx,[rdx+rbx*4]
		lea rsi,[rsi+rdi*4]
		sub r8d,r10d
		jnz short yloop2_32b_
		
suite2b:		
		vextractf128 xmm0,ymm5,1
		vextractf128 xmm2,ymm6,1
		vaddps xmm5,xmm5,xmm0
		vaddps xmm6,xmm6,xmm2

		mov eax,r9d		
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
		mov rax,mstd
		vmulss xmm5,xmm5,xmm7
		vmulss xmm6,xmm6,xmm7
		vmovss dword ptr[rax],xmm5
		vmulss xmm5,xmm5,xmm5
		vsubss xmm6,xmm6,xmm5
		vcomiss xmm6,dword ptr flt_epsilon_sse
		jbe short novarjmp_32b
		vrsqrtss xmm6,xmm6,xmm6
		vrcpss xmm5,xmm5,xmm6
		vmovss dword ptr[rax+4],xmm5
		vmovss dword ptr[rax+8],xmm6
		jmp short finish_3_32b
novarjmp_32b:
		vmovss dword ptr[rax+4],xmm3
		vmovss dword ptr[rax+8],xmm3
finish_3_32b:
		vmovss dword ptr[rax+12],xmm3
		
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]	
	add rsp,32
	
	vzeroupper
		
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp
		
		ret
		
extract_m8_FMA4_32 endp


;extract_m8_i16_AVX2_16 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,inputf:dword
; srcp = rcx
; stride = edx
; xdia = r8d
; ydia = r9d

extract_m8_i16_AVX2_16 proc public frame

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
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	vmovdqa XMMWORD ptr[rsp+32],xmm8
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
		mov r11,16
		mov r12,32		
			
		lea rsi,[rax+rbx*2]
		vpxor ymm4,ymm4,ymm4
		vpxor ymm5,ymm5,ymm5
		vpxor ymm6,ymm6,ymm6
		vmovdqa ymm8,YMMWORD ptr uw_1
		
		cmp edi,8
		jg suite_3
	
		test rax,15
		jnz short yloop_16___
		
yloop_16_:
		vmovdqa xmm0,XMMWORD PTR[rax]
		vmovdqa xmm1,XMMWORD PTR[rsi]
		vmovdqa XMMWORD ptr [rdx],xmm0
		vmovdqa XMMWORD ptr [rdx+rdi*2],xmm1		
		vpmaddwd xmm2,xmm0,xmm8
		vpmaddwd xmm3,xmm1,xmm8
		vpmaddwd xmm0,xmm0,xmm0
		vpmaddwd xmm1,xmm1,xmm1		
		vpaddd xmm4,xmm4,xmm2
		vpaddd xmm5,xmm5,xmm0
		vpaddd xmm4,xmm4,xmm3
		vpaddd xmm5,xmm5,xmm1		
		add rdx,r11
		lea rax,[rax+rbx*4]
		lea rsi,[rsi+rbx*4]
		lea rdx,[rdx+rdi*2]
		sub r8d,r10d
		jnz short yloop_16_
		jmp suite3
		
yloop_16___:
		vmovdqu xmm0,XMMWORD PTR[rax]
		vmovdqu xmm1,XMMWORD PTR[rsi]
		vmovdqa XMMWORD ptr [rdx],xmm0
		vmovdqa XMMWORD ptr [rdx+rdi*2],xmm1
		vpmaddwd xmm2,xmm0,xmm8
		vpmaddwd xmm3,xmm1,xmm8
		vpmaddwd xmm0,xmm0,xmm0
		vpmaddwd xmm1,xmm1,xmm1		
		vpaddd xmm4,xmm4,xmm2
		vpaddd xmm5,xmm5,xmm0
		vpaddd xmm4,xmm4,xmm3
		vpaddd xmm5,xmm5,xmm1		
		add rdx,r11
		lea rax,[rax+rbx*4]
		lea rsi,[rsi+rbx*4]
		lea rdx,[rdx+rdi*2]
		sub r8d,r10d
		jnz short yloop_16___
		jmp suite3		
		
suite_3:		
		test rax,31
		jnz short yloop_16__
		
yloop_16:
		xor rcx,rcx			
xloop_2_16:
		vmovdqa ymm0,YMMWORD PTR[rax+2*rcx]
		vmovdqa ymm1,YMMWORD PTR[rsi+2*rcx]
		vmovdqa YMMWORD PTR[rdx],ymm0
		vmovdqa YMMWORD PTR[rdx+rdi*2],ymm1
		vpmaddwd ymm2,ymm0,ymm8
		vpmaddwd ymm3,ymm1,ymm8
		vpmaddwd ymm0,ymm0,ymm0
		vpmaddwd ymm1,ymm1,ymm1		
		vpaddd ymm4,ymm4,ymm2
		vpaddd ymm5,ymm5,ymm0
		vpaddd ymm4,ymm4,ymm3
		vpaddd ymm5,ymm5,ymm1		
		add rcx,r11
		add rdx,r12
		cmp rcx,rdi
		jl short xloop_2_16
		lea rax,[rax+rbx*4]
		lea rsi,[rsi+rbx*4]
		lea rdx,[rdx+rdi*2]
		sub r8d,r10d
		jnz short yloop_16
		
		vextracti128 xmm1,ymm4,1
		vextracti128 xmm2,ymm5,1
		vpaddd xmm4,xmm4,xmm1
		vpaddd xmm5,xmm5,xmm2
		
		jmp short suite3
		
yloop_16__:
		xor rcx,rcx			
xloop_2_16_:
		vmovdqu ymm0,YMMWORD PTR[rax+2*rcx]
		vmovdqu ymm1,YMMWORD PTR[rsi+2*rcx]
		vmovdqa YMMWORD PTR[rdx],ymm0
		vmovdqa YMMWORD PTR[rdx+rdi*2],ymm1
		vpmaddwd ymm2,ymm0,ymm8
		vpmaddwd ymm3,ymm1,ymm8
		vpmaddwd ymm0,ymm0,ymm0
		vpmaddwd ymm1,ymm1,ymm1		
		vpaddd ymm4,ymm4,ymm2
		vpaddd ymm5,ymm5,ymm0
		vpaddd ymm4,ymm4,ymm3
		vpaddd ymm5,ymm5,ymm1		
		add rcx,r11
		add rdx,r12
		cmp rcx,rdi
		jl short xloop_2_16_
		lea rax,[rax+rbx*4]
		lea rsi,[rsi+rbx*4]
		lea rdx,[rdx+rdi*2]
		sub r8d,r10d
		jnz short yloop_16__
		
		vextracti128 xmm1,ymm4,1
		vextracti128 xmm2,ymm5,1
		vpaddd xmm4,xmm4,xmm1
		vpaddd xmm5,xmm5,xmm2
		
suite3:		
		vmovhlps xmm1,xmm1,xmm5
		vmovhlps xmm2,xmm2,xmm4
		mov eax,r9d
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
		mov rax,mstd
		vmulss xmm4,xmm4,xmm7
		vmulss xmm5,xmm5,xmm7
		vmovss dword ptr[rax],xmm4
		vmulss xmm4,xmm4,xmm4
		vsubss xmm5,xmm5,xmm4
		vcomiss xmm5,dword ptr flt_epsilon_sse
		jbe short novarjmp_2_16
		vrsqrtss xmm5,xmm5,xmm5
		vrcpss xmm4,xmm4,xmm5
		vmovss dword ptr[rax+4],xmm4
		vmovss dword ptr[rax+8],xmm5
		jmp short finish_4_16
novarjmp_2_16:
		vmovss dword ptr[rax+4],xmm6
		vmovss dword ptr[rax+8],xmm6
finish_4_16:
		vmovss dword ptr[rax+12],xmm6		
			
	vmovdqa xmm8,XMMWORD ptr[rsp+32]
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]	
	add rsp,48
	
	vzeroupper
		
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp
		
		ret
		
extract_m8_i16_AVX2_16 endp


;extract_m8_i16_AVX2_16_2 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,inputf:dword,sum:dword,sumsq:dword
; srcp = rcx
; stride = edx
; xdia = r8d
; ydia = r9d

extract_m8_i16_AVX2_16_2 proc public frame

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
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
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
		vpxor xmm4,xmm4,xmm4
		vpxor ymm5,ymm5,ymm5
		vpxor ymm6,ymm6,ymm6
		vmovdqa xmm7,XMMWORD ptr uw_1
		
		test rax,15
		jnz yloop_16_2_
		
yloop_16_2:
		xor rcx,rcx			
xloop_2_16_2:	
		vmovdqa xmm0,XMMWORD PTR[rax+2*rcx]
		vmovdqa xmm1,XMMWORD PTR[rsi+2*rcx]
		vpmaddwd xmm2,xmm0,xmm7
		vpmaddwd xmm3,xmm1,xmm7
		vpaddd xmm4,xmm4,xmm2
		vmovdqa XMMWORD PTR[rdx],xmm0
		vmovdqa XMMWORD PTR[rdx+rdi*2],xmm1
		vpaddd xmm4,xmm4,xmm3
		vmovhlps xmm2,xmm6,xmm0
		vmovhlps xmm3,xmm6,xmm1
		vinserti128 ymm0,ymm0,xmm2,1
		vinserti128 ymm1,ymm1,xmm3,1								
		vpunpcklwd ymm0,ymm0,ymm6
		vpunpcklwd ymm1,ymm1,ymm6
		vpmulld ymm0,ymm0,ymm0
		vpmulld ymm1,ymm1,ymm1
		vpunpckhdq ymm2,ymm0,ymm6
		vpunpckhdq ymm3,ymm1,ymm6
		vpunpckldq ymm0,ymm0,ymm6
		vpunpckldq ymm1,ymm1,ymm6
		vpaddq ymm0,ymm0,ymm2
		vpaddq ymm1,ymm1,ymm3
		vpaddq ymm5,ymm5,ymm0
		vpaddq ymm5,ymm5,ymm1
		add rcx,r11
		add rdx,r12
		cmp rcx,rdi
		jl short xloop_2_16_2
		lea rax,[rax+rbx*4]
		lea rsi,[rsi+rbx*4]
		lea rdx,[rdx+rdi*2]
		sub r8d,r10d
		jnz yloop_16_2
		
		jmp suite4
		
yloop_16_2_:
		xor rcx,rcx			
xloop_2_16_2_:
		vmovdqu xmm0,XMMWORD PTR[rax+2*rcx]
		vmovdqu xmm1,XMMWORD PTR[rsi+2*rcx]
		vpmaddwd xmm2,xmm0,xmm7
		vpmaddwd xmm3,xmm1,xmm7		
		vpaddd xmm4,xmm4,xmm2
		vmovdqa XMMWORD PTR[rdx],xmm0
		vmovdqa XMMWORD PTR[rdx+rdi*2],xmm1
		vpaddd xmm4,xmm4,xmm3
		vmovhlps xmm2,xmm6,xmm0
		vmovhlps xmm3,xmm6,xmm1
		vinserti128 ymm0,ymm0,xmm2,1
		vinserti128 ymm1,ymm1,xmm3,1										
		vpunpcklwd ymm0,ymm0,ymm6
		vpunpcklwd ymm1,ymm1,ymm6
		vpmulld ymm0,ymm0,ymm0
		vpmulld ymm1,ymm1,ymm1	
		vpunpckhdq ymm2,ymm0,ymm6
		vpunpckhdq ymm3,ymm1,ymm6
		vpunpckldq ymm0,ymm0,ymm6
		vpunpckldq ymm1,ymm1,ymm6		
		vpaddq ymm0,ymm0,ymm2
		vpaddq ymm1,ymm1,ymm3
		vpaddq ymm5,ymm5,ymm0
		vpaddq ymm5,ymm5,ymm1
		add rcx,r11
		add rdx,r12
		cmp rcx,rdi
		jl short xloop_2_16_2_
		lea rax,[rax+rbx*4]
		lea rsi,[rsi+rbx*4]
		lea rdx,[rdx+rdi*2]
		sub r8d,r10d
		jnz yloop_16_2_
		
suite4:				
		vmovhlps xmm0,xmm6,xmm4
		vextracti128 xmm1,ymm5,1
		vpaddd xmm4,xmm4,xmm0
		vpaddq xmm5,xmm5,xmm1
		mov rax,sum
		vmovhlps xmm0,xmm6,xmm5
		mov rbx,sumsq
		vpaddq xmm5,xmm5,xmm0		
		vpshufd xmm2,xmm4,1
		vmovq qword ptr [rbx],xmm5		
		vpaddd xmm4,xmm4,xmm2
		vmovd dword ptr [rax],xmm4		
		
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]	
	add rsp,32
	
	vzeroupper
		
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp
		
		ret
		
extract_m8_i16_AVX2_16_2 endp


;dotProd_m32_m16_AVX2 proc data_:dword,weights:dword,vals:dword,n:dword,len:dword,istd:dword
; data_ = rcx
; weights = rdx
; vals = r8
; n = r9d

dotProd_m32_m16_AVX2 proc public frame

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
	vmovdqu XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqu XMMWORD ptr[rsp+16],xmm7
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
		vxorps ymm0,ymm0,ymm0
		vxorps ymm1,ymm1,ymm1
		vxorps ymm2,ymm2,ymm2
		vxorps ymm3,ymm3,ymm3
		mov rdx,rsi
lloop:
		vmovaps ymm7,YMMWORD ptr[rcx]
		vmulps ymm4,ymm7,YMMWORD ptr[rdi]
		vmulps ymm5,ymm7,YMMWORD ptr[rdi+r12]
		vmulps ymm6,ymm7,YMMWORD ptr[rdi+2*r12]
		vmulps ymm7,ymm7,YMMWORD ptr[rdi+96]
		vaddps ymm0,ymm0,ymm4
		vaddps ymm1,ymm1,ymm5
		vaddps ymm2,ymm2,ymm6
		vaddps ymm3,ymm3,ymm7
		
		vmovaps ymm7,YMMWORD ptr[rcx+r12]
		vmulps ymm4,ymm7,YMMWORD ptr[rdi+r13]
		vmulps ymm5,ymm7,YMMWORD ptr[rdi+160]
		vmulps ymm6,ymm7,YMMWORD ptr[rdi+192]
		vmulps ymm7,ymm7,YMMWORD ptr[rdi+224]
		vaddps ymm0,ymm0,ymm4
		vaddps ymm1,ymm1,ymm5
		vaddps ymm2,ymm2,ymm6
		vaddps ymm3,ymm3,ymm7
		
		vmovaps ymm7,YMMWORD ptr[rcx+2*r12]
		vmulps ymm4,ymm7,YMMWORD ptr[rdi+2*r13]
		vmulps ymm5,ymm7,YMMWORD ptr[rdi+288]
		vmulps ymm6,ymm7,YMMWORD ptr[rdi+320]
		vmulps ymm7,ymm7,YMMWORD ptr[rdi+352]
		vaddps ymm0,ymm0,ymm4
		vaddps ymm1,ymm1,ymm5
		vaddps ymm2,ymm2,ymm6
		vaddps ymm3,ymm3,ymm7
		
		vmovaps ymm7,YMMWORD ptr[rcx+96]
		vmulps ymm4,ymm7,YMMWORD ptr[rdi+384]
		vmulps ymm5,ymm7,YMMWORD ptr[rdi+416]
		vmulps ymm6,ymm7,YMMWORD ptr[rdi+448]
		vmulps ymm7,ymm7,YMMWORD ptr[rdi+480]
		vaddps ymm0,ymm0,ymm4
		vaddps ymm1,ymm1,ymm5
		vaddps ymm2,ymm2,ymm6
		vaddps ymm3,ymm3,ymm7

		add rcx,r13
		add rdi,r14
		sub rdx,r12
		jnz lloop
		
		vextractf128 xmm4,ymm0,1
		vextractf128 xmm5,ymm1,1
		vextractf128 xmm6,ymm2,1
		vextractf128 xmm7,ymm3,1
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7		
		
		vhaddps xmm0,xmm0,xmm1
		vhaddps xmm2,xmm2,xmm3
		vhaddps xmm0,xmm0,xmm2		
				
		vmovaps XMMWORD ptr[rax],xmm0
		add rax,r11
		sub rbx,r10
		jnz nloop
		
		mov rcx,istd
		mov rax,r8
		vmovss xmm7,dword ptr[rcx]
		xor rdx,rdx
		mov edx,r9d
		vshufps xmm7,xmm7,xmm7,0		
		xor rcx,rcx
		vinsertf128 ymm7,ymm7,xmm7,1
aloop:
		vmulps ymm0,ymm7,YMMWORD ptr[rax+rcx*4]
		vmulps ymm2,ymm7,YMMWORD ptr[rax+rcx*4+32]
		vaddps ymm0,ymm0,YMMWORD ptr[rdi+rcx*4]
		vaddps ymm2,ymm2,YMMWORD ptr[rdi+rcx*4+32]
		vmovaps YMMWORD ptr[rax+rcx*4],ymm0
		vmovaps YMMWORD ptr[rax+rcx*4+32],ymm2
		add rcx,r11
		sub rdx,r11
		jnz short aloop
		
	vmovdqu xmm7,XMMWORD ptr[rsp+16]
	vmovdqu xmm6,XMMWORD ptr[rsp]	
	add rsp,32	
	
	vzeroupper
	
	pop r15
	pop r14
	pop r13
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp
			
		ret
		
dotProd_m32_m16_AVX2 endp


;dotProd_m32_m16_FMA3 proc data_:dword,weights:dword,vals:dword,n:dword,len:dword,istd:dword
; data_ = rcx
; weights = rdx
; vals = r8
; n = r9d

dotProd_m32_m16_FMA3 proc public frame

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
	vmovdqu XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqu XMMWORD ptr[rsp+16],xmm7
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
nloop_2:
		mov rcx,r15
		vxorps ymm0,ymm0,ymm0
		vxorps ymm1,ymm1,ymm1
		vxorps ymm2,ymm2,ymm2
		vxorps ymm3,ymm3,ymm3
		mov rdx,rsi
lloop_2:
		vmovaps ymm7,YMMWORD ptr[rcx]
		vfmadd231ps ymm0,ymm7,YMMWORD ptr[rdi]
		vfmadd231ps ymm1,ymm7,YMMWORD ptr[rdi+r12]
		vfmadd231ps ymm2,ymm7,YMMWORD ptr[rdi+2*r12]
		vfmadd231ps ymm3,ymm7,YMMWORD ptr[rdi+96]		

		vmovaps ymm7,YMMWORD ptr[rcx+r12]
		vfmadd231ps ymm0,ymm7,YMMWORD ptr[rdi+r13]
		vfmadd231ps ymm1,ymm7,YMMWORD ptr[rdi+160]
		vfmadd231ps ymm2,ymm7,YMMWORD ptr[rdi+192]
		vfmadd231ps ymm3,ymm7,YMMWORD ptr[rdi+224]		
		
		vmovaps ymm7,YMMWORD ptr[rcx+2*r12]
		vfmadd231ps ymm0,ymm7,YMMWORD ptr[rdi+2*r13]
		vfmadd231ps ymm1,ymm7,YMMWORD ptr[rdi+288]
		vfmadd231ps ymm2,ymm7,YMMWORD ptr[rdi+320]
		vfmadd231ps ymm3,ymm7,YMMWORD ptr[rdi+352]		
		
		vmovaps ymm7,YMMWORD ptr[rcx+96]
		vfmadd231ps ymm0,ymm7,YMMWORD ptr[rdi+384]
		vfmadd231ps ymm1,ymm7,YMMWORD ptr[rdi+416]
		vfmadd231ps ymm2,ymm7,YMMWORD ptr[rdi+448]
		vfmadd231ps ymm3,ymm7,YMMWORD ptr[rdi+480]
				
		add rcx,r13
		add rdi,r14
		sub rdx,r12
		jnz lloop_2
				
		vextractf128 xmm4,ymm0,1
		vextractf128 xmm5,ymm1,1
		vextractf128 xmm6,ymm2,1
		vextractf128 xmm7,ymm3,1
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7								
				
		haddps xmm0,xmm1
		haddps xmm2,xmm3
		haddps xmm0,xmm2		
		
		vmovaps XMMWORD ptr[rax],xmm0
		add rax,r11
		sub rbx,r10
		jnz nloop_2
		
		mov rcx,istd
		mov rax,r8
		vmovss xmm7,dword ptr[rcx]
		xor rdx,rdx
		mov edx,r9d
		vshufps xmm7,xmm7,xmm7,0
		xor rcx,rcx
		vinsertf128 ymm7,ymm7,xmm7,1
aloop_2:
		vmulps ymm0,ymm7,YMMWORD ptr[rax+rcx*4]
		vmulps ymm2,ymm7,YMMWORD ptr[rax+rcx*4+32]
		vaddps ymm0,ymm0,YMMWORD ptr[rdi+rcx*4]
		vaddps ymm2,ymm2,YMMWORD ptr[rdi+rcx*4+32]
		vmovaps YMMWORD ptr[rax+rcx*4],ymm0
		vmovaps YMMWORD ptr[rax+rcx*4+32],ymm2
		add rcx,r11
		sub rdx,r11
		jnz short aloop_2
		
	vmovdqu xmm7,XMMWORD ptr[rsp+16]
	vmovdqu xmm6,XMMWORD ptr[rsp]	
	add rsp,32	
	
	vzeroupper
	
	pop r15
	pop r14
	pop r13
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp
			
		ret
		
dotProd_m32_m16_FMA3 endp


;dotProd_m32_m16_FMA4 proc data_:dword,weights:dword,vals:dword,n:dword,len:dword,istd:dword
; data_ = rcx
; weights = rdx
; vals = r8
; n = r9d

dotProd_m32_m16_FMA4 proc public frame

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
	vmovdqu XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqu XMMWORD ptr[rsp+16],xmm7
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
nloop_3:
		mov rcx,r15
		vxorps ymm0,ymm0,ymm0
		vxorps ymm1,ymm1,ymm1
		vxorps ymm2,ymm2,ymm2
		vxorps ymm3,ymm3,ymm3
		mov rdx,rsi
lloop_3:
		vmovaps ymm7,YMMWORD ptr[rcx]
		vfmaddps ymm0,ymm7,YMMWORD ptr[rdi],ymm0
		vfmaddps ymm1,ymm7,YMMWORD ptr[rdi+r12],ymm1
		vfmaddps ymm2,ymm7,YMMWORD ptr[rdi+2*r12],ymm2
		vfmaddps ymm3,ymm7,YMMWORD ptr[rdi+96],ymm3
		
		vmovaps ymm7,YMMWORD ptr[rcx+r12]
		vfmaddps ymm0,ymm7,YMMWORD ptr[rdi+r13],ymm0
		vfmaddps ymm1,ymm7,YMMWORD ptr[rdi+160],ymm1
		vfmaddps ymm2,ymm7,YMMWORD ptr[rdi+192],ymm2
		vfmaddps ymm3,ymm7,YMMWORD ptr[rdi+224],ymm3
		
		vmovaps ymm7,YMMWORD ptr[rcx+2*r12]
		vfmaddps ymm0,ymm7,YMMWORD ptr[rdi+2*r13],ymm0
		vfmaddps ymm1,ymm7,YMMWORD ptr[rdi+288],ymm1
		vfmaddps ymm2,ymm7,YMMWORD ptr[rdi+320],ymm2
		vfmaddps ymm3,ymm7,YMMWORD ptr[rdi+352],ymm3

		vmovaps ymm7,YMMWORD ptr[rcx+96]
		vfmaddps ymm0,ymm7,YMMWORD ptr[rdi+384],ymm0
		vfmaddps ymm1,ymm7,YMMWORD ptr[rdi+416],ymm1
		vfmaddps ymm2,ymm7,YMMWORD ptr[rdi+448],ymm2
		vfmaddps ymm3,ymm7,YMMWORD ptr[rdi+480],ymm3
						
		add rcx,r13
		add rdi,r14
		sub rdx,r12
		jnz lloop_3
				
		vextractf128 xmm4,ymm0,1
		vextractf128 xmm5,ymm1,1
		vextractf128 xmm6,ymm2,1
		vextractf128 xmm7,ymm3,1
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7												
				
		haddps xmm0,xmm1
		haddps xmm2,xmm3
		haddps xmm0,xmm2		
		
		vmovaps XMMWORD ptr[rax],xmm0
		add rax,r11
		sub rbx,r10
		jnz nloop_3
		
		mov rcx,istd
		mov rax,r8
		vmovss xmm7,dword ptr[rcx]
		xor rdx,rdx
		mov edx,r9d
		vshufps xmm7,xmm7,xmm7,0
		xor rcx,rcx
		vinsertf128 ymm7,ymm7,xmm7,1
aloop_3:
		vmulps ymm0,ymm7,YMMWORD ptr[rax+rcx*4]
		vmulps ymm2,ymm7,YMMWORD ptr[rax+rcx*4+32]
		vaddps ymm0,ymm0,YMMWORD ptr[rdi+rcx*4]
		vaddps ymm2,ymm2,YMMWORD ptr[rdi+rcx*4+32]
		vmovaps YMMWORD ptr[rax+rcx*4],ymm0
		vmovaps YMMWORD ptr[rax+rcx*4+32],ymm2
		add rcx,r11
		sub rdx,r11
		jnz short aloop_3
		
	vmovdqu xmm7,XMMWORD ptr[rsp+16]
	vmovdqu xmm6,XMMWORD ptr[rsp]	
	add rsp,32	
		
	vzeroupper
		
	pop r15
	pop r14
	pop r13
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp
			
		ret
		
dotProd_m32_m16_FMA4 endp


;dotProd_m48_m16_AVX2 proc data_:dword,weights:dword,vals:dword,n:dword,len:dword,istd:dword
; data_ = rcx
; weights = rdx
; vals = r8
; n = r9d

dotProd_m48_m16_AVX2 proc public frame

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
	vmovdqu XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqu XMMWORD ptr[rsp+16],xmm7
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
nloop:
		mov rcx,r15
		vxorps ymm0,ymm0,ymm0
		vxorps ymm1,ymm1,ymm1
		vxorps ymm2,ymm2,ymm2
		vxorps ymm3,ymm3,ymm3
		mov rdx,rsi
lloop:
		vmovaps ymm7,YMMWORD ptr[rcx]
		vmulps ymm4,ymm7,YMMWORD ptr[rdi]
		vmulps ymm5,ymm7,YMMWORD ptr[rdi+2*r11]
		vmulps ymm6,ymm7,YMMWORD ptr[rdi+4*r11]
		vmulps ymm7,ymm7,YMMWORD ptr[rdi+96]
		vaddps ymm0,ymm0,ymm4
		vaddps ymm1,ymm1,ymm5
		vaddps ymm2,ymm2,ymm6
		vaddps ymm3,ymm3,ymm7
		
		vmovaps ymm7,YMMWORD ptr[rcx+2*r11]
		vmulps ymm4,ymm7,YMMWORD ptr[rdi+8*r11]
		vmulps ymm5,ymm7,YMMWORD ptr[rdi+160]
		vmulps ymm6,ymm7,YMMWORD ptr[rdi+192]
		vmulps ymm7,ymm7,YMMWORD ptr[rdi+224]
		vaddps ymm0,ymm0,ymm4
		vaddps ymm1,ymm1,ymm5
		vaddps ymm2,ymm2,ymm6
		vaddps ymm3,ymm3,ymm7
		
		vmovaps ymm7,YMMWORD ptr[rcx+4*r11]
		vmulps ymm4,ymm7,YMMWORD ptr[rdi+256]
		vmulps ymm5,ymm7,YMMWORD ptr[rdi+288]
		vmulps ymm6,ymm7,YMMWORD ptr[rdi+320]
		vmulps ymm7,ymm7,YMMWORD ptr[rdi+352]
		vaddps ymm0,ymm0,ymm4
		vaddps ymm1,ymm1,ymm5
		vaddps ymm2,ymm2,ymm6
		vaddps ymm3,ymm3,ymm7
		
		vmovaps ymm7,YMMWORD ptr[rcx+96]
		vmulps ymm4,ymm7,YMMWORD ptr[rdi+2*r13]
		vmulps ymm5,ymm7,YMMWORD ptr[rdi+416]
		vmulps ymm6,ymm7,YMMWORD ptr[rdi+448]
		vmulps ymm7,ymm7,YMMWORD ptr[rdi+480]
		vaddps ymm0,ymm0,ymm4
		vaddps ymm1,ymm1,ymm5
		vaddps ymm2,ymm2,ymm6
		vaddps ymm3,ymm3,ymm7

		vmovaps ymm7,YMMWORD ptr[rcx+8*r11]
		vmulps ymm4,ymm7,YMMWORD ptr[rdi+512]
		vmulps ymm5,ymm7,YMMWORD ptr[rdi+544]
		vmulps ymm6,ymm7,YMMWORD ptr[rdi+576]
		vmulps ymm7,ymm7,YMMWORD ptr[rdi+608]
		vaddps ymm0,ymm0,ymm4
		vaddps ymm1,ymm1,ymm5
		vaddps ymm2,ymm2,ymm6
		vaddps ymm3,ymm3,ymm7		
		
		vmovaps ymm7,YMMWORD ptr[rcx+160]
		vmulps ymm4,ymm7,YMMWORD ptr[rdi+640]
		vmulps ymm5,ymm7,YMMWORD ptr[rdi+672]
		vmulps ymm6,ymm7,YMMWORD ptr[rdi+704]
		vmulps ymm7,ymm7,YMMWORD ptr[rdi+736]
		vaddps ymm0,ymm0,ymm4
		vaddps ymm1,ymm1,ymm5
		vaddps ymm2,ymm2,ymm6
		vaddps ymm3,ymm3,ymm7				
		
		add rcx,r13
		add rdi,r14
		sub rdx,r12
		jnz lloop
		
		vextractf128 xmm4,ymm0,1
		vextractf128 xmm5,ymm1,1
		vextractf128 xmm6,ymm2,1
		vextractf128 xmm7,ymm3,1
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7		
		
		vhaddps xmm0,xmm0,xmm1
		vhaddps xmm2,xmm2,xmm3
		vhaddps xmm0,xmm0,xmm2		
				
		vmovaps XMMWORD ptr[rax],xmm0
		add rax,r11
		sub rbx,r10
		jnz nloop
		
		mov rcx,istd
		mov rax,r8
		vmovss xmm7,dword ptr[rcx]
		xor rdx,rdx
		mov edx,r9d
		vshufps xmm7,xmm7,xmm7,0		
		xor rcx,rcx
		vinsertf128 ymm7,ymm7,xmm7,1
aloop:
		vmulps ymm0,ymm7,YMMWORD ptr[rax+rcx*4]
		vmulps ymm2,ymm7,YMMWORD ptr[rax+rcx*4+32]
		vaddps ymm0,ymm0,YMMWORD ptr[rdi+rcx*4]
		vaddps ymm2,ymm2,YMMWORD ptr[rdi+rcx*4+32]
		vmovaps YMMWORD ptr[rax+rcx*4],ymm0
		vmovaps YMMWORD ptr[rax+rcx*4+32],ymm2
		add rcx,r11
		sub rdx,r11
		jnz short aloop
		
	vmovdqu xmm7,XMMWORD ptr[rsp+16]
	vmovdqu xmm6,XMMWORD ptr[rsp]	
	add rsp,32	
	
	vzeroupper
	
	pop r15
	pop r14
	pop r13
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp
			
		ret
		
dotProd_m48_m16_AVX2 endp


;dotProd_m48_m16_FMA3 proc data_:dword,weights:dword,vals:dword,n:dword,len:dword,istd:dword
; data_ = rcx
; weights = rdx
; vals = r8
; n = r9d

dotProd_m48_m16_FMA3 proc public frame

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
	vmovdqu XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqu XMMWORD ptr[rsp+16],xmm7
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
nloop2_2:
		mov rcx,r15
		vxorps ymm0,ymm0,ymm0
		vxorps ymm1,ymm1,ymm1
		vxorps ymm2,ymm2,ymm2
		vxorps ymm3,ymm3,ymm3
		mov rdx,rsi
lloop2_2:
		vmovaps ymm7,YMMWORD ptr[rcx]
		vfmadd231ps ymm0,ymm7,YMMWORD ptr[rdi]
		vfmadd231ps ymm1,ymm7,YMMWORD ptr[rdi+2*r11]
		vfmadd231ps ymm2,ymm7,YMMWORD ptr[rdi+4*r11]
		vfmadd231ps ymm3,ymm7,YMMWORD ptr[rdi+96]		

		vmovaps ymm7,YMMWORD ptr[rcx+2*r11]
		vfmadd231ps ymm0,ymm7,YMMWORD ptr[rdi+8*r11]
		vfmadd231ps ymm1,ymm7,YMMWORD ptr[rdi+160]
		vfmadd231ps ymm2,ymm7,YMMWORD ptr[rdi+192]
		vfmadd231ps ymm3,ymm7,YMMWORD ptr[rdi+224]		
		
		vmovaps ymm7,YMMWORD ptr[rcx+4*r11]
		vfmadd231ps ymm0,ymm7,YMMWORD ptr[rdi+256]
		vfmadd231ps ymm1,ymm7,YMMWORD ptr[rdi+288]
		vfmadd231ps ymm2,ymm7,YMMWORD ptr[rdi+320]
		vfmadd231ps ymm3,ymm7,YMMWORD ptr[rdi+352]		
		
		vmovaps ymm7,YMMWORD ptr[rcx+96]
		vfmadd231ps ymm0,ymm7,YMMWORD ptr[rdi+2*r13]
		vfmadd231ps ymm1,ymm7,YMMWORD ptr[rdi+416]
		vfmadd231ps ymm2,ymm7,YMMWORD ptr[rdi+448]
		vfmadd231ps ymm3,ymm7,YMMWORD ptr[rdi+480]		
		
		vmovaps ymm7,YMMWORD ptr[rcx+8*r11]
		vfmadd231ps ymm0,ymm7,YMMWORD ptr[rdi+512]
		vfmadd231ps ymm1,ymm7,YMMWORD ptr[rdi+544]
		vfmadd231ps ymm2,ymm7,YMMWORD ptr[rdi+576]
		vfmadd231ps ymm3,ymm7,YMMWORD ptr[rdi+608]
		
		vmovaps ymm7,YMMWORD ptr[rcx+160]
		vfmadd231ps ymm0,ymm7,YMMWORD ptr[rdi+640]
		vfmadd231ps ymm1,ymm7,YMMWORD ptr[rdi+672]
		vfmadd231ps ymm2,ymm7,YMMWORD ptr[rdi+704]
		vfmadd231ps ymm3,ymm7,YMMWORD ptr[rdi+736]
						
		add rcx,r13
		add rdi,r14
		sub rdx,r12
		jnz lloop2_2
				
		vextractf128 xmm4,ymm0,1
		vextractf128 xmm5,ymm1,1
		vextractf128 xmm6,ymm2,1
		vextractf128 xmm7,ymm3,1
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7								
				
		haddps xmm0,xmm1
		haddps xmm2,xmm3
		haddps xmm0,xmm2		
		
		vmovaps XMMWORD ptr[rax],xmm0
		add rax,r11
		sub rbx,r10
		jnz nloop2_2
		
		mov rcx,istd
		mov rax,r8
		vmovss xmm7,dword ptr[rcx]
		xor rdx,rdx
		mov edx,r9d
		vshufps xmm7,xmm7,xmm7,0
		xor rcx,rcx
		vinsertf128 ymm7,ymm7,xmm7,1
aloop2_2:
		vmulps ymm0,ymm7,YMMWORD ptr[rax+rcx*4]
		vmulps ymm2,ymm7,YMMWORD ptr[rax+rcx*4+32]
		vaddps ymm0,ymm0,YMMWORD ptr[rdi+rcx*4]
		vaddps ymm2,ymm2,YMMWORD ptr[rdi+rcx*4+32]
		vmovaps YMMWORD ptr[rax+rcx*4],ymm0
		vmovaps YMMWORD ptr[rax+rcx*4+32],ymm2
		add rcx,r11
		sub rdx,r11
		jnz short aloop2_2
		
	vmovdqu xmm7,XMMWORD ptr[rsp+16]
	vmovdqu xmm6,XMMWORD ptr[rsp]	
	add rsp,32	
	
	vzeroupper
	
	pop r15
	pop r14
	pop r13
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp
			
		ret
		
dotProd_m48_m16_FMA3 endp


;dotProd_m48_m16_FMA4 proc data_:dword,weights:dword,vals:dword,n:dword,len:dword,istd:dword
; data_ = rcx
; weights = rdx
; vals = r8
; n = r9d

dotProd_m48_m16_FMA4 proc public frame

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
	vmovdqu XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqu XMMWORD ptr[rsp+16],xmm7
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
nloop2_3:
		mov rcx,r15
		vxorps ymm0,ymm0,ymm0
		vxorps ymm1,ymm1,ymm1
		vxorps ymm2,ymm2,ymm2
		vxorps ymm3,ymm3,ymm3
		mov rdx,rsi
lloop2_3:
		vmovaps ymm7,YMMWORD ptr[rcx]
		vfmaddps ymm0,ymm7,YMMWORD ptr[rdi],ymm0
		vfmaddps ymm1,ymm7,YMMWORD ptr[rdi+2*r11],ymm1
		vfmaddps ymm2,ymm7,YMMWORD ptr[rdi+4*r11],ymm2
		vfmaddps ymm3,ymm7,YMMWORD ptr[rdi+96],ymm3
		
		vmovaps ymm7,YMMWORD ptr[rcx+2*r11]
		vfmaddps ymm0,ymm7,YMMWORD ptr[rdi+8*r11],ymm0
		vfmaddps ymm1,ymm7,YMMWORD ptr[rdi+160],ymm1
		vfmaddps ymm2,ymm7,YMMWORD ptr[rdi+192],ymm2
		vfmaddps ymm3,ymm7,YMMWORD ptr[rdi+224],ymm3
		
		vmovaps ymm7,YMMWORD ptr[rcx+4*r11]
		vfmaddps ymm0,ymm7,YMMWORD ptr[rdi+256],ymm0
		vfmaddps ymm1,ymm7,YMMWORD ptr[rdi+288],ymm1
		vfmaddps ymm2,ymm7,YMMWORD ptr[rdi+320],ymm2
		vfmaddps ymm3,ymm7,YMMWORD ptr[rdi+352],ymm3

		vmovaps ymm7,YMMWORD ptr[rcx+96]
		vfmaddps ymm0,ymm7,YMMWORD ptr[rdi+2*r13],ymm0
		vfmaddps ymm1,ymm7,YMMWORD ptr[rdi+416],ymm1
		vfmaddps ymm2,ymm7,YMMWORD ptr[rdi+448],ymm2
		vfmaddps ymm3,ymm7,YMMWORD ptr[rdi+480],ymm3
		
		vmovaps ymm7,YMMWORD ptr[rcx+8*r11]
		vfmaddps ymm0,ymm7,YMMWORD ptr[rdi+512],ymm0
		vfmaddps ymm1,ymm7,YMMWORD ptr[rdi+544],ymm1
		vfmaddps ymm2,ymm7,YMMWORD ptr[rdi+576],ymm2
		vfmaddps ymm3,ymm7,YMMWORD ptr[rdi+608],ymm3
		
		vmovaps ymm7,YMMWORD ptr[rcx+160]
		vfmaddps ymm0,ymm7,YMMWORD ptr[rdi+640],ymm0
		vfmaddps ymm1,ymm7,YMMWORD ptr[rdi+672],ymm1
		vfmaddps ymm2,ymm7,YMMWORD ptr[rdi+704],ymm2
		vfmaddps ymm3,ymm7,YMMWORD ptr[rdi+736],ymm3
						
		add rcx,r13
		add rdi,r14
		sub rdx,r12
		jnz lloop2_3
				
		vextractf128 xmm4,ymm0,1
		vextractf128 xmm5,ymm1,1
		vextractf128 xmm6,ymm2,1
		vextractf128 xmm7,ymm3,1
		vaddps xmm0,xmm0,xmm4
		vaddps xmm1,xmm1,xmm5
		vaddps xmm2,xmm2,xmm6
		vaddps xmm3,xmm3,xmm7												
				
		haddps xmm0,xmm1
		haddps xmm2,xmm3
		haddps xmm0,xmm2		
		
		vmovaps XMMWORD ptr[rax],xmm0
		add rax,r11
		sub rbx,r10
		jnz nloop2_3
		
		mov rcx,istd
		mov rax,r8
		vmovss xmm7,dword ptr[rcx]
		xor rdx,rdx
		mov edx,r9d
		vshufps xmm7,xmm7,xmm7,0
		xor rcx,rcx
		vinsertf128 ymm7,ymm7,xmm7,1
aloop2_3:
		vmulps ymm0,ymm7,YMMWORD ptr[rax+rcx*4]
		vmulps ymm2,ymm7,YMMWORD ptr[rax+rcx*4+32]
		vaddps ymm0,ymm0,YMMWORD ptr[rdi+rcx*4]
		vaddps ymm2,ymm2,YMMWORD ptr[rdi+rcx*4+32]
		vmovaps YMMWORD ptr[rax+rcx*4],ymm0
		vmovaps YMMWORD ptr[rax+rcx*4+32],ymm2
		add rcx,r11
		sub rdx,r11
		jnz short aloop2_3
		
	vmovdqu xmm7,XMMWORD ptr[rsp+16]
	vmovdqu xmm6,XMMWORD ptr[rsp]	
	add rsp,32	
		
	vzeroupper
		
	pop r15
	pop r14
	pop r13
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp
			
		ret
		
dotProd_m48_m16_FMA4 endp


;dotProd_m32_m16_i16_AVX2 proc dataf:dword,weightsf:dword,vals:dword,n:dword,len:dword,istd:dword
; dataf = rcx
; weightsf = rdx
; vals = r8
; n = r9d

dotProd_m32_m16_i16_AVX2 proc public frame

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
	vmovdqu XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqu XMMWORD ptr[rsp+16],xmm7
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
		vpxor ymm0,ymm0,ymm0
		vpxor ymm1,ymm1,ymm1
		vpxor ymm2,ymm2,ymm2
		vpxor ymm3,ymm3,ymm3
		mov rdx,rsi
lloop_3:
		vmovdqa ymm7,YMMWORD ptr [rcx]
		vpmaddwd ymm4,ymm7,YMMWORD ptr [rdi]
		vpmaddwd ymm5,ymm7,YMMWORD ptr [rdi+r12]
		vpmaddwd ymm6,ymm7,YMMWORD ptr [rdi+r13]
		vpmaddwd ymm7,ymm7,YMMWORD ptr [rdi+96]
		vpaddd ymm0,ymm0,ymm4
		vpaddd ymm1,ymm1,ymm5
		vpaddd ymm2,ymm2,ymm6
		vpaddd ymm3,ymm3,ymm7
				
		vmovdqa ymm7,YMMWORD ptr [rcx+r12]
		vpmaddwd ymm4,ymm7,YMMWORD ptr [rdi+r13*2]
		vpmaddwd ymm5,ymm7,YMMWORD ptr [rdi+160]
		vpmaddwd ymm6,ymm7,YMMWORD ptr [rdi+192]
		vpmaddwd ymm7,ymm7,YMMWORD ptr [rdi+224]
		vpaddd ymm0,ymm0,ymm4
		vpaddd ymm1,ymm1,ymm5
		vpaddd ymm2,ymm2,ymm6
		vpaddd ymm3,ymm3,ymm7
		add rcx,r13
		add rdi,r14
		sub rdx,r12
		jnz short lloop_3
		vextracti128 xmm4,ymm0,1
		vextracti128 xmm5,ymm1,1
		vextracti128 xmm6,ymm2,1
		vextracti128 xmm7,ymm3,1
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
		vpaddd xmm6,xmm6,xmm0
		vmovdqa XMMWORD ptr [rax],xmm6
		add rax,r11
		sub rbx,r10
		jnz nloop_3
		mov rcx,istd
		mov rax,r8
		vmovss xmm7,dword ptr[rcx]
		xor rdx,rdx
		mov edx,r9d
		vpshufd xmm7,xmm7,0
		xor rcx,rcx
aloop_3:
		vmovdqa ymm0,YMMWORD ptr[rax+rcx*4]
		vmovdqa ymm2,YMMWORD ptr[rax+rcx*4+32]
		vcvtdq2ps ymm0,ymm0
		vcvtdq2ps ymm2,ymm2
		vextractf128 xmm1,ymm0,1
		vextractf128 xmm3,ymm2,1
		vmulps xmm0,xmm0,XMMWORD ptr[rdi+rcx*8]
		vmulps xmm1,xmm1,XMMWORD ptr[rdi+rcx*8+32]
		vmulps xmm2,xmm2,XMMWORD ptr[rdi+rcx*8+64]
		vmulps xmm3,xmm3,XMMWORD ptr[rdi+rcx*8+96]
		vmulps xmm0,xmm0,xmm7
		vmulps xmm1,xmm1,xmm7
		vmulps xmm2,xmm2,xmm7
		vmulps xmm3,xmm3,xmm7
		vaddps xmm0,xmm0,XMMWORD ptr[rdi+rcx*8+16]
		vaddps xmm1,xmm1,XMMWORD ptr[rdi+rcx*8+48]
		vaddps xmm2,xmm2,XMMWORD ptr[rdi+rcx*8+80]
		vaddps xmm3,xmm3,XMMWORD ptr[rdi+rcx*8+112]
		vmovaps XMMWORD ptr[rax+rcx*4],xmm0
		vmovaps XMMWORD ptr[rax+rcx*4+16],xmm1
		vmovaps XMMWORD ptr[rax+rcx*4+32],xmm2
		vmovaps XMMWORD ptr[rax+rcx*4+48],xmm3
		add rcx,r11
		sub rdx,r11
		jnz short aloop_3
		
	vmovdqu xmm7,XMMWORD ptr[rsp+16]
	vmovdqu xmm6,XMMWORD ptr[rsp]	
	add rsp,32	
		
	vzeroupper
		
	pop r15
	pop r14
	pop r13
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp		
		
		ret
		
dotProd_m32_m16_i16_AVX2 endp


;dotProd_m48_m16_i16_AVX2 proc dataf:dword,weightsf:dword,vals:dword,n:dword,len:dword,istd:dword
; dataf = rcx
; weightsf = rdx
; vals = r8
; n = r9d

dotProd_m48_m16_i16_AVX2 proc public frame

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
	vmovdqu XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqu XMMWORD ptr[rsp+16],xmm7
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
		vpxor ymm0,ymm0,ymm0
		vpxor ymm1,ymm1,ymm1
		vpxor ymm2,ymm2,ymm2
		vpxor ymm3,ymm3,ymm3
		mov rdx,rsi
lloop_4:
		vmovdqa ymm7,YMMWORD ptr [rcx]
		vpmaddwd ymm4,ymm7,YMMWORD ptr [rdi]
		vpmaddwd ymm5,ymm7,YMMWORD ptr [rdi+r11*2]
		vpmaddwd ymm6,ymm7,YMMWORD ptr [rdi+r11*4]
		vpmaddwd ymm7,ymm7,YMMWORD ptr [rdi+r13]
		vpaddd ymm0,ymm0,ymm4
		vpaddd ymm1,ymm1,ymm5
		vpaddd ymm2,ymm2,ymm6
		vpaddd ymm3,ymm3,ymm7
				
		vmovdqa ymm7,YMMWORD ptr [rcx+r11*2]
		vpmaddwd ymm4,ymm7,YMMWORD ptr [rdi+r11*8]
		vpmaddwd ymm5,ymm7,YMMWORD ptr [rdi+160]
		vpmaddwd ymm6,ymm7,YMMWORD ptr [rdi+192]
		vpmaddwd ymm7,ymm7,YMMWORD ptr [rdi+224]
		vpaddd ymm0,ymm0,ymm4
		vpaddd ymm1,ymm1,ymm5
		vpaddd ymm2,ymm2,ymm6
		vpaddd ymm3,ymm3,ymm7		
		
		vmovdqa ymm7,YMMWORD ptr [rcx+r11*4]
		vpmaddwd ymm4,ymm7,YMMWORD ptr [rdi+256]
		vpmaddwd ymm5,ymm7,YMMWORD ptr [rdi+288]
		vpmaddwd ymm6,ymm7,YMMWORD ptr [rdi+320]
		vpmaddwd ymm7,ymm7,YMMWORD ptr [rdi+352]
		vpaddd ymm0,ymm0,ymm4
		vpaddd ymm1,ymm1,ymm5
		vpaddd ymm2,ymm2,ymm6
		vpaddd ymm3,ymm3,ymm7	

		add rcx,r13
		add rdi,r14
		sub rdx,r12
		jnz lloop_4
		
		vextracti128 xmm4,ymm0,1
		vextracti128 xmm5,ymm1,1
		vextracti128 xmm6,ymm2,1
		vextracti128 xmm7,ymm3,1
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
		vpaddd xmm6,xmm6,xmm0
		vmovdqa XMMWORD ptr [rax],xmm6		
		
		add rax,r11
		sub rbx,r10
		jnz nloop_4
		mov rcx,istd
		mov rax,r8
		vmovss xmm7,dword ptr[rcx]
		xor rbx,rbx
		mov edx,r9d
		vpshufd xmm7,xmm7,0
		xor rcx,rcx
aloop_4:
		vmovdqa ymm0,YMMWORD ptr[rax+rcx*4]
		vmovdqa ymm2,YMMWORD ptr[rax+rcx*4+32]
		vcvtdq2ps ymm0,ymm0
		vcvtdq2ps ymm2,ymm2
		vextractf128 xmm1,ymm0,1
		vextractf128 xmm3,ymm2,1
		vmulps xmm0,xmm0,XMMWORD ptr[rdi+rcx*8]
		vmulps xmm1,xmm1,XMMWORD ptr[rdi+rcx*8+32]
		vmulps xmm2,xmm2,XMMWORD ptr[rdi+rcx*8+64]
		vmulps xmm3,xmm3,XMMWORD ptr[rdi+rcx*8+96]
		vmulps xmm0,xmm0,xmm7
		vmulps xmm1,xmm1,xmm7
		vmulps xmm2,xmm2,xmm7
		vmulps xmm3,xmm3,xmm7
		vaddps xmm0,xmm0,XMMWORD ptr[rdi+rcx*8+16]
		vaddps xmm1,xmm1,XMMWORD ptr[rdi+rcx*8+48]
		vaddps xmm2,xmm2,XMMWORD ptr[rdi+rcx*8+80]
		vaddps xmm3,xmm3,XMMWORD ptr[rdi+rcx*8+112]
		vmovaps XMMWORD ptr[rax+rcx*4],xmm0
		vmovaps XMMWORD ptr[rax+rcx*4+16],xmm1
		vmovaps XMMWORD ptr[rax+rcx*4+32],xmm2
		vmovaps XMMWORD ptr[rax+rcx*4+48],xmm3
		add rcx,r11
		sub rdx,r11
		jnz short aloop_4
		
	vmovdqu xmm7,XMMWORD ptr[rsp+16]
	vmovdqu xmm6,XMMWORD ptr[rsp]	
	add rsp,32	
		
	vzeroupper
		
	pop r15
	pop r14
	pop r13
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp		
		
		ret

dotProd_m48_m16_i16_AVX2 endp


;e0_m16_AVX2 proc ptr_s:dword,n:dword
; ptr_s = rcx
; n = edx

e0_m16_AVX2 proc public frame

	.endprolog
	
		mov rax,rcx
		xor rcx,rcx
		mov ecx,edx
		
		vmovdqa ymm2,YMMWORD ptr exp_hi
		vmovdqa ymm3,YMMWORD ptr exp_lo
		vmovdqa ymm4,YMMWORD ptr e0_mult
		vmovdqa ymm5,YMMWORD ptr e0_bias
		
		mov rdx,16
		mov r8,32
		mov r10,64
		
eloop16:
		vmovaps ymm0,YMMWORD ptr [rax]
		vmovaps ymm1,YMMWORD ptr [rax+r8]
		vminps ymm0,ymm0,ymm2
		vminps ymm1,ymm1,ymm2
		vmaxps ymm0,ymm0,ymm3
		vmaxps ymm1,ymm1,ymm3
		vmulps ymm0,ymm0,ymm4
		vmulps ymm1,ymm1,ymm4
		vaddps ymm0,ymm0,ymm5
		vaddps ymm1,ymm1,ymm5
		vcvtps2dq ymm0,ymm0
		vcvtps2dq ymm1,ymm1
		vmovaps YMMWORD ptr [rax],ymm0
		vmovaps YMMWORD ptr [rax+r8],ymm1
		add rax,r10
		sub rcx,rdx
		
		jnz short eloop16
		
		vzeroupper
		
		ret

e0_m16_AVX2 endp


;e0_m16_FMA3 proc ptr_s:dword,n:dword
; ptr_s = rcx
; n = edx

e0_m16_FMA3 proc public frame

	.endprolog
	
		mov rax,rcx
		xor rcx,rcx
		mov ecx,edx
		
		vmovdqa ymm2,YMMWORD ptr exp_hi
		vmovdqa ymm3,YMMWORD ptr exp_lo
		vmovdqa ymm4,YMMWORD ptr e0_mult
		vmovdqa ymm5,YMMWORD ptr e0_bias
				
		mov rdx,16
		mov r8,32
		mov r10,64
		
eloop16_2:
		vmovaps ymm0,YMMWORD ptr [rax]
		vmovaps ymm1,YMMWORD ptr [rax+r8]
		vminps ymm0,ymm0,ymm2
		vminps ymm1,ymm1,ymm2
		vmaxps ymm0,ymm0,ymm3
		vmaxps ymm1,ymm1,ymm3
		
		vfmadd213ps ymm0,ymm4,ymm5
		vfmadd213ps ymm1,ymm4,ymm5
				
		vcvtps2dq ymm0,ymm0
		vcvtps2dq ymm1,ymm1
		vmovaps YMMWORD ptr [rax],ymm0
		vmovaps YMMWORD ptr [rax+r8],ymm1
		add rax,r10
		sub rcx,rdx
		
		jnz short eloop16_2		
		
		vzeroupper
		
		ret

e0_m16_FMA3 endp


;e0_m16_FMA4 proc ptr_s:dword,n:dword
; ptr_s = rcx
; n = edx

e0_m16_FMA4 proc public frame

	.endprolog
	
		mov rax,rcx
		xor rcx,rcx
		mov ecx,edx
		
		vmovdqa ymm2,YMMWORD ptr exp_hi
		vmovdqa ymm3,YMMWORD ptr exp_lo
		vmovdqa ymm4,YMMWORD ptr e0_mult
		vmovdqa ymm5,YMMWORD ptr e0_bias
				
		mov rdx,16
		mov r8,32
		mov r10,64
		
eloop16_3:
		vmovaps ymm0,YMMWORD ptr [rax]
		vmovaps ymm1,YMMWORD ptr [rax+r8]
		vminps ymm0,ymm0,ymm2
		vminps ymm1,ymm1,ymm2
		vmaxps ymm0,ymm0,ymm3
		vmaxps ymm1,ymm1,ymm3
		
		vfmaddps ymm0,ymm0,ymm4,ymm5
		vfmaddps ymm1,ymm1,ymm4,ymm5
						
		vcvtps2dq ymm0,ymm0
		vcvtps2dq ymm1,ymm1
		vmovaps YMMWORD ptr [rax],ymm0
		vmovaps YMMWORD ptr [rax+r8],ymm1		
		add rax,r10
		sub rcx,rdx
		
		jnz short eloop16_3
		
		vzeroupper
		
		ret

e0_m16_FMA4 endp


;e1_m16_AVX2 proc ptr_s:dword,n:dword
; ptr_s = rcx
; n = edx

e1_m16_AVX2 proc public frame

	sub rsp,64
	.allocstack 64
	vmovdqu XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqu XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	vmovdqu XMMWORD ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	vmovdqu XMMWORD ptr[rsp+48],xmm9
	.savexmm128 xmm9,48
	vmovdqu XMMWORD ptr[rsp+64],xmm10
	.endprolog
	
		mov rax,rcx
		xor rcx,rcx
		mov ecx,edx
		
		vmovdqa ymm3,YMMWORD ptr exp_hi
		vmovdqa ymm4,YMMWORD ptr exp_lo
		vmovdqa ymm5,YMMWORD ptr e1_scale
		vmovdqa ymm6,YMMWORD ptr e1_bias
		vmovdqa ymm7,YMMWORD ptr e1_c1
		vmovdqa ymm8,YMMWORD ptr e1_c2
		vmovdqa ymm9,YMMWORD ptr e1_c0
		
		mov rdx,8
		mov r9,32	
		
eloop8:
		vmovaps ymm0,YMMWORD ptr [rax]
		vminps ymm0,ymm0,ymm3
		vmaxps ymm0,ymm0,ymm4
		vmulps ymm0,ymm0,ymm5
		vmovaps ymm1,ymm0
		vaddps ymm0,ymm0,ymm6
		vpslld ymm2,ymm0,23
		vsubps ymm0,ymm0,ymm6
		vsubps ymm1,ymm1,ymm0
		vmulps ymm0,ymm1,ymm7
		vmulps ymm1,ymm1,ymm1
		vmulps ymm1,ymm1,ymm8
		vaddps ymm0,ymm0,ymm9
		vaddps ymm0,ymm0,ymm1
		vpaddd ymm0,ymm0,ymm2
		vmovaps YMMWORD ptr [rax],ymm0
		add rax,r9
		sub rcx,rdx
		jnz short eloop8
		
	vmovdqu xmm9,XMMWORD ptr[rsp+48]
	vmovdqu xmm8,XMMWORD ptr[rsp+32]
	vmovdqu xmm7,XMMWORD ptr[rsp+16]
	vmovdqu xmm6,XMMWORD ptr[rsp]	
	add rsp,64
		
	vzeroupper
		
		ret
		
e1_m16_AVX2 endp


;e2_m16_AVX2 proc ptr_s:dword,n:dword
; ptr_s = rcx
; n = edx

e2_m16_AVX2 proc public frame

	sub rsp,160
	.allocstack 160
	vmovdqu XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqu XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	vmovdqu XMMWORD ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	vmovdqu XMMWORD ptr[rsp+48],xmm9
	.savexmm128 xmm9,48
	vmovdqu XMMWORD ptr[rsp+64],xmm10
	.savexmm128 xmm10,64
	vmovdqu XMMWORD ptr[rsp+80],xmm11
	.savexmm128 xmm11,80
	vmovdqu XMMWORD ptr[rsp+96],xmm12
	.savexmm128 xmm12,96
	vmovdqu XMMWORD ptr[rsp+112],xmm13
	.savexmm128 xmm13,112
	vmovdqu XMMWORD ptr[rsp+128],xmm14
	.savexmm128 xmm14,128
	vmovdqu XMMWORD ptr[rsp+144],xmm15
	.savexmm128 xmm15,144
	.endprolog
	
		mov rax,rcx
		xor rcx,rcx
		mov ecx,edx
		
		vmovdqa ymm7,YMMWORD ptr exp_hi
		vmovdqa ymm8,YMMWORD ptr exp_lo
		vmovdqa ymm9,YMMWORD ptr exp_rln2
		vmovdqa ymm10,YMMWORD ptr am_0p5
		vmovdqa ymm11,YMMWORD ptr epi32_1
		vmovdqa ymm12,YMMWORD ptr exp_c2
		vmovdqa ymm13,YMMWORD ptr exp_c1
		vmovdqa ymm14,YMMWORD ptr exp_q0
		vmovdqa ymm15,YMMWORD ptr am_1
		
		mov rdx,8
		mov r8,32

eloop4:
		vmovaps ymm0,YMMWORD ptr [rax]		
		vminps ymm0,ymm0,ymm7
		vmaxps ymm0,ymm0,ymm8
		vmulps ymm1,ymm0,ymm9
		vxorps ymm2,ymm2,ymm2
		vaddps ymm1,ymm1,ymm10
		vcmpnltps ymm2,ymm2,ymm1
		vpand ymm2,ymm2,ymm11
		vcvttps2dq ymm1,ymm1
		vpsubd ymm1,ymm1,ymm2
		vmovaps ymm5,ymm13
		vcvtdq2ps ymm3,ymm1
		vmulps ymm4,ymm3,ymm12
		vmulps ymm5,ymm5,ymm3
		vsubps ymm0,ymm0,ymm4
		vsubps ymm0,ymm0,ymm5
		vpaddd ymm1,ymm1,YMMWORD ptr epi32_0x7f
		vmovaps ymm2,ymm0
		vmulps ymm0,ymm0,ymm0
		vmulps ymm6,ymm0,ymm14
		vmulps ymm4,ymm0,YMMWORD ptr exp_p0
		vaddps ymm6,ymm6,YMMWORD ptr exp_q1
		vaddps ymm4,ymm4,YMMWORD ptr exp_p1
		vmulps ymm6,ymm6,ymm0
		vmulps ymm4,ymm4,ymm0
		vaddps ymm6,ymm6,YMMWORD ptr exp_q2
		vmulps ymm4,ymm4,ymm2
		vmulps ymm6,ymm6,ymm0
		vaddps ymm2,ymm2,ymm4
		vaddps ymm6,ymm6,YMMWORD ptr exp_q3
		vpslld ymm1,ymm1,23
		vsubps ymm6,ymm6,ymm2
		vrcpps ymm6,ymm6
		vmulps ymm2,ymm2,ymm6
		vaddps ymm2,ymm2,ymm2
		vaddps ymm0,ymm2,ymm15
		vmulps ymm0,ymm0,ymm1		
		vmovaps YMMWORD ptr [rax],ymm0
		add rax,r8
		sub rcx,rdx
		jnz eloop4
		
	vmovdqu xmm15,XMMWORD ptr[rsp+144]
	vmovdqu xmm14,XMMWORD ptr[rsp+128]
	vmovdqu xmm13,XMMWORD ptr[rsp+112]
	vmovdqu xmm12,XMMWORD ptr[rsp+96]
	vmovdqu xmm11,XMMWORD ptr[rsp+80]
	vmovdqu xmm10,XMMWORD ptr[rsp+64]
	vmovdqu xmm9,XMMWORD ptr[rsp+48]
	vmovdqu xmm8,XMMWORD ptr[rsp+32]
	vmovdqu xmm7,XMMWORD ptr[rsp+16]
	vmovdqu xmm6,XMMWORD ptr[rsp]	
	add rsp,160		
		
	vzeroupper
		
		ret
		
e2_m16_AVX2 endp


end
