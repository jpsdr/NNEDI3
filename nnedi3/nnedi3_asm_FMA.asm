.xmm
.model flat,c

.data

FLT_EPSILON  equ   1.192092896e-07

align 16

sign_bits_f_zero_l qword 7FFFFFFF00000000h,7FFFFFFF7FFFFFFFh
sign_bits_f qword 2 dup(7FFFFFFF7FFFFFFFh)
ones_f real4 4 dup(1.0)

min_weight_sum real4 4 dup(1.0e-10)
five_f real4 4 dup(5.0)

flt_epsilon_sse real4 4 dup(FLT_EPSILON)

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
w_254 sword 16 dup(254)
w_16 sword 16 dup(16)
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


computeNetwork0_AVX2 proc input:dword,weights:dword,ptr_d:dword

    public computeNetwork0_AVX2
	
		mov ecx,input
		mov edx,weights
		mov eax,1
		
		vmovaps ymm7,YMMWORD ptr [ecx]
		vmulps ymm0,ymm7,YMMWORD ptr [edx]
		vmulps ymm1,ymm7,YMMWORD ptr [edx+32]
		vmulps ymm2,ymm7,YMMWORD ptr [edx+64]
		vmulps ymm3,ymm7,YMMWORD ptr [edx+96]
		
		vmovaps ymm7,YMMWORD ptr [ecx+32]
		vmulps ymm4,ymm7,YMMWORD ptr [edx+128]
		vmulps ymm5,ymm7,YMMWORD ptr [edx+160]
		vmulps ymm6,ymm7,YMMWORD ptr [edx+192]
		vmulps ymm7,ymm7,YMMWORD ptr [edx+224]		
		vaddps ymm0,ymm0,ymm4
		vaddps ymm1,ymm1,ymm5
		vaddps ymm2,ymm2,ymm6
		vaddps ymm3,ymm3,ymm7
		
		vmovaps ymm7,YMMWORD ptr [ecx+64]
		vmulps ymm4,ymm7,YMMWORD ptr [edx+256]
		vmulps ymm5,ymm7,YMMWORD ptr [edx+288]
		vmulps ymm6,ymm7,YMMWORD ptr [edx+320]
		vmulps ymm7,ymm7,YMMWORD ptr [edx+352]
		vaddps ymm0,ymm0,ymm4
		vaddps ymm1,ymm1,ymm5
		vaddps ymm2,ymm2,ymm6
		vaddps ymm3,ymm3,ymm7
		
		vmovaps ymm7,YMMWORD ptr [ecx+96]
		vmulps ymm4,ymm7,YMMWORD ptr [edx+384]
		vmulps ymm5,ymm7,YMMWORD ptr [edx+416]
		vmulps ymm6,ymm7,YMMWORD ptr [edx+448]
		vmulps ymm7,ymm7,YMMWORD ptr [edx+480]
		vaddps ymm0,ymm0,ymm4
		vaddps ymm1,ymm1,ymm5
		vaddps ymm2,ymm2,ymm6
		vaddps ymm3,ymm3,ymm7
		
		vmovaps ymm7,YMMWORD ptr [ecx+128]
		vmulps ymm4,ymm7,YMMWORD ptr [edx+512]
		vmulps ymm5,ymm7,YMMWORD ptr [edx+544]
		vmulps ymm6,ymm7,YMMWORD ptr [edx+576]
		vmulps ymm7,ymm7,YMMWORD ptr [edx+608]
		vaddps ymm0,ymm0,ymm4
		vaddps ymm1,ymm1,ymm5
		vaddps ymm2,ymm2,ymm6
		vaddps ymm3,ymm3,ymm7
		
		vmovaps ymm7,YMMWORD ptr [ecx+160]
		vmulps ymm4,ymm7,YMMWORD ptr [edx+640]
		vmulps ymm5,ymm7,YMMWORD ptr [edx+672]
		vmulps ymm6,ymm7,YMMWORD ptr [edx+704]
		vmulps ymm7,ymm7,YMMWORD ptr [edx+736]
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
		vaddps xmm0,xmm0,XMMWORD ptr [edx+768]
		
		vmovaps xmm1,xmm0
		vandps xmm0,xmm0,XMMWORD ptr sign_bits_f_zero_l
		vaddps xmm0,xmm0,ones_f
		vrcpps xmm0,xmm0
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
		jbe short finish_1
		xor eax,eax
finish_1:
		mov BYTE PTR[ecx],al
		
		vzeroupper
		
		ret

computeNetwork0_AVX2 endp


computeNetwork0_i16_AVX2 proc inputf:dword,weightsf:dword,ptr_d:dword

    public computeNetwork0_i16_AVX2

		mov ecx,inputf
		mov edx,weightsf
		mov eax,1
		
		vmovdqa ymm7,YMMWORD ptr [ecx]
		vpmaddwd ymm0,ymm7,YMMWORD ptr [edx]
		vpmaddwd ymm1,ymm7,YMMWORD ptr [edx+32]
		vpmaddwd ymm2,ymm7,YMMWORD ptr [edx+64]
		vpmaddwd ymm3,ymm7,YMMWORD ptr [edx+96]
		
		vmovdqa ymm7,YMMWORD ptr [ecx+32]
		vpmaddwd ymm4,ymm7,YMMWORD ptr [edx+128]
		vpmaddwd ymm5,ymm7,YMMWORD ptr [edx+160]
		vpmaddwd ymm6,ymm7,YMMWORD ptr [edx+192]
		vpmaddwd ymm7,ymm7,YMMWORD ptr [edx+224]
		vpaddd ymm0,ymm0,ymm4
		vpaddd ymm1,ymm1,ymm5
		vpaddd ymm2,ymm2,ymm6
		vpaddd ymm3,ymm3,ymm7
		
		vmovdqa ymm7,YMMWORD ptr [ecx+64]
		vpmaddwd ymm4,ymm7,YMMWORD ptr [edx+256]
		vpmaddwd ymm5,ymm7,YMMWORD ptr [edx+288]
		vpmaddwd ymm6,ymm7,YMMWORD ptr [edx+320]
		vpmaddwd ymm7,ymm7,YMMWORD ptr [edx+352]
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
		vmulps xmm0,xmm0,XMMWORD ptr [edx+384]
		vaddps xmm0,xmm0,XMMWORD ptr [edx+400]
		vmovaps xmm1,xmm0
		vandps xmm0,xmm0,XMMWORD ptr sign_bits_f_zero_l
		vaddps xmm0,xmm0,XMMWORD ptr ones_f
		vrcpps xmm0,xmm0
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
		jbe short finish_2
		xor eax,eax
finish_2:
		mov BYTE PTR[ecx],al
		
		vzeroupper
		
		ret
		
computeNetwork0_i16_AVX2 endp


computeNetwork0new_AVX2 proc datai:dword,weights:dword,ptr_d:dword

	public computeNetwork0new_AVX2

		mov ecx,datai
		mov eax,weights
		
		vmovdqa ymm7,YMMWORD ptr [ecx]
		vpmaddwd ymm0,ymm7,YMMWORD ptr [eax]
		vpmaddwd ymm1,ymm7,YMMWORD ptr [eax+32]
		vpmaddwd ymm2,ymm7,YMMWORD ptr [eax+64]
		vpmaddwd ymm3,ymm7,YMMWORD ptr [eax+96]
		
		vmovdqa ymm7,YMMWORD ptr [ecx+32]
		vpmaddwd ymm4,ymm7,YMMWORD ptr [eax+128]
		vpmaddwd ymm5,ymm7,YMMWORD ptr [eax+160]
		vpmaddwd ymm6,ymm7,YMMWORD ptr [eax+192]
		vpmaddwd ymm7,ymm7,YMMWORD ptr [eax+224]
		vpaddd ymm0,ymm0,ymm4
		vpaddd ymm1,ymm1,ymm5
		vpaddd ymm2,ymm2,ymm6
		vpaddd ymm3,ymm3,ymm7
		
		vmovdqa ymm7,YMMWORD ptr [ecx+64]
		vpmaddwd ymm4,ymm7,YMMWORD ptr [eax+256]
		vpmaddwd ymm5,ymm7,YMMWORD ptr [eax+288]
		vpmaddwd ymm6,ymm7,YMMWORD ptr [eax+320]
		vpmaddwd ymm7,ymm7,YMMWORD ptr [eax+352]
		vpaddd ymm0,ymm0,ymm4
		vpaddd ymm1,ymm1,ymm5
		vpaddd ymm2,ymm2,ymm6
		vpaddd ymm3,ymm3,ymm7
		
		vmovdqa ymm7,YMMWORD ptr [ecx+96]
		vpmaddwd ymm4,ymm7,YMMWORD ptr [eax+384]
		vpmaddwd ymm5,ymm7,YMMWORD ptr [eax+416]
		vpmaddwd ymm6,ymm7,YMMWORD ptr [eax+448]
		vpmaddwd ymm7,ymm7,YMMWORD ptr [eax+480]
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
		vmulps xmm0,xmm0,XMMWORD ptr [eax+512]
		vaddps xmm0,xmm0,XMMWORD ptr [eax+528]
		vmovaps xmm1,xmm0
		vandps xmm0,xmm0,XMMWORD ptr sign_bits_f
		vaddps xmm0,xmm0,XMMWORD ptr ones_f
		vrcpps xmm0,xmm0
		vmulps xmm0,xmm0,xmm1
		vpshufd xmm1,xmm0,0
		vpshufd xmm2,xmm0,85
		vpshufd xmm3,xmm0,170
		vpshufd xmm4,xmm0,255
		vmulps xmm1,xmm1,XMMWORD ptr [eax+544]
		vmulps xmm2,xmm2,XMMWORD ptr [eax+560]
		vmulps xmm3,xmm3,XMMWORD ptr [eax+576]
		vmulps xmm4,xmm4,XMMWORD ptr [eax+592]
		vpxor xmm0,xmm0,xmm0
		vaddps xmm1,xmm1,xmm2
		vaddps xmm3,xmm3,xmm4
		vaddps xmm1,xmm1,xmm3
		mov ecx,ptr_d
		vaddps xmm1,xmm1,XMMWORD ptr [eax+608]
		vcmpps xmm1,xmm1,xmm0,1
		vpackssdw xmm1,xmm1,xmm0
		vpacksswb xmm1,xmm1,xmm0
		
		vmovd eax,xmm1
		
		vzeroupper
		
		xor eax,0FFFFFFFFh
		and eax,001010101h
		mov [ecx],eax
		
		ret
		
computeNetwork0new_AVX2 endp


processLine0_AVX2_ASM proc tempu:dword,width_:dword,dstp:dword,src3p:dword,src_pitch:dword,val_min:word,val_max:word

    public processLine0_AVX2_ASM
	
		push ebx
		push edi
		push esi
		
		vpbroadcastw ymm0,val_min
		vpbroadcastw ymm1,val_max
		vmovdqa YMMWORD ptr w_16,ymm0
		vmovdqa YMMWORD ptr w_254,ymm1
				
		mov eax,tempu
		mov ebx,src3p
		mov ecx,width_
		mov edx,src_pitch
		mov esi,dstp
		lea edi,[ebx+edx*4]
		
		vpxor ymm6,ymm6,ymm6
		vpxor ymm7,ymm7,ymm7
		
xloop:
		vmovdqa ymm0,YMMWORD PTR [ebx+edx*2]
		vmovdqa ymm1,YMMWORD PTR [edi]
		vpunpckhbw ymm2,ymm0,ymm7
		vpunpckhbw ymm3,ymm1,ymm7
		vpunpcklbw ymm0,ymm0,ymm7		
		vpunpcklbw ymm1,ymm1,ymm7
		vpaddw ymm0,ymm0,ymm1
		vpaddw ymm2,ymm2,ymm3
		vpmullw ymm0,ymm0,YMMWORD PTR w_19
		vpmullw ymm2,ymm2,YMMWORD PTR w_19
		vmovdqa ymm1,YMMWORD PTR [ebx]
		vmovdqa ymm3,YMMWORD PTR [edi+edx*2]
		vpunpckhbw ymm4,ymm1,ymm7
		vpunpckhbw ymm5,ymm3,ymm7
		vpunpcklbw ymm1,ymm1,ymm7		
		vpunpcklbw ymm3,ymm3,ymm7
		vpaddw ymm1,ymm1,ymm3
		vpaddw ymm4,ymm4,ymm5
		vpmullw ymm1,ymm1,YMMWORD PTR w_3
		vpmullw ymm4,ymm4,YMMWORD PTR w_3
		vmovdqa ymm5,YMMWORD PTR [eax]
		vpsubusw ymm0,ymm0,ymm1
		vpsubusw ymm2,ymm2,ymm4
		vpxor ymm5,ymm5,YMMWORD PTR ub_1
		vpaddusw ymm0,ymm0,YMMWORD PTR uw_16
		vpaddusw ymm2,ymm2,YMMWORD PTR uw_16
		vpsadbw ymm5,ymm5,ymm7
		vpsraw ymm0,ymm0,5		
		vpsraw ymm2,ymm2,5		
		vmovdqa ymm3,ymm5
		vpminsw ymm0,ymm0,YMMWORD PTR w_254
		vpsrldq ymm5,ymm5,8
		vpminsw ymm2,ymm2,YMMWORD PTR w_254
		vpaddusw ymm5,ymm5,ymm3
		vpmaxsw ymm0,ymm0,YMMWORD PTR w_16
		vpmaxsw ymm2,ymm2,YMMWORD PTR w_16
		vextracti128 xmm3,ymm5,1
		vpackuswb ymm0,ymm0,ymm2
		vpaddusw xmm5,xmm5,xmm3
		vmovdqa YMMWORD PTR [esi],ymm0
		vpaddusw xmm6,xmm6,xmm5
		
		add ebx,32
		add edi,32
		add eax,32
		add esi,32
		sub ecx,32
		jnz xloop
			
		pop esi
		pop edi
		pop ebx
		
		vmovd eax,xmm6
		
		vzeroupper
		
		ret
		
processLine0_AVX2_ASM endp


processLine0_AVX2_ASM_16 proc tempu:dword,width_:dword,dstp:dword,src3p:dword,src_pitch:dword,val_min:word,val_max:word

    public processLine0_AVX2_ASM_16
	
		push ebx
		push edi
		push esi

		vpbroadcastw ymm0,val_min
		vpbroadcastw ymm1,val_max
		vmovdqa YMMWORD ptr w_16,ymm0
		vmovdqa YMMWORD ptr w_254,ymm1
				
		mov eax,tempu
		mov ebx,src3p
		mov ecx,width_
		mov edx,src_pitch
		mov esi,dstp
		lea edi,[ebx+edx*4]
		vpxor ymm6,ymm6,ymm6
		vpxor ymm7,ymm7,ymm7
xloop_16:
		vmovdqa ymm0,YMMWORD ptr[ebx+edx*2]
		vmovdqa ymm1,YMMWORD ptr[edi]
		vpunpckhwd ymm2,ymm0,ymm7
		vpunpckhwd ymm3,ymm1,ymm7
		vpunpcklwd ymm0,ymm0,ymm7		
		vpunpcklwd ymm1,ymm1,ymm7
		vpaddd ymm0,ymm0,ymm1
		vpaddd ymm2,ymm2,ymm3
		vpmulld ymm0,ymm0,YMMWORD ptr d_19
		vpmulld ymm2,ymm2,YMMWORD ptr d_19
		vmovdqa ymm1,YMMWORD ptr[ebx]
		vmovdqa ymm3,YMMWORD ptr[edi+edx*2]
		vpunpckhwd ymm4,ymm1,ymm7
		vpunpckhwd ymm5,ymm3,ymm7
		vpunpcklwd ymm1,ymm1,ymm7
		vpunpcklwd ymm3,ymm3,ymm7
		vpaddd ymm1,ymm1,ymm3
		vpaddd ymm4,ymm4,ymm5
		vpmulld ymm1,ymm1,YMMWORD ptr d_3
		vpmulld ymm4,ymm4,YMMWORD ptr d_3
		vpsubd ymm0,ymm0,ymm1
		vpsubd ymm2,ymm2,ymm4
		vmovdqa xmm5,XMMWORD ptr [eax]
		vpaddd ymm0,ymm0,YMMWORD ptr ud_16
		vpaddd ymm2,ymm2,YMMWORD ptr ud_16
		vpxor xmm5,xmm5,XMMWORD ptr ub_1
		vpsrad ymm0,ymm0,5
		vpsrad ymm2,ymm2,5
		vpsadbw xmm5,xmm5,xmm7
		vpackusdw ymm0,ymm0,ymm2
		vmovdqa xmm3,xmm5
		vpminuw ymm0,ymm0,YMMWORD ptr w_254		
		vpsrldq xmm5,xmm5,8
		vpmaxuw ymm0,ymm0,YMMWORD ptr w_16
		vpaddusw xmm5,xmm5,xmm3
		vmovdqa YMMWORD ptr [esi],ymm0
		vpaddusw xmm6,xmm6,xmm5
		
		add ebx,32
		add edi,32
		add eax,16
		add esi,32
		sub ecx,16
		jnz xloop_16
			
		pop esi
		pop edi
		pop ebx
		
		vmovd eax,xmm6
		
		vzeroupper
		
		ret
		
processLine0_AVX2_ASM_16 endp


processLine0_AVX2_ASM_32 proc tempu:dword,width_:dword,dstp:dword,src3p:dword,src_pitch:dword

    public processLine0_AVX2_ASM_32
	
		push ebx
		push edi
		push esi

		mov eax,tempu
		mov ebx,src3p
		mov ecx,width_
		mov edx,src_pitch
		mov esi,dstp
		lea edi,[ebx+edx*4]
		vpxor ymm5,ymm5,ymm5
		vpxor ymm6,ymm6,ymm6		
		
xloop_32:		
		vmovq xmm4,qword ptr [eax]
		vmovaps ymm2,YMMWORD ptr[ebx]		
		vmovaps ymm0,YMMWORD ptr[ebx+edx*2]
		vpunpcklbw xmm4,xmm4,xmm6		
		vmovaps ymm1,YMMWORD ptr[edi]
		vmovaps ymm3,YMMWORD ptr[edi+edx*2]		
		vaddps ymm0,ymm0,ymm1
		vpxor xmm4,xmm4,XMMWORD ptr uw_1		
		vaddps ymm2,ymm2,ymm3		
		vpsadbw xmm4,xmm4,xmm6
		vmulps ymm0,ymm0,YMMWORD ptr f_19
		vmovdqa xmm3,xmm4
		vmulps ymm2,ymm2,YMMWORD ptr f_3
		vpsrldq xmm4,xmm4,8
		vsubps ymm0,ymm0,ymm2	
		vpaddusw xmm4,xmm4,xmm3
		vmovaps YMMWORD ptr[esi],ymm0
		vpaddusw xmm5,xmm5,xmm4
		add ebx,32
		add edi,32
		add eax,8
		add esi,32
		sub ecx,8
		jnz short xloop_32
				
		pop esi
		pop edi
		pop ebx
		
		vmovd eax,xmm5
		
		vzeroupper
		
		ret
		
processLine0_AVX2_ASM_32 endp


uc2f48_AVX2 proc ptr_t:dword,pitch:dword,ptr_p:dword

    public uc2f48_AVX2

		mov eax,ptr_t
		mov ecx,pitch
		mov edx,ptr_p
		
		vpxor ymm4,ymm4,ymm4
		
		test eax,15
		jnz short unaligned_1
		
		vmovdqa xmm0,XMMWORD PTR[eax]
		vmovdqa xmm2,XMMWORD PTR[eax+ecx*2]	

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
		lea eax,[eax+ecx*4]		
		vcvtdq2ps ymm0,ymm0
		vcvtdq2ps xmm1,xmm1
		vcvtdq2ps ymm2,ymm2
		vcvtdq2ps xmm3,xmm3
		vmovaps XMMWORD ptr[edx],xmm0
		vextractf128 xmm5,ymm0,1
		vmovaps XMMWORD ptr[edx+16],xmm1
		vmovaps XMMWORD ptr[edx+32],xmm5		
		vmovaps XMMWORD ptr[edx+48],xmm2
		vextractf128 xmm5,ymm2,1
		vmovaps XMMWORD ptr[edx+64],xmm3
		vmovaps XMMWORD ptr[edx+80],xmm5
		
		vmovdqa xmm0,XMMWORD PTR[eax]
		vmovdqa xmm2,XMMWORD PTR[eax+ecx*2]
		jmp short suite_1
		
unaligned_1:		
		vmovdqu xmm0,XMMWORD PTR[eax]
		vmovdqu xmm2,XMMWORD PTR[eax+ecx*2]		
		
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
		lea eax,[eax+ecx*4]		
		vcvtdq2ps ymm0,ymm0
		vcvtdq2ps xmm1,xmm1
		vcvtdq2ps ymm2,ymm2
		vcvtdq2ps xmm3,xmm3
		vmovaps XMMWORD ptr[edx],xmm0
		vextractf128 xmm5,ymm0,1
		vmovaps XMMWORD ptr[edx+16],xmm1
		vmovaps XMMWORD ptr[edx+32],xmm5		
		vmovaps XMMWORD ptr[edx+48],xmm2
		vextractf128 xmm5,ymm2,1
		vmovaps XMMWORD ptr[edx+64],xmm3
		vmovaps XMMWORD ptr[edx+80],xmm5
		
		vmovdqu xmm0,XMMWORD PTR[eax]
		vmovdqu xmm2,XMMWORD PTR[eax+ecx*2]				
		
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
		vmovaps XMMWORD ptr[edx+96],xmm0
		vextractf128 xmm5,ymm0,1
		vmovaps XMMWORD ptr[edx+112],xmm1
		vmovaps XMMWORD ptr[edx+128],xmm5		
		vmovaps XMMWORD ptr[edx+144],xmm2
		vextractf128 xmm5,ymm2,1
		vmovaps XMMWORD ptr[edx+160],xmm3
		vmovaps XMMWORD ptr[edx+176],xmm5
		
		vzeroupper
		
		ret
		
uc2f48_AVX2 endp


uc2f48_AVX2_16 proc ptr_t:dword,pitch:dword,ptr_p:dword

    public uc2f48_AVX2_16

		mov eax,ptr_t
		mov ecx,pitch
		mov edx,ptr_p
		vpxor ymm4,ymm4,ymm4
		
		test eax,31
		jnz short unaligned_2
		
		vmovdqa ymm1,YMMWORD ptr[eax]
		vmovdqa ymm3,YMMWORD ptr[eax+ecx*2]
		vpunpcklwd ymm0,ymm1,ymm4
		vpunpcklwd ymm2,ymm3,ymm4
		vpunpckhwd ymm1,ymm1,ymm4
		vpunpckhwd ymm3,ymm3,ymm4		
		lea eax,[eax+ecx*4]		
		vcvtdq2ps ymm0,ymm0
		vcvtdq2ps xmm1,xmm1
		vcvtdq2ps ymm2,ymm2
		vcvtdq2ps xmm3,xmm3
		vmovaps XMMWORD ptr[edx],xmm0
		vextractf128 xmm5,ymm0,1
		vmovaps XMMWORD ptr[edx+16],xmm1
		vmovaps XMMWORD ptr[edx+32],xmm5		
		vmovaps XMMWORD ptr[edx+48],xmm2
		vextractf128 xmm5,ymm2,1
		vmovaps XMMWORD ptr[edx+64],xmm3
		vmovaps XMMWORD ptr[edx+80],xmm5
		
		vmovdqa ymm1,YMMWORD ptr[eax]
		vmovdqa ymm3,YMMWORD ptr[eax+ecx*2]
		jmp short suite_2

unaligned_2:
		vmovdqu ymm1,YMMWORD ptr[eax]
		vmovdqu ymm3,YMMWORD ptr[eax+ecx*2]
		vpunpcklwd ymm0,ymm1,ymm4
		vpunpcklwd ymm2,ymm3,ymm4
		vpunpckhwd ymm1,ymm1,ymm4
		vpunpckhwd ymm3,ymm3,ymm4		
		lea eax,[eax+ecx*4]		
		vcvtdq2ps ymm0,ymm0
		vcvtdq2ps xmm1,xmm1
		vcvtdq2ps ymm2,ymm2
		vcvtdq2ps xmm3,xmm3
		vmovaps XMMWORD ptr[edx],xmm0
		vextractf128 xmm5,ymm0,1
		vmovaps XMMWORD ptr[edx+16],xmm1
		vmovaps XMMWORD ptr[edx+32],xmm5		
		vmovaps XMMWORD ptr[edx+48],xmm2
		vextractf128 xmm5,ymm2,1
		vmovaps XMMWORD ptr[edx+64],xmm3
		vmovaps XMMWORD ptr[edx+80],xmm5
		
		vmovdqu ymm1,YMMWORD ptr[eax]
		vmovdqu ymm3,YMMWORD ptr[eax+ecx*2]
		
suite_2:
		vpunpcklwd ymm0,ymm1,ymm4
		vpunpcklwd ymm2,ymm3,ymm4
		vpunpckhwd ymm1,ymm1,ymm4
		vpunpckhwd ymm3,ymm3,ymm4		
		vcvtdq2ps ymm0,ymm0
		vcvtdq2ps xmm1,xmm1
		vcvtdq2ps ymm2,ymm2
		vcvtdq2ps xmm3,xmm3
		vmovaps XMMWORD ptr[edx+96],xmm0
		vextractf128 xmm5,ymm0,1
		vmovaps XMMWORD ptr[edx+112],xmm1
		vmovaps XMMWORD ptr[edx+128],xmm5		
		vmovaps XMMWORD ptr[edx+144],xmm2
		vextractf128 xmm5,ymm2,1
		vmovaps XMMWORD ptr[edx+160],xmm3
		vmovaps XMMWORD ptr[edx+176],xmm5

		vzeroupper
		
		ret
		
uc2f48_AVX2_16 endp


uc2s48_AVX2 proc ptr_t:dword,pitch:dword,ptr_pf:dword

    public uc2s48_AVX2

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
		vmovdqa XMMWORD ptr[edx],xmm0
		vmovdqa XMMWORD ptr[edx+16],xmm1
		vmovdqa XMMWORD ptr[edx+32],xmm3
		vmovdqa XMMWORD ptr[edx+48],xmm4
		vmovdqa XMMWORD ptr[edx+64],xmm5
		vmovdqa XMMWORD ptr [edx+80],xmm7
		
		vzeroupper
		
		ret

uc2s48_AVX2 endp


uc2s64_AVX2 proc ptr_t:dword,pitch:dword,ptr_p:dword

	public uc2s64_AVX2
	
		mov eax,ptr_t
		mov ecx,pitch
		lea edx,[eax+ecx*4]
		vpxor ymm4,ymm4,ymm4
		
		test eax,15
		jnz short unaligned_3
		
		vmovdqa xmm0,XMMWORD ptr[eax]
		vmovdqa xmm1,XMMWORD PTR[eax+ecx*2]
		vmovdqa xmm2,XMMWORD ptr[edx]
		vmovdqa xmm3,XMMWORD PTR[edx+ecx*2]
		jmp short suite_3

unaligned_3:		
		vmovdqu xmm0,XMMWORD ptr[eax]
		vmovdqu xmm1,XMMWORD PTR[eax+ecx*2]
		vmovdqu xmm2,XMMWORD ptr[edx]
		vmovdqu xmm3,XMMWORD PTR[edx+ecx*2]
		
suite_3:		
		vmovhlps xmm5,xmm4,xmm0
		vmovhlps xmm6,xmm4,xmm1
		vinserti128 ymm0,ymm0,xmm5,1
		vinserti128 ymm1,ymm1,xmm6,1
		vmovhlps xmm5,xmm4,xmm2
		vmovhlps xmm6,xmm4,xmm3
		vinserti128 ymm2,ymm2,xmm5,1
		vinserti128 ymm3,ymm3,xmm6,1

		vpunpcklbw ymm0,ymm0,ymm4
		vpunpcklbw ymm1,ymm1,ymm4
		mov edx,ptr_p
		vpunpcklbw ymm2,ymm2,ymm4
		vpunpcklbw ymm3,ymm3,ymm4
		vmovdqa YMMWORD ptr [edx],ymm0
		vmovdqa YMMWORD ptr [edx+32],ymm1
		vmovdqa YMMWORD ptr [edx+64],ymm2
		vmovdqa YMMWORD ptr [edx+96],ymm3
		
		vzeroupper
		
		ret
		
uc2s64_AVX2 endp


computeNetwork0_FMA3 proc input:dword,weights:dword,ptr_d:dword

    public computeNetwork0_FMA3
;//    dotProd48_m4_SSE(input,weights,temp,4);	
		mov ecx,input
		mov edx,weights
		mov eax,1
		
		vmovaps ymm4,YMMWORD ptr [ecx]
		vmulps ymm0,ymm4,YMMWORD ptr [edx]
		vmulps ymm1,ymm4,YMMWORD ptr [edx+32]
		vmulps ymm2,ymm4,YMMWORD ptr [edx+64]
		vmulps ymm3,ymm4,YMMWORD ptr [edx+96]
		
		vmovaps ymm4,YMMWORD ptr [ecx+32]

		vfmadd231ps ymm0,ymm4,YMMWORD ptr [edx+128]
		vfmadd231ps ymm1,ymm4,YMMWORD ptr [edx+160]
		vfmadd231ps ymm2,ymm4,YMMWORD ptr [edx+192]
		vfmadd231ps ymm3,ymm4,YMMWORD ptr [edx+224]
	
		vmovaps ymm4,YMMWORD ptr [ecx+64]
		
		vfmadd231ps ymm0,ymm4,YMMWORD ptr [edx+256]
		vfmadd231ps ymm1,ymm4,YMMWORD ptr [edx+288]
		vfmadd231ps ymm2,ymm4,YMMWORD ptr [edx+320]
		vfmadd231ps ymm3,ymm4,YMMWORD ptr [edx+352]
		
		vmovaps ymm4,YMMWORD ptr [ecx+96]
		
		vfmadd231ps ymm0,ymm4,YMMWORD ptr [edx+384]
		vfmadd231ps ymm1,ymm4,YMMWORD ptr [edx+416]
		vfmadd231ps ymm2,ymm4,YMMWORD ptr [edx+448]
		vfmadd231ps ymm3,ymm4,YMMWORD ptr [edx+480]
		
		vmovaps ymm4,YMMWORD ptr [ecx+128]
		
		vfmadd231ps ymm0,ymm4,YMMWORD ptr [edx+512]
		vfmadd231ps ymm1,ymm4,YMMWORD ptr [edx+544]
		vfmadd231ps ymm2,ymm4,YMMWORD ptr [edx+576]
		vfmadd231ps ymm3,ymm4,YMMWORD ptr [edx+608]
		
		vmovaps ymm4,YMMWORD ptr [ecx+160]
		
		vfmadd231ps ymm0,ymm4,YMMWORD ptr [edx+640]
		vfmadd231ps ymm1,ymm4,YMMWORD ptr [edx+672]
		vfmadd231ps ymm2,ymm4,YMMWORD ptr [edx+704]
		vfmadd231ps ymm3,ymm4,YMMWORD ptr [edx+736]
		
		
   ; This block performs a horizontal sum of each accumulator (m0..m3) and packs the results in m0 (sum(m3) sum(m2) sum(m1) sum(m0)).
   ; Sadly replacing the twelve instructions with three haddps makes no difference whatsoever on this Core 2 Duo.
		
		vhaddps ymm0,ymm0,ymm1
		vhaddps ymm2,ymm2,ymm3
		vhaddps ymm0,ymm0,ymm2
		
		vextractf128 xmm4,ymm0,1
		vaddps xmm0,xmm0,xmm4
		
		vaddps xmm0,xmm0,XMMWORD ptr [edx+768]
   ;// const float t = temp[0];
   ;// elliott4_SSE(temp);
   ;// temp[0] = t;
		vmovaps xmm1,xmm0
		vandps xmm0,xmm0,XMMWORD ptr sign_bits_f_zero_l
		vaddps xmm0,xmm0,XMMWORD ptr ones_f
		vrcpps xmm0,xmm0
		vmulps xmm0,xmm0,xmm1
		
;//    dotProd4_m4_SSE2(temp,weights+4*49,temp+4,4);		
		vpshufd xmm1,xmm0,0
		vpshufd xmm2,xmm0,85
		vpshufd xmm3,xmm0,170
		vpshufd xmm4,xmm0,255
		
		vmulps xmm1,xmm1,XMMWORD ptr [edx+784]
		vfmadd231ps xmm1,xmm2,XMMWORD ptr [edx+784+16]
		vmulps xmm3,xmm3,XMMWORD ptr [edx+784+32]
		vfmadd231ps xmm3,xmm4,XMMWORD ptr [edx+784+48]
		vaddps xmm1,xmm1,xmm3
		vaddps xmm1,xmm1,XMMWORD ptr [edx+784+64]
		;// elliott4_SSE(temp+4);
		vmovaps xmm7,xmm1
		vandps xmm1,xmm1, XMMWORD ptr sign_bits_f
		vmovaps xmm3,xmm0
		vaddps xmm1,xmm1,XMMWORD ptr ones_f
		vrcpps xmm1,xmm1
		vmulps xmm7,xmm7,xmm1
		
		;//    dotProd8_m4_SSE2(temp,weights+4*49+4*5,temp+32,4);
		vpshufd xmm0,xmm0,0
		vpshufd xmm1,xmm3,85
		vpshufd xmm2,xmm3,170
		vpshufd xmm3,xmm3,255
		vmulps xmm0,xmm0,XMMWORD ptr [edx+864]
		vfmadd231ps xmm0,xmm1,XMMWORD ptr [edx+864+16]
		vmulps xmm2,xmm2,XMMWORD ptr [edx+864+32]
		vfmadd231ps xmm2,xmm3,XMMWORD ptr [edx+864+48]
		
		vpshufd xmm4,xmm7,0
		vpshufd xmm5,xmm7,85
		vpshufd xmm6,xmm7,170
		vpshufd xmm7,xmm7,255
		
		vmulps xmm4,xmm4,XMMWORD ptr [edx+864+64]
		vfmadd231ps xmm4,xmm5,XMMWORD ptr [edx+864+80]
		vmulps xmm6,xmm6,XMMWORD ptr [edx+864+96]
		vfmadd231ps xmm6,xmm7,XMMWORD ptr [edx+864+112]
		
		vaddps xmm0,xmm0,xmm2
		vaddps xmm4,xmm4,xmm6
		vaddps xmm0,xmm0,xmm4
		mov ecx,ptr_d
		vaddps xmm0,xmm0,XMMWORD ptr [edx+864+128]
		vmovhlps xmm1,xmm1,xmm0
		vmaxps xmm0,xmm0,xmm1
		vpshuflw xmm1,xmm0,14
		vcomiss xmm1,xmm0
		jbe short finish_1a
		xor eax,eax
finish_1a:
		mov BYTE PTR[ecx],al
		
		vzeroupper
		
		ret

computeNetwork0_FMA3 endp


computeNetwork0_FMA4 proc input:dword,weights:dword,ptr_d:dword

    public computeNetwork0_FMA4
;//    dotProd48_m4_SSE(input,weights,temp,4);	
		mov ecx,input
		mov edx,weights
		mov eax,1
		
		vmovaps ymm4,YMMWORD ptr [ecx]
		vmulps ymm0,ymm4,YMMWORD ptr [edx]
		vmulps ymm1,ymm4,YMMWORD ptr [edx+32]
		vmulps ymm2,ymm4,YMMWORD ptr [edx+64]
		vmulps ymm3,ymm4,YMMWORD ptr [edx+96]
		
		vmovaps ymm4,YMMWORD ptr [ecx+32]
		vfmaddps ymm0,ymm4,[edx+128],ymm0
		vfmaddps ymm1,ymm4,[edx+160],ymm1
		vfmaddps ymm2,ymm4,[edx+192],ymm2
		vfmaddps ymm3,ymm4,[edx+224],ymm3
		
		vmovaps ymm4,YMMWORD ptr [ecx+64]
		vfmaddps ymm0,ymm4,YMMWORD ptr [edx+256],ymm0
		vfmaddps ymm1,ymm4,YMMWORD ptr [edx+288],ymm1
		vfmaddps ymm2,ymm4,YMMWORD ptr [edx+320],ymm2
		vfmaddps ymm3,ymm4,YMMWORD ptr [edx+352],ymm3
		
		vmovaps ymm4,YMMWORD ptr [ecx+96]	
		vfmaddps ymm0,ymm4,YMMWORD ptr [edx+384],ymm0
		vfmaddps ymm1,ymm4,YMMWORD ptr [edx+416],ymm1
		vfmaddps ymm2,ymm4,YMMWORD ptr [edx+448],ymm2
		vfmaddps ymm3,ymm4,YMMWORD ptr [edx+480],ymm3
		
		vmovaps ymm4,YMMWORD ptr [ecx+128]		
		vfmaddps ymm0,ymm4,YMMWORD ptr [edx+512],ymm0
		vfmaddps ymm1,ymm4,YMMWORD ptr [edx+544],ymm1
		vfmaddps ymm2,ymm4,YMMWORD ptr [edx+576],ymm2
		vfmaddps ymm3,ymm4,YMMWORD ptr [edx+608],ymm3
		
		vmovaps ymm4,YMMWORD ptr [ecx+160]		
		vfmaddps ymm0,ymm4,YMMWORD ptr [edx+320],ymm0
		vfmaddps ymm1,ymm4,YMMWORD ptr [edx+336],ymm1
		vfmaddps ymm2,ymm4,YMMWORD ptr [edx+352],ymm2
		vfmaddps ymm3,ymm4,YMMWORD ptr [edx+368],ymm3
				
   ; This block performs a horizontal sum of each accumulator (m0..m3) and packs the results in m0 (sum(m3) sum(m2) sum(m1) sum(m0)).
   ; Sadly replacing the twelve instructions with three haddps makes no difference whatsoever on this Core 2 Duo.
		vhaddps ymm0,ymm0,ymm1
		vhaddps ymm2,ymm2,ymm3
		vhaddps ymm0,ymm0,ymm2
		
		vextractf128 xmm4,ymm0,1
		vaddps xmm0,xmm0,xmm4
		
		vaddps xmm0,xmm0,XMMWORD ptr [edx+768]
   ;// const float t = temp[0];
   ;// elliott4_SSE(temp);
   ;// temp[0] = t;
		vmovaps xmm1,xmm0
		vandps xmm0,xmm0,XMMWORD ptr sign_bits_f_zero_l
		vaddps xmm0,xmm0,XMMWORD ptr ones_f
		vrcpps xmm0,xmm0
		vmulps xmm0,xmm0,xmm1
		
;//    dotProd4_m4_SSE2(temp,weights+4*49,temp+4,4);		
		vpshufd xmm1,xmm0,0
		vpshufd xmm2,xmm0,85
		vpshufd xmm3,xmm0,170
		vpshufd xmm4,xmm0,255
		
		vmulps xmm1,xmm1,XMMWORD ptr [edx+784]
		vfmaddps xmm1,xmm2,XMMWORD ptr [edx+784+16],xmm1
		vmulps xmm3,xmm3,XMMWORD ptr [edx+784+32]
		vfmaddps xmm3,xmm4,XMMWORD ptr [edx+784+48],xmm3
		vaddps xmm1,xmm1,xmm3
		vaddps xmm1,xmm1,XMMWORD ptr [edx+784+64]
		;// elliott4_SSE(temp+4);
		vmovaps xmm7,xmm1
		vandps xmm1,xmm1, XMMWORD ptr sign_bits_f
		vmovaps xmm3,xmm0
		vaddps xmm1,xmm1,XMMWORD ptr ones_f
		vrcpps xmm1,xmm1
		vmulps xmm7,xmm7,xmm1		
		;//    dotProd8_m4_SSE2(temp,weights+4*49+4*5,temp+32,4);
		vpshufd xmm0,xmm0,0
		vpshufd xmm1,xmm3,85
		vpshufd xmm2,xmm3,170
		vpshufd xmm3,xmm3,255
		vmulps xmm0,xmm0,XMMWORD ptr [edx+864]
		vfmaddps xmm0,xmm1,XMMWORD ptr [edx+864+16],xmm0
		vmulps xmm2,xmm2,XMMWORD ptr [edx+864+32]
		vfmaddps xmm2,xmm3,XMMWORD ptr [edx+864+48],xmm2
		
		vpshufd xmm4,xmm7,0
		vpshufd xmm5,xmm7,85
		vpshufd xmm6,xmm7,170
		vpshufd xmm7,xmm7,255
		
		vmulps xmm4,xmm4,XMMWORD ptr [edx+864+64]
		vfmaddps xmm4,xmm5,XMMWORD ptr [edx+864+80],xmm4
		vmulps xmm6,xmm6,XMMWORD ptr [edx+864+96]
		vfmaddps xmm6,xmm7,XMMWORD ptr [edx+864+112],xmm6
		
		vaddps xmm0,xmm0,xmm2
		vaddps xmm4,xmm4,xmm6
		vaddps xmm0,xmm0,xmm4
		
		mov ecx,ptr_d
		vaddps xmm0,xmm0,XMMWORD ptr [edx+864+128]
		vmovhlps xmm1,xmm1,xmm0
		vmaxps xmm0,xmm0,xmm1
		vpshuflw xmm1,xmm0,14
		vcomiss xmm1,xmm0
		jbe short finish_1b
		xor eax,eax
finish_1b:
		mov BYTE PTR[ecx],al
		
		vzeroupper
		
		ret

computeNetwork0_FMA4 endp


weightedAvgElliottMul5_m16_AVX2 proc ptr_w:dword,n:dword,mstd:dword

	public weightedAvgElliottMul5_m16_AVX2

		push edi
		
		mov eax,ptr_w
		mov ecx,n
		lea edx,[eax+ecx*4]
		xor edi,edi
		
		vxorps ymm0,ymm0,ymm0
		vxorps ymm1,ymm1,ymm1
		
nloop_5:
		vmovaps ymm2,YMMWORD ptr [eax+edi*4]
		vmovaps ymm4,YMMWORD ptr [edx+edi*4]
		vaddps ymm0,ymm0,ymm2
		vandps ymm5,ymm4,YMMWORD ptr sign_bits_f_32
		vaddps ymm5,ymm5,YMMWORD ptr ones_f_32
		vrcpps ymm5,ymm5
		vmulps ymm4,ymm4,ymm5
		vmulps ymm4,ymm4,ymm2
		vaddps ymm1,ymm1,ymm4
		
		vmovaps ymm2,YMMWORD ptr [eax+edi*4+32]
		vmovaps ymm4,YMMWORD ptr [edx+edi*4+32]
		vaddps ymm0,ymm0,ymm2
		vandps ymm5,ymm4,YMMWORD ptr sign_bits_f_32
		vaddps ymm5,ymm5,YMMWORD ptr ones_f_32
		vrcpps ymm5,ymm5
		vmulps ymm4,ymm4,ymm5
		vmulps ymm4,ymm4,ymm2
		vaddps ymm1,ymm1,ymm4

		add edi,16
		sub ecx,16
		jnz short nloop_5
		
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
		jbe short nodiv
		vmulss xmm1,xmm1,dword ptr five_f
		vrcpss xmm0,xmm0,xmm0
		vmulss xmm1,xmm1,xmm0
		jmp short finish_5
nodiv:
		vxorps xmm1,xmm1,xmm1
finish_5:
		mov eax,mstd
		vmulss xmm1,xmm1,dword ptr[eax+4]
		vaddss xmm1,xmm1,dword ptr[eax]
		vaddss xmm1,xmm1,dword ptr[eax+12]
		vmovss dword ptr[eax+12],xmm1
		
		vzeroupper
		
		pop edi
		
		ret
		
weightedAvgElliottMul5_m16_AVX2 endp


weightedAvgElliottMul5_m16_FMA3 proc ptr_w:dword,n:dword,mstd:dword

	public weightedAvgElliottMul5_m16_FMA3

		push edi
		
		mov eax,ptr_w
		mov ecx,n
		lea edx,[eax+ecx*4]
		xor edi,edi
		
		vxorps ymm0,ymm0,ymm0
		vxorps ymm1,ymm1,ymm1
		
nloop_52:
		vmovaps ymm2,YMMWORD ptr [eax+edi*4]
		vmovaps ymm4,YMMWORD ptr [edx+edi*4]
		vaddps ymm0,ymm0,ymm2
		vandps ymm5,ymm4,YMMWORD ptr sign_bits_f_32
		vaddps ymm5,ymm5,YMMWORD ptr ones_f_32
		vrcpps ymm5,ymm5
		vmulps ymm4,ymm4,ymm5
		vfmadd231ps ymm1,ymm2,ymm4
		
		vmovaps ymm2,YMMWORD ptr [eax+edi*4+32]
		vmovaps ymm4,YMMWORD ptr [edx+edi*4+32]
		vaddps ymm0,ymm0,ymm2
		vandps ymm5,ymm4,YMMWORD ptr sign_bits_f_32
		vaddps ymm5,ymm5,YMMWORD ptr ones_f_32
		vrcpps ymm5,ymm5
		vmulps ymm4,ymm4,ymm5
		vfmadd231ps ymm1,ymm2,ymm4

		add edi,16
		sub ecx,16
		jnz short nloop_52
		
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
		jbe short nodiv2
		vmulss xmm1,xmm1,dword ptr five_f
		vrcpss xmm0,xmm0,xmm0
		vmulss xmm1,xmm1,xmm0
		jmp short finish_52
nodiv2:
		vxorps xmm1,xmm1,xmm1
finish_52:
		mov eax,mstd
		vmulss xmm1,xmm1,dword ptr[eax+4]
		vaddss xmm1,xmm1,dword ptr[eax]
		vaddss xmm1,xmm1,dword ptr[eax+12]
		vmovss dword ptr[eax+12],xmm1
		
		vzeroupper
		
		pop edi
		
		ret
		
weightedAvgElliottMul5_m16_FMA3 endp


weightedAvgElliottMul5_m16_FMA4 proc ptr_w:dword,n:dword,mstd:dword

	public weightedAvgElliottMul5_m16_FMA4

		push edi
		
		mov eax,ptr_w
		mov ecx,n
		lea edx,[eax+ecx*4]
		xor edi,edi
		
		vxorps ymm0,ymm0,ymm0
		vxorps ymm1,ymm1,ymm1
		
nloop_53:
		vmovaps ymm2,YMMWORD ptr [eax+edi*4]
		vmovaps ymm4,YMMWORD ptr [edx+edi*4]
		vaddps ymm0,ymm0,ymm2
		vandps ymm5,ymm4,YMMWORD ptr sign_bits_f_32
		vaddps ymm5,ymm5,YMMWORD ptr ones_f_32
		vrcpps ymm5,ymm5
		vmulps ymm4,ymm4,ymm5
		vfmaddps ymm1,ymm2,ymm4,ymm1
		
		vmovaps ymm2,YMMWORD ptr [eax+edi*4+32]
		vmovaps ymm4,YMMWORD ptr [edx+edi*4+32]
		vaddps ymm0,ymm0,ymm2
		vandps ymm5,ymm4,YMMWORD ptr sign_bits_f_32
		vaddps ymm5,ymm5,YMMWORD ptr ones_f_32
		vrcpps ymm5,ymm5
		vmulps ymm4,ymm4,ymm5
		vfmaddps ymm1,ymm2,ymm4,ymm1

		add edi,16
		sub ecx,16
		jnz short nloop_53
		
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
		jbe short nodiv3
		vmulss xmm1,xmm1,dword ptr five_f
		vrcpss xmm0,xmm0,xmm0
		vmulss xmm1,xmm1,xmm0
		jmp short finish_53
nodiv3:
		vxorps xmm1,xmm1,xmm1
finish_53:
		mov eax,mstd
		vmulss xmm1,xmm1,dword ptr[eax+4]
		vaddss xmm1,xmm1,dword ptr[eax]
		vaddss xmm1,xmm1,dword ptr[eax+12]
		vmovss dword ptr[eax+12],xmm1
		
		vzeroupper
		
		pop edi
		
		ret
		
weightedAvgElliottMul5_m16_FMA4 endp


extract_m8_i16_AVX2 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,inputf:dword

	public extract_m8_i16_AVX2
	
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
		
		vpxor ymm4,ymm4,ymm4
		vpxor ymm5,ymm5,ymm5
		vpxor ymm6,ymm6,ymm6
		
		cmp edi,8
		jg short suite_0
		
yloop_:
		vmovq xmm2,QWORD PTR[eax]
		vmovq xmm3,QWORD PTR[esi]
		vpunpcklbw xmm0,xmm2,xmm6
		vpunpcklbw xmm1,xmm3,xmm6
		vpsadbw xmm2,xmm2,xmm6
		vpsadbw xmm3,xmm3,xmm6
		vmovdqa XMMWORD ptr [edx],xmm0
		vmovdqa XMMWORD ptr [edx+edi*2],xmm1
		vpmaddwd xmm0,xmm0,xmm0
		vpmaddwd xmm1,xmm1,xmm1
		vpaddd xmm4,xmm4,xmm2
		vpaddd xmm5,xmm5,xmm0
		vpaddd xmm4,xmm4,xmm3
		vpaddd xmm5,xmm5,xmm1
		add edx,16
		lea eax,[eax+ebx*4]
		lea esi,[esi+ebx*4]
		lea edx,[edx+edi*2]
		sub ydia_,2
		jnz short yloop_
		jmp suite0
		
suite_0:		
		test eax,15
		jnz short yloop__
		
yloop:
		xor ecx,ecx			
xloop_2:
		vmovdqa xmm2,XMMWORD PTR[eax+ecx]
		vmovdqa xmm3,XMMWORD PTR[esi+ecx]
		vmovhlps xmm0,xmm6,xmm2
		vmovhlps xmm1,xmm6,xmm3
		vinserti128 ymm2,ymm2,xmm0,1
		vinserti128 ymm3,ymm3,xmm1,1				
		vpunpcklbw ymm0,ymm2,ymm6
		vpunpcklbw ymm1,ymm3,ymm6
		vpsadbw xmm2,xmm2,xmm6
		vpsadbw xmm3,xmm3,xmm6
		vmovdqa YMMWORD PTR[edx],ymm0
		vmovdqa YMMWORD PTR[edx+edi*2],ymm1
		vpmaddwd ymm0,ymm0,ymm0
		vpmaddwd ymm1,ymm1,ymm1
		vpaddd xmm4,xmm4,xmm2
		vpaddd ymm5,ymm5,ymm0
		vpaddd xmm4,xmm4,xmm3
		vpaddd ymm5,ymm5,ymm1
		add ecx,16
		add edx,32
		cmp ecx,edi
		jl short xloop_2
		lea eax,[eax+ebx*4]
		lea esi,[esi+ebx*4]
		lea edx,[edx+edi*2]
		sub ydia_,2
		jnz short yloop
		
		vmovhlps xmm1,xmm1,xmm4
		vextracti128 xmm2,ymm5,1
		vpaddd xmm4,xmm4,xmm1
		vpaddd xmm5,xmm5,xmm2
		
		jmp short suite0
		
yloop__:
		xor ecx,ecx			
xloop_2_:
		vmovdqu xmm2,XMMWORD PTR[eax+ecx]
		vmovdqu xmm3,XMMWORD PTR[esi+ecx]
		vmovhlps xmm0,xmm6,xmm2
		vmovhlps xmm1,xmm6,xmm3
		vinserti128 ymm2,ymm2,xmm0,1
		vinserti128 ymm3,ymm3,xmm1,1						
		vpunpcklbw ymm0,ymm2,ymm6
		vpunpcklbw ymm1,ymm3,ymm6
		vpsadbw xmm2,xmm2,xmm6
		vpsadbw xmm3,xmm3,xmm6
		vmovdqa YMMWORD PTR[edx],ymm0
		vmovdqa YMMWORD PTR[edx+edi*2],ymm1
		vpmaddwd ymm0,ymm0,ymm0
		vpmaddwd ymm1,ymm1,ymm1
		vpaddd xmm4,xmm4,xmm2
		vpaddd ymm5,ymm5,ymm0
		vpaddd xmm4,xmm4,xmm3
		vpaddd ymm5,ymm5,ymm1
		add ecx,16
		add edx,32
		cmp ecx,edi
		jl short xloop_2_
		lea eax,[eax+ebx*4]
		lea esi,[esi+ebx*4]
		lea edx,[edx+edi*2]
		sub ydia_,2
		jnz short yloop__
		
		vmovhlps xmm1,xmm1,xmm4
		vextracti128 xmm2,ymm5,1
		vpaddd xmm4,xmm4,xmm1
		vpaddd xmm5,xmm5,xmm2
		
suite0:				
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
		jbe short novarjmp_2
		vrsqrtss xmm5,xmm5,xmm5
		vrcpss xmm4,xmm4,xmm5
		vmovss dword ptr[eax+4],xmm4
		vmovss dword ptr[eax+8],xmm5
		jmp short finish_4
novarjmp_2:
		vmovss dword ptr[eax+4],xmm6
		vmovss dword ptr[eax+8],xmm6
finish_4:
		vmovss dword ptr[eax+12],xmm6
		
		vzeroupper
		
		pop esi
		pop edi
		pop ebx
		
		ret
		
extract_m8_i16_AVX2 endp


extract_m8_AVX2 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,input:dword

	public extract_m8_AVX2
	
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
		vpxor ymm5,ymm5,ymm5
		vpxor ymm6,ymm6,ymm6
		vpxor ymm4,ymm4,ymm4
				
yloop2:
		xor ecx,ecx
xloop2:				
		vmovq xmm0,QWORD PTR[eax+ecx]
		vmovq xmm2,QWORD PTR[edx+ecx]
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
		vmovaps YMMWORD PTR[esi],ymm0
		vmovaps YMMWORD PTR[esi+edi*4],ymm2
		vaddps ymm5,ymm5,ymm0
		vaddps ymm5,ymm5,ymm2
		vmulps ymm0,ymm0,ymm0
		vmulps ymm2,ymm2,ymm2
		vaddps ymm6,ymm6,ymm0
		vaddps ymm6,ymm6,ymm2
		add ecx,8
		add esi,32
		cmp ecx,edi
		jl short xloop2
		lea eax,[eax+ebx*4]
		lea edx,[edx+ebx*4]
		lea esi,[esi+edi*4]
		sub ydia_,2
		jnz short yloop2
		
		vextractf128 xmm0,ymm5,1
		vextractf128 xmm2,ymm6,1
		vaddps xmm5,xmm5,xmm0
		vaddps xmm6,xmm6,xmm2
		
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
		jbe short novarjmp
		vrsqrtss xmm6,xmm6,xmm6
		vrcpss xmm5,xmm5,xmm6
		vmovss dword ptr[eax+4],xmm5
		vmovss dword ptr[eax+8],xmm6
		jmp short finish_3
novarjmp:
		vmovss dword ptr[eax+4],xmm4
		vmovss dword ptr[eax+8],xmm4
finish_3:
		vmovss dword ptr[eax+12],xmm4
		
		vzeroupper
		
		pop esi
		pop edi
		pop ebx
		
		ret
		
extract_m8_AVX2 endp


extract_m8_FMA3 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,input:dword

	public extract_m8_FMA3
	
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
		vpxor ymm5,ymm5,ymm5
		vpxor ymm6,ymm6,ymm6
		vpxor ymm4,ymm4,ymm4
				
yloop2a:
		xor ecx,ecx
xloop2a:				
		vmovq xmm0,QWORD PTR[eax+ecx]
		vmovq xmm2,QWORD PTR[edx+ecx]
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
		vmovaps YMMWORD PTR[esi],ymm0
		vmovaps YMMWORD PTR[esi+edi*4],ymm2
		vaddps ymm5,ymm5,ymm0
		vaddps ymm5,ymm5,ymm2
		vfmadd231ps ymm6,ymm0,ymm0
		vfmadd231ps ymm6,ymm2,ymm2
		add ecx,8
		add esi,32
		cmp ecx,edi
		jl short xloop2a
		lea eax,[eax+ebx*4]
		lea edx,[edx+ebx*4]
		lea esi,[esi+edi*4]
		sub ydia_,2
		jnz short yloop2a
		
		vextractf128 xmm0,ymm5,1
		vextractf128 xmm2,ymm6,1
		vaddps xmm5,xmm5,xmm0
		vaddps xmm6,xmm6,xmm2
		
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
		jbe short novarjmpa
		vrsqrtss xmm6,xmm6,xmm6
		vrcpss xmm5,xmm5,xmm6
		vmovss dword ptr[eax+4],xmm5
		vmovss dword ptr[eax+8],xmm6
		jmp short finish_3a
novarjmpa:
		vmovss dword ptr[eax+4],xmm4
		vmovss dword ptr[eax+8],xmm4
finish_3a:
		vmovss dword ptr[eax+12],xmm4
		
		vzeroupper
		
		pop esi
		pop edi
		pop ebx
		
		ret
		
extract_m8_FMA3 endp


extract_m8_FMA4 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,input:dword

	public extract_m8_FMA4
	
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
		vpxor ymm5,ymm5,ymm5
		vpxor ymm6,ymm6,ymm6
		vpxor ymm4,ymm4,ymm4
				
yloop2b:
		xor ecx,ecx
xloop2b:				
		vmovq xmm0,QWORD PTR[eax+ecx]
		vmovq xmm2,QWORD PTR[edx+ecx]
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
		vmovaps YMMWORD PTR[esi],ymm0
		vmovaps YMMWORD PTR[esi+edi*4],ymm2
		vaddps ymm5,ymm5,ymm0
		vaddps ymm5,ymm5,ymm2
		vfmaddps ymm6,ymm0,ymm0,ymm6
		vfmaddps ymm6,ymm2,ymm2,ymm6
		add ecx,8
		add esi,32
		cmp ecx,edi
		jl short xloop2b
		lea eax,[eax+ebx*4]
		lea edx,[edx+ebx*4]
		lea esi,[esi+edi*4]
		sub ydia_,2
		jnz short yloop2b
		
		vextractf128 xmm0,ymm5,1
		vextractf128 xmm2,ymm6,1
		vaddps xmm5,xmm5,xmm0
		vaddps xmm6,xmm6,xmm2
		
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
		jbe short novarjmpb
		vrsqrtss xmm6,xmm6,xmm6
		vrcpss xmm5,xmm5,xmm6
		vmovss dword ptr[eax+4],xmm5
		vmovss dword ptr[eax+8],xmm6
		jmp short finish_3b
novarjmpb:
		vmovss dword ptr[eax+4],xmm4
		vmovss dword ptr[eax+8],xmm4
finish_3b:
		vmovss dword ptr[eax+12],xmm4
		
		vzeroupper
		
		pop esi
		pop edi
		pop ebx
		
		ret
		
extract_m8_FMA4 endp


extract_m8_AVX2_16 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,input:dword

	public extract_m8_AVX2_16
	
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
		vpxor ymm5,ymm5,ymm5
		vpxor ymm6,ymm6,ymm6
		vpxor ymm4,ymm4,ymm4
		
		test eax,15
		jnz short yloop2_16_		
		
yloop2_16:
		xor ecx,ecx
xloop2_16:
		vmovdqa xmm0,XMMWORD PTR[eax+2*ecx]
		vmovdqa xmm2,XMMWORD PTR[edx+2*ecx]
		vmovhlps xmm1,xmm4,xmm0
		vmovhlps xmm3,xmm4,xmm2
		vinserti128 ymm0,ymm0,xmm1,1
		vinserti128 ymm2,ymm2,xmm3,1				
		vpunpcklwd ymm0,ymm0,ymm4
		vpunpcklwd ymm2,ymm2,ymm4
		vcvtdq2ps ymm0,ymm0
		vcvtdq2ps ymm2,ymm2
		vmovaps YMMWORD PTR[esi],ymm0
		vmovaps YMMWORD PTR[esi+edi*4],ymm2
		vaddps ymm5,ymm5,ymm0
		vaddps ymm5,ymm5,ymm2
		vmulps ymm0,ymm0,ymm0
		vmulps ymm2,ymm2,ymm2
		vaddps ymm6,ymm6,ymm0
		vaddps ymm6,ymm6,ymm2
		add ecx,8
		add esi,32
		cmp ecx,edi
		jl short xloop2_16
		lea eax,[eax+ebx*4]
		lea edx,[edx+ebx*4]
		lea esi,[esi+edi*4]
		sub ydia_,2
		jnz short yloop2_16
		jmp short suite1
		
yloop2_16_:
		xor ecx,ecx
xloop2_16_:
		vmovdqu xmm0,XMMWORD PTR[eax+2*ecx]
		vmovdqu xmm2,XMMWORD PTR[edx+2*ecx]
		vmovhlps xmm1,xmm4,xmm0
		vmovhlps xmm3,xmm4,xmm2
		vinserti128 ymm0,ymm0,xmm1,1
		vinserti128 ymm2,ymm2,xmm3,1						
		vpunpcklwd ymm0,ymm0,ymm4
		vpunpcklwd ymm2,ymm2,ymm4
		vcvtdq2ps ymm0,ymm0
		vcvtdq2ps ymm2,ymm2
		vmovaps YMMWORD PTR[esi],ymm0
		vmovaps YMMWORD PTR[esi+edi*4],ymm2
		vaddps ymm5,ymm5,ymm0
		vaddps ymm5,ymm5,ymm2
		vmulps ymm0,ymm0,ymm0
		vmulps ymm2,ymm2,ymm2
		vaddps ymm6,ymm6,ymm0
		vaddps ymm6,ymm6,ymm2
		add ecx,8
		add esi,32
		cmp ecx,edi
		jl short xloop2_16_
		lea eax,[eax+ebx*4]
		lea edx,[edx+ebx*4]
		lea esi,[esi+edi*4]
		sub ydia_,2
		jnz short yloop2_16_		
		
suite1:		
		vextractf128 xmm0,ymm5,1
		vextractf128 xmm2,ymm6,1
		vaddps xmm5,xmm5,xmm0
		vaddps xmm6,xmm6,xmm2

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
		jbe short novarjmp_16
		vrsqrtss xmm6,xmm6,xmm6
		vrcpss xmm5,xmm5,xmm6
		vmovss dword ptr[eax+4],xmm5
		vmovss dword ptr[eax+8],xmm6
		jmp short finish_3_16
novarjmp_16:
		vmovss dword ptr[eax+4],xmm4
		vmovss dword ptr[eax+8],xmm4
finish_3_16:
		vmovss dword ptr[eax+12],xmm4
		
		vzeroupper
		
		pop esi
		pop edi
		pop ebx
		
		ret
		
extract_m8_AVX2_16 endp


extract_m8_FMA3_16 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,input:dword

	public extract_m8_FMA3_16
	
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
		vpxor ymm5,ymm5,ymm5
		vpxor ymm6,ymm6,ymm6
		vpxor ymm4,ymm4,ymm4
		
		test eax,15
		jnz short yloop2_16a_		
		
yloop2_16a:
		xor ecx,ecx
xloop2_16a:
		vmovdqa xmm0,XMMWORD PTR[eax+2*ecx]
		vmovdqa xmm2,XMMWORD PTR[edx+2*ecx]
		vmovhlps xmm1,xmm4,xmm0
		vmovhlps xmm3,xmm4,xmm2
		vinserti128 ymm0,ymm0,xmm1,1
		vinserti128 ymm2,ymm2,xmm3,1						
		vpunpcklwd ymm0,ymm0,ymm4
		vpunpcklwd ymm2,ymm2,ymm4
		vcvtdq2ps ymm0,ymm0
		vcvtdq2ps ymm2,ymm2
		vmovaps YMMWORD PTR[esi],ymm0
		vmovaps YMMWORD PTR[esi+edi*4],ymm2
		vaddps ymm5,ymm5,ymm0
		vaddps ymm5,ymm5,ymm2
		vfmadd231ps ymm6,ymm0,ymm0
		vfmadd231ps ymm6,ymm2,ymm2
		add ecx,8
		add esi,32
		cmp ecx,edi
		jl short xloop2_16a
		lea eax,[eax+ebx*4]
		lea edx,[edx+ebx*4]
		lea esi,[esi+edi*4]
		sub ydia_,2
		jnz short yloop2_16a
		jmp short suite1a
		
yloop2_16a_:
		xor ecx,ecx
xloop2_16a_:
		vmovdqu xmm0,XMMWORD PTR[eax+2*ecx]
		vmovdqu xmm2,XMMWORD PTR[edx+2*ecx]
		vmovhlps xmm1,xmm4,xmm0
		vmovhlps xmm3,xmm4,xmm2
		vinserti128 ymm0,ymm0,xmm1,1
		vinserti128 ymm2,ymm2,xmm3,1						
		vpunpcklwd ymm0,ymm0,ymm4
		vpunpcklwd ymm2,ymm2,ymm4
		vcvtdq2ps ymm0,ymm0
		vcvtdq2ps ymm2,ymm2
		vmovaps YMMWORD PTR[esi],ymm0
		vmovaps YMMWORD PTR[esi+edi*4],ymm2
		vaddps ymm5,ymm5,ymm0
		vaddps ymm5,ymm5,ymm2
		vfmadd231ps ymm6,ymm0,ymm0
		vfmadd231ps ymm6,ymm2,ymm2
		add ecx,8
		add esi,32
		cmp ecx,edi
		jl short xloop2_16a_
		lea eax,[eax+ebx*4]
		lea edx,[edx+ebx*4]
		lea esi,[esi+edi*4]
		sub ydia_,2
		jnz short yloop2_16a_		
		
suite1a:		
		vextractf128 xmm0,ymm5,1
		vextractf128 xmm2,ymm6,1
		vaddps xmm5,xmm5,xmm0
		vaddps xmm6,xmm6,xmm2

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
		jbe short novarjmp_16a
		vrsqrtss xmm6,xmm6,xmm6
		vrcpss xmm5,xmm5,xmm6
		vmovss dword ptr[eax+4],xmm5
		vmovss dword ptr[eax+8],xmm6
		jmp short finish_3_16a
novarjmp_16a:
		vmovss dword ptr[eax+4],xmm4
		vmovss dword ptr[eax+8],xmm4
finish_3_16a:
		vmovss dword ptr[eax+12],xmm4
		
		vzeroupper
		
		pop esi
		pop edi
		pop ebx
		
		ret
		
extract_m8_FMA3_16 endp


extract_m8_FMA4_16 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,input:dword

	public extract_m8_FMA4_16
	
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
		vpxor ymm5,ymm5,ymm5
		vpxor ymm6,ymm6,ymm6
		vpxor ymm4,ymm4,ymm4
		
		test eax,15
		jnz short yloop2_16b_		
		
yloop2_16b:
		xor ecx,ecx
xloop2_16b:
		vmovdqa xmm0,XMMWORD PTR[eax+2*ecx]
		vmovdqa xmm2,XMMWORD PTR[edx+2*ecx]
		vmovhlps xmm1,xmm4,xmm0
		vmovhlps xmm3,xmm4,xmm2
		vinserti128 ymm0,ymm0,xmm1,1
		vinserti128 ymm2,ymm2,xmm3,1						
		vpunpcklwd ymm0,ymm0,ymm4
		vpunpcklwd ymm2,ymm2,ymm4
		vcvtdq2ps ymm0,ymm0
		vcvtdq2ps ymm2,ymm2
		vmovaps YMMWORD PTR[esi],ymm0
		vmovaps YMMWORD PTR[esi+edi*4],ymm2
		vaddps ymm5,ymm5,ymm0
		vaddps ymm5,ymm5,ymm2
		vfmaddps ymm6,ymm0,ymm0,ymm6
		vfmaddps ymm6,ymm2,ymm2,ymm6
		add ecx,8
		add esi,32
		cmp ecx,edi
		jl short xloop2_16b
		lea eax,[eax+ebx*4]
		lea edx,[edx+ebx*4]
		lea esi,[esi+edi*4]
		sub ydia_,2
		jnz short yloop2_16b
		jmp short suite1b
		
yloop2_16b_:
		xor ecx,ecx
xloop2_16b_:
		vmovdqu xmm0,XMMWORD PTR[eax+2*ecx]
		vmovdqu xmm2,XMMWORD PTR[edx+2*ecx]
		vmovhlps xmm1,xmm4,xmm0
		vmovhlps xmm3,xmm4,xmm2
		vinserti128 ymm0,ymm0,xmm1,1
		vinserti128 ymm2,ymm2,xmm3,1						
		vpunpcklwd ymm0,ymm0,ymm4
		vpunpcklwd ymm2,ymm2,ymm4
		vcvtdq2ps ymm0,ymm0
		vcvtdq2ps ymm2,ymm2
		vmovaps YMMWORD PTR[esi],ymm0
		vmovaps YMMWORD PTR[esi+edi*4],ymm2
		vaddps ymm5,ymm5,ymm0
		vaddps ymm5,ymm5,ymm2
		vfmaddps ymm6,ymm0,ymm0,ymm6
		vfmaddps ymm6,ymm2,ymm2,ymm6
		add ecx,8
		add esi,32
		cmp ecx,edi
		jl short xloop2_16b_
		lea eax,[eax+ebx*4]
		lea edx,[edx+ebx*4]
		lea esi,[esi+edi*4]
		sub ydia_,2
		jnz short yloop2_16b_		
		
suite1b:		
		vextractf128 xmm0,ymm5,1
		vextractf128 xmm2,ymm6,1
		vaddps xmm5,xmm5,xmm0
		vaddps xmm6,xmm6,xmm2

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
		jbe short novarjmp_16b
		vrsqrtss xmm6,xmm6,xmm6
		vrcpss xmm5,xmm5,xmm6
		vmovss dword ptr[eax+4],xmm5
		vmovss dword ptr[eax+8],xmm6
		jmp short finish_3_16b
novarjmp_16b:
		vmovss dword ptr[eax+4],xmm4
		vmovss dword ptr[eax+8],xmm4
finish_3_16b:
		vmovss dword ptr[eax+12],xmm4
		
		vzeroupper
		
		pop esi
		pop edi
		pop ebx
		
		ret
		
extract_m8_FMA4_16 endp


extract_m8_AVX2_32 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,input:dword

	public extract_m8_AVX2_32
	
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
		vpxor ymm5,ymm5,ymm5
		vpxor ymm6,ymm6,ymm6
		vpxor ymm3,ymm3,ymm3
		
		test eax,31
		jnz short yloop2_32_				
		
yloop2_32:
		xor ecx,ecx
xloop2_32:
		vmovaps ymm0,YMMWORD PTR[eax+4*ecx]
		vmovaps ymm2,YMMWORD PTR[edx+4*ecx]		
		vmovaps YMMWORD PTR[esi],ymm0
		vmovaps YMMWORD PTR[esi+edi*4],ymm2
		vaddps ymm5,ymm5,ymm0
		vaddps ymm5,ymm5,ymm2
		vmulps ymm0,ymm0,ymm0
		vmulps ymm2,ymm2,ymm2
		vaddps ymm6,ymm6,ymm0
		vaddps ymm6,ymm6,ymm2
		add ecx,8
		add esi,32
		cmp ecx,edi
		jl short xloop2_32
		lea eax,[eax+ebx*4]
		lea edx,[edx+ebx*4]
		lea esi,[esi+edi*4]
		sub ydia_,2
		jnz short yloop2_32
		jmp short suite2
		
yloop2_32_:
		xor ecx,ecx
xloop2_32_:
		vmovups ymm0,YMMWORD PTR[eax+4*ecx]
		vmovups ymm2,YMMWORD PTR[edx+4*ecx]		
		vmovaps YMMWORD PTR[esi],ymm0
		vmovaps YMMWORD PTR[esi+edi*4],ymm2
		vaddps ymm5,ymm5,ymm0
		vaddps ymm5,ymm5,ymm2
		vmulps ymm0,ymm0,ymm0
		vmulps ymm2,ymm2,ymm2
		vaddps ymm6,ymm6,ymm0
		vaddps ymm6,ymm6,ymm2
		add ecx,8
		add esi,32
		cmp ecx,edi
		jl short xloop2_32_
		lea eax,[eax+ebx*4]
		lea edx,[edx+ebx*4]
		lea esi,[esi+edi*4]
		sub ydia_,2
		jnz short yloop2_32_
		
suite2:		
		vextractf128 xmm0,ymm5,1
		vextractf128 xmm2,ymm6,1
		vaddps xmm5,xmm5,xmm0
		vaddps xmm6,xmm6,xmm2

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
		jbe short novarjmp_32
		vrsqrtss xmm6,xmm6,xmm6
		vrcpss xmm5,xmm5,xmm6
		vmovss dword ptr[eax+4],xmm5
		vmovss dword ptr[eax+8],xmm6
		jmp short finish_3_32
novarjmp_32:
		vmovss dword ptr[eax+4],xmm3
		vmovss dword ptr[eax+8],xmm3
finish_3_32:
		vmovss dword ptr[eax+12],xmm3
		
		vzeroupper
		
		pop esi
		pop edi
		pop ebx
		
		ret
		
extract_m8_AVX2_32 endp


extract_m8_FMA3_32 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,input:dword

	public extract_m8_FMA3_32
	
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
		vpxor ymm5,ymm5,ymm5
		vpxor ymm6,ymm6,ymm6
		vpxor ymm3,ymm3,ymm3
		
		test eax,31
		jnz short yloop2_32a_				
		
yloop2_32a:
		xor ecx,ecx
xloop2_32a:
		vmovaps ymm0,YMMWORD PTR[eax+4*ecx]
		vmovaps ymm2,YMMWORD PTR[edx+4*ecx]		
		vmovaps YMMWORD PTR[esi],ymm0
		vmovaps YMMWORD PTR[esi+edi*4],ymm2
		vaddps ymm5,ymm5,ymm0
		vaddps ymm5,ymm5,ymm2
		vfmadd231ps ymm6,ymm0,ymm0
		vfmadd231ps ymm6,ymm2,ymm2
		add ecx,8
		add esi,32
		cmp ecx,edi
		jl short xloop2_32a
		lea eax,[eax+ebx*4]
		lea edx,[edx+ebx*4]
		lea esi,[esi+edi*4]
		sub ydia_,2
		jnz short yloop2_32a
		jmp short suite2a
		
yloop2_32a_:
		xor ecx,ecx
xloop2_32a_:
		vmovups ymm0,YMMWORD PTR[eax+4*ecx]
		vmovups ymm2,YMMWORD PTR[edx+4*ecx]		
		vmovaps YMMWORD PTR[esi],ymm0
		vmovaps YMMWORD PTR[esi+edi*4],ymm2
		vaddps ymm5,ymm5,ymm0
		vaddps ymm5,ymm5,ymm2
		vfmadd231ps ymm6,ymm0,ymm0
		vfmadd231ps ymm6,ymm2,ymm2
		add ecx,8
		add esi,32
		cmp ecx,edi
		jl short xloop2_32a_
		lea eax,[eax+ebx*4]
		lea edx,[edx+ebx*4]
		lea esi,[esi+edi*4]
		sub ydia_,2
		jnz short yloop2_32a_
		
suite2a:		
		vextractf128 xmm0,ymm5,1
		vextractf128 xmm2,ymm6,1
		vaddps xmm5,xmm5,xmm0
		vaddps xmm6,xmm6,xmm2

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
		jbe short novarjmp_32a
		vrsqrtss xmm6,xmm6,xmm6
		vrcpss xmm5,xmm5,xmm6
		vmovss dword ptr[eax+4],xmm5
		vmovss dword ptr[eax+8],xmm6
		jmp short finish_3_32a
novarjmp_32a:
		vmovss dword ptr[eax+4],xmm3
		vmovss dword ptr[eax+8],xmm3
finish_3_32a:
		vmovss dword ptr[eax+12],xmm3
		
		vzeroupper
		
		pop esi
		pop edi
		pop ebx
		
		ret
		
extract_m8_FMA3_32 endp


extract_m8_FMA4_32 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,input:dword

	public extract_m8_FMA4_32
	
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
		vpxor ymm5,ymm5,ymm5
		vpxor ymm6,ymm6,ymm6
		vpxor ymm3,ymm3,ymm3
		
		test eax,31
		jnz short yloop2_32b_				
		
yloop2_32b:
		xor ecx,ecx
xloop2_32b:
		vmovaps ymm0,YMMWORD PTR[eax+4*ecx]
		vmovaps ymm2,YMMWORD PTR[edx+4*ecx]		
		vmovaps YMMWORD PTR[esi],ymm0
		vmovaps YMMWORD PTR[esi+edi*4],ymm2
		vaddps ymm5,ymm5,ymm0
		vaddps ymm5,ymm5,ymm2
		vfmaddps ymm6,ymm0,ymm0,ymm6
		vfmaddps ymm6,ymm2,ymm2,ymm6
		add ecx,8
		add esi,32
		cmp ecx,edi
		jl short xloop2_32b
		lea eax,[eax+ebx*4]
		lea edx,[edx+ebx*4]
		lea esi,[esi+edi*4]
		sub ydia_,2
		jnz short yloop2_32b
		jmp short suite2b
		
yloop2_32b_:
		xor ecx,ecx
xloop2_32b_:
		vmovups ymm0,YMMWORD PTR[eax+4*ecx]
		vmovups ymm2,YMMWORD PTR[edx+4*ecx]		
		vmovaps YMMWORD PTR[esi],ymm0
		vmovaps YMMWORD PTR[esi+edi*4],ymm2
		vaddps ymm5,ymm5,ymm0
		vaddps ymm5,ymm5,ymm2
		vfmaddps ymm6,ymm0,ymm0,ymm6
		vfmaddps ymm6,ymm2,ymm2,ymm6
		add ecx,8
		add esi,32
		cmp ecx,edi
		jl short xloop2_32b_
		lea eax,[eax+ebx*4]
		lea edx,[edx+ebx*4]
		lea esi,[esi+edi*4]
		sub ydia_,2
		jnz short yloop2_32b_
		
suite2b:		
		vextractf128 xmm0,ymm5,1
		vextractf128 xmm2,ymm6,1
		vaddps xmm5,xmm5,xmm0
		vaddps xmm6,xmm6,xmm2

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
		jbe short novarjmp_32b
		vrsqrtss xmm6,xmm6,xmm6
		vrcpss xmm5,xmm5,xmm6
		vmovss dword ptr[eax+4],xmm5
		vmovss dword ptr[eax+8],xmm6
		jmp short finish_3_32b
novarjmp_32b:
		vmovss dword ptr[eax+4],xmm3
		vmovss dword ptr[eax+8],xmm3
finish_3_32b:
		vmovss dword ptr[eax+12],xmm3
		
		vzeroupper
		
		pop esi
		pop edi
		pop ebx
		
		ret
		
extract_m8_FMA4_32 endp


extract_m8_i16_AVX2_16 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,mstd:dword,inputf:dword

	public extract_m8_i16_AVX2_16
	
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
		vpxor ymm4,ymm4,ymm4
		vpxor ymm5,ymm5,ymm5
		vpxor ymm6,ymm6,ymm6
		
		cmp edi,8
		jg suite_3
		
		test eax,15
		jnz short yloop_16___
		
yloop_16_:
		vmovdqa xmm0,XMMWORD PTR[eax]
		vmovdqa xmm1,XMMWORD PTR[esi]
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
		add edx,16
		lea eax,[eax+ebx*4]
		lea esi,[esi+ebx*4]
		lea edx,[edx+edi*2]
		sub ydia_,2
		jnz short yloop_16_
		jmp suite3
		
yloop_16___:
		vmovdqu xmm0,XMMWORD PTR[eax]
		vmovdqu xmm1,XMMWORD PTR[esi]
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
		add edx,16
		lea eax,[eax+ebx*4]
		lea esi,[esi+ebx*4]
		lea edx,[edx+edi*2]
		sub ydia_,2
		jnz short yloop_16___
		jmp suite3		
		
suite_3:		
		test eax,31
		jnz short yloop_16__
		
yloop_16:
		xor ecx,ecx			
xloop_2_16:
		vmovdqa ymm0,YMMWORD PTR[eax+2*ecx]
		vmovdqa ymm1,YMMWORD PTR[esi+2*ecx]
		vmovdqa YMMWORD PTR[edx],ymm0
		vmovdqa YMMWORD PTR[edx+edi*2],ymm1
		vpmaddwd ymm2,ymm0,YMMWORD ptr uw_1
		vpmaddwd ymm3,ymm1,YMMWORD ptr uw_1		
		vpmaddwd ymm0,ymm0,ymm0
		vpmaddwd ymm1,ymm1,ymm1		
		vpaddd ymm4,ymm4,ymm2
		vpaddd ymm5,ymm5,ymm0
		vpaddd ymm4,ymm4,ymm3
		vpaddd ymm5,ymm5,ymm1		
		add ecx,16
		add edx,32
		cmp ecx,edi
		jl short xloop_2_16
		lea eax,[eax+ebx*4]
		lea esi,[esi+ebx*4]
		lea edx,[edx+edi*2]
		sub ydia_,2
		jnz short yloop_16
		
		vextracti128 xmm1,ymm4,1
		vextracti128 xmm2,ymm5,1
		vpaddd xmm4,xmm4,xmm1
		vpaddd xmm5,xmm5,xmm2
		
		jmp short suite3
		
yloop_16__:
		xor ecx,ecx			
xloop_2_16_:
		vmovdqu ymm0,YMMWORD PTR[eax+2*ecx]
		vmovdqu ymm1,YMMWORD PTR[esi+2*ecx]
		vmovdqa YMMWORD PTR[edx],ymm0
		vmovdqa YMMWORD PTR[edx+edi*2],ymm1
		vpmaddwd ymm2,ymm0,YMMWORD ptr uw_1
		vpmaddwd ymm3,ymm1,YMMWORD ptr uw_1		
		vpmaddwd ymm0,ymm0,ymm0
		vpmaddwd ymm1,ymm1,ymm1		
		vpaddd ymm4,ymm4,ymm2
		vpaddd ymm5,ymm5,ymm0
		vpaddd ymm4,ymm4,ymm3
		vpaddd ymm5,ymm5,ymm1		
		add ecx,16
		add edx,32
		cmp ecx,edi
		jl short xloop_2_16_
		lea eax,[eax+ebx*4]
		lea esi,[esi+ebx*4]
		lea edx,[edx+edi*2]
		sub ydia_,2
		jnz short yloop_16__
		
		vextracti128 xmm1,ymm4,1
		vextracti128 xmm2,ymm5,1
		vpaddd xmm4,xmm4,xmm1
		vpaddd xmm5,xmm5,xmm2
		
suite3:		
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
		jbe short novarjmp_2_16
		vrsqrtss xmm5,xmm5,xmm5
		vrcpss xmm4,xmm4,xmm5
		vmovss dword ptr[eax+4],xmm4
		vmovss dword ptr[eax+8],xmm5
		jmp short finish_4_16
novarjmp_2_16:
		vmovss dword ptr[eax+4],xmm6
		vmovss dword ptr[eax+8],xmm6
finish_4_16:
		vmovss dword ptr[eax+12],xmm6		
		
		vzeroupper
		
		pop esi
		pop edi
		pop ebx
		
		ret
		
extract_m8_i16_AVX2_16 endp


extract_m8_i16_AVX2_16_2 proc srcp:dword,stride:dword,xdia:dword,ydia:dword,inputf:dword,sum:dword,sumsq:dword

	public extract_m8_i16_AVX2_16_2
	
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
		vpxor ymm5,ymm5,ymm5
		vpxor ymm6,ymm6,ymm6
		
		test eax,15
		jnz yloop_16_2_
		
yloop_16_2:
		xor ecx,ecx			
xloop_2_16_2:	
		vmovdqa xmm0,XMMWORD PTR[eax+2*ecx]
		vmovdqa xmm1,XMMWORD PTR[esi+2*ecx]
		vpmaddwd xmm2,xmm0,XMMWORD ptr uw_1
		vpmaddwd xmm3,xmm1,XMMWORD ptr uw_1		
		vpaddd xmm4,xmm4,xmm2		
		vmovdqa XMMWORD PTR[edx],xmm0
		vmovdqa XMMWORD PTR[edx+edi*2],xmm1
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
		add ecx,8
		add edx,16
		cmp ecx,edi
		jl short xloop_2_16_2
		lea eax,[eax+ebx*4]
		lea esi,[esi+ebx*4]
		lea edx,[edx+edi*2]
		sub ydia_,2
		jnz yloop_16_2
		
		jmp suite4
		
yloop_16_2_:
		xor ecx,ecx			
xloop_2_16_2_:
		vmovdqu xmm0,XMMWORD PTR[eax+2*ecx]
		vmovdqu xmm1,XMMWORD PTR[esi+2*ecx]
		vpmaddwd xmm2,xmm0,XMMWORD ptr uw_1
		vpmaddwd xmm3,xmm1,XMMWORD ptr uw_1		
		vpaddd xmm4,xmm4,xmm2		
		vmovdqa XMMWORD PTR[edx],xmm0
		vmovdqa XMMWORD PTR[edx+edi*2],xmm1
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
		add ecx,8
		add edx,16
		cmp ecx,edi
		jl short xloop_2_16_2_
		lea eax,[eax+ebx*4]
		lea esi,[esi+ebx*4]
		lea edx,[edx+edi*2]
		sub ydia_,2
		jnz yloop_16_2_
		
suite4:				
		vmovhlps xmm0,xmm6,xmm4
		vextracti128 xmm1,ymm5,1
		vpaddd xmm4,xmm4,xmm0
		vpaddq xmm5,xmm5,xmm1
		mov eax,sum
		vmovhlps xmm0,xmm6,xmm5
		mov ebx,sumsq
		vpaddq xmm5,xmm5,xmm0		
		vpshufd xmm2,xmm4,1
		vmovq qword ptr [ebx],xmm5		
		vpaddd xmm4,xmm4,xmm2
		vmovd dword ptr [eax],xmm4
		
		vzeroupper
	
		pop esi
		pop edi
		pop ebx
		
		ret
		
extract_m8_i16_AVX2_16_2 endp


dotProd_m32_m16_AVX2 proc data_:dword,weights:dword,vals:dword,n:dword,len:dword,istd:dword

	public dotProd_m32_m16_AVX2

		push edi
		push esi
		push ebx
		
		mov edi,weights
		mov eax,vals
		mov ebx,n
		mov esi,len
nloop:
		mov ecx,data_
		vxorps ymm0,ymm0,ymm0
		vxorps ymm1,ymm1,ymm1
		vxorps ymm2,ymm2,ymm2
		vxorps ymm3,ymm3,ymm3
		mov edx,esi
lloop:
		vmovaps ymm7,YMMWORD ptr[ecx]
		vmulps ymm4,ymm7,YMMWORD ptr[edi]
		vmulps ymm5,ymm7,YMMWORD ptr[edi+32]
		vmulps ymm6,ymm7,YMMWORD ptr[edi+64]
		vmulps ymm7,ymm7,YMMWORD ptr[edi+96]
		vaddps ymm0,ymm0,ymm4
		vaddps ymm1,ymm1,ymm5
		vaddps ymm2,ymm2,ymm6
		vaddps ymm3,ymm3,ymm7
		
		vmovaps ymm7,YMMWORD ptr[ecx+32]
		vmulps ymm4,ymm7,YMMWORD ptr[edi+128]
		vmulps ymm5,ymm7,YMMWORD ptr[edi+160]
		vmulps ymm6,ymm7,YMMWORD ptr[edi+192]
		vmulps ymm7,ymm7,YMMWORD ptr[edi+224]
		vaddps ymm0,ymm0,ymm4
		vaddps ymm1,ymm1,ymm5
		vaddps ymm2,ymm2,ymm6
		vaddps ymm3,ymm3,ymm7
		
		vmovaps ymm7,YMMWORD ptr[ecx+64]
		vmulps ymm4,ymm7,YMMWORD ptr[edi+256]
		vmulps ymm5,ymm7,YMMWORD ptr[edi+288]
		vmulps ymm6,ymm7,YMMWORD ptr[edi+320]
		vmulps ymm7,ymm7,YMMWORD ptr[edi+352]
		vaddps ymm0,ymm0,ymm4
		vaddps ymm1,ymm1,ymm5
		vaddps ymm2,ymm2,ymm6
		vaddps ymm3,ymm3,ymm7
		
		vmovaps ymm7,YMMWORD ptr[ecx+96]
		vmulps ymm4,ymm7,YMMWORD ptr[edi+384]
		vmulps ymm5,ymm7,YMMWORD ptr[edi+416]
		vmulps ymm6,ymm7,YMMWORD ptr[edi+448]
		vmulps ymm7,ymm7,YMMWORD ptr[edi+480]
		vaddps ymm0,ymm0,ymm4
		vaddps ymm1,ymm1,ymm5
		vaddps ymm2,ymm2,ymm6
		vaddps ymm3,ymm3,ymm7
		
		add ecx,128
		add edi,512
		sub edx,32
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
		
		vmovaps XMMWORD ptr[eax],xmm0
		add eax,16
		sub ebx,4
		jnz nloop
		
		mov ecx,istd
		mov eax,vals
		vmovss xmm7,dword ptr[ecx]
		mov edx,n
		vshufps xmm7,xmm7,xmm7,0
		xor ecx,ecx
		vinsertf128 ymm7,ymm7,xmm7,1
aloop:
		vmulps ymm0,ymm7,YMMWORD ptr[eax+ecx*4]
		vmulps ymm2,ymm7,YMMWORD ptr[eax+ecx*4+32]
		vaddps ymm0,ymm0,YMMWORD ptr[edi+ecx*4]
		vaddps ymm2,ymm2,YMMWORD ptr[edi+ecx*4+32]
		vmovaps YMMWORD ptr[eax+ecx*4],ymm0
		vmovaps YMMWORD ptr[eax+ecx*4+32],ymm2		
		add ecx,16
		sub edx,16
		jnz short aloop
		
		vzeroupper
		
		pop ebx
		pop esi
		pop edi
		
		ret
		
dotProd_m32_m16_AVX2 endp


dotProd_m32_m16_FMA3 proc data_:dword,weights:dword,vals:dword,n:dword,len:dword,istd:dword

	public dotProd_m32_m16_FMA3

		push edi
		push esi
		push ebx
		
		mov edi,weights
		mov eax,vals
		mov ebx,n
		mov esi,len
nloop_2:
		mov ecx,data_
		vxorps ymm0,ymm0,ymm0
		vxorps ymm1,ymm1,ymm1
		vxorps ymm2,ymm2,ymm2
		vxorps ymm3,ymm3,ymm3
		mov edx,esi
lloop_2:
		vmovaps ymm7,YMMWORD ptr[ecx]
		vfmadd231ps ymm0,ymm7,YMMWORD ptr[edi]
		vfmadd231ps ymm1,ymm7,YMMWORD ptr[edi+32]
		vfmadd231ps ymm2,ymm7,YMMWORD ptr[edi+64]
		vfmadd231ps ymm3,ymm7,YMMWORD ptr[edi+96]
				
		vmovaps ymm7,YMMWORD ptr[ecx+32]
		vfmadd231ps ymm0,ymm7,YMMWORD ptr[edi+128]
		vfmadd231ps ymm1,ymm7,YMMWORD ptr[edi+160]
		vfmadd231ps ymm2,ymm7,YMMWORD ptr[edi+192]
		vfmadd231ps ymm3,ymm7,YMMWORD ptr[edi+224]
		
		vmovaps ymm7,YMMWORD ptr[ecx+64]
		vfmadd231ps ymm0,ymm7,YMMWORD ptr[edi+256]
		vfmadd231ps ymm1,ymm7,YMMWORD ptr[edi+288]
		vfmadd231ps ymm2,ymm7,YMMWORD ptr[edi+320]
		vfmadd231ps ymm3,ymm7,YMMWORD ptr[edi+352]
		
		vmovaps ymm7,YMMWORD ptr[ecx+96]
		vfmadd231ps ymm0,ymm7,YMMWORD ptr[edi+384]
		vfmadd231ps ymm1,ymm7,YMMWORD ptr[edi+416]
		vfmadd231ps ymm2,ymm7,YMMWORD ptr[edi+448]
		vfmadd231ps ymm3,ymm7,YMMWORD ptr[edi+480]
		
		add ecx,128
		add edi,512
		sub edx,32
		jnz lloop_2

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
		
		vmovaps XMMWORD ptr[eax],xmm0
		add eax,16
		sub ebx,4
		jnz nloop_2
		
		mov ecx,istd
		mov eax,vals
		vmovss xmm7,dword ptr[ecx]
		mov edx,n
		vshufps xmm7,xmm7,xmm7,0
		vinsertf128 ymm7,ymm7,xmm7,1
		xor ecx,ecx
aloop_2:
		vmulps ymm0,ymm7,YMMWORD ptr[eax+ecx*4]
		vmulps ymm2,ymm7,YMMWORD ptr[eax+ecx*4+32]
		vaddps ymm0,ymm0,YMMWORD ptr[edi+ecx*4]
		vaddps ymm2,ymm2,YMMWORD ptr[edi+ecx*4+32]
		vmovaps YMMWORD ptr[eax+ecx*4],ymm0
		vmovaps YMMWORD ptr[eax+ecx*4+32],ymm2		
		add ecx,16
		sub edx,16
		jnz short aloop_2
		
		vzeroupper
		
		pop ebx
		pop esi
		pop edi
		
		ret
		
dotProd_m32_m16_FMA3 endp


dotProd_m32_m16_FMA4 proc data_:dword,weights:dword,vals:dword,n:dword,len:dword,istd:dword

	public dotProd_m32_m16_FMA4

		push edi
		push esi
		push ebx
		
		mov edi,weights
		mov eax,vals
		mov ebx,n
		mov esi,len
nloop_3:
		mov ecx,data_
		vxorps ymm0,ymm0,ymm0
		vxorps ymm1,ymm1,ymm1
		vxorps ymm2,ymm2,ymm2
		vxorps ymm3,ymm3,ymm3
		mov edx,esi
lloop_3:
		vmovaps ymm7,YMMWORD ptr[ecx]
		vfmaddps ymm0,ymm7,YMMWORD ptr[edi],ymm0
		vfmaddps ymm1,ymm7,YMMWORD ptr[edi+32],ymm1
		vfmaddps ymm2,ymm7,YMMWORD ptr[edi+64],ymm2
		vfmaddps ymm3,ymm7,YMMWORD ptr[edi+96],ymm3
				
		vmovaps ymm7,YMMWORD ptr[ecx+32]
		vfmaddps ymm0,ymm7,YMMWORD ptr[edi+128],ymm0
		vfmaddps ymm1,ymm7,YMMWORD ptr[edi+160],ymm1
		vfmaddps ymm2,ymm7,YMMWORD ptr[edi+192],ymm2
		vfmaddps ymm3,ymm7,YMMWORD ptr[edi+224],ymm3
		
		vmovaps ymm7,YMMWORD ptr[ecx+64]
		vfmaddps ymm0,ymm7,YMMWORD ptr[edi+256],ymm0
		vfmaddps ymm1,ymm7,YMMWORD ptr[edi+288],ymm1
		vfmaddps ymm2,ymm7,YMMWORD ptr[edi+320],ymm2
		vfmaddps ymm3,ymm7,YMMWORD ptr[edi+352],ymm3
		
		vmovaps ymm7,YMMWORD ptr[ecx+96]
		vfmaddps ymm0,ymm7,YMMWORD ptr[edi+384],ymm0
		vfmaddps ymm1,ymm7,YMMWORD ptr[edi+416],ymm1
		vfmaddps ymm2,ymm7,YMMWORD ptr[edi+448],ymm2
		vfmaddps ymm3,ymm7,YMMWORD ptr[edi+480],ymm3
		
		add ecx,128
		add edi,512
		sub edx,32
		jnz lloop_3

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
		
		vmovaps XMMWORD ptr[eax],xmm0
		add eax,16
		sub ebx,4
		jnz nloop_3
		
		mov ecx,istd
		mov eax,vals
		vmovss xmm7,dword ptr[ecx]
		mov edx,n
		vshufps xmm7,xmm7,xmm7,0
		vinsertf128 ymm7,ymm7,xmm7,1
		xor ecx,ecx
		
aloop_3:
		vmulps ymm0,ymm7,YMMWORD ptr[eax+ecx*4]
		vmulps ymm2,ymm7,YMMWORD ptr[eax+ecx*4+32]
		vaddps ymm0,ymm0,YMMWORD ptr[edi+ecx*4]
		vaddps ymm2,ymm2,YMMWORD ptr[edi+ecx*4+32]
		vmovaps YMMWORD ptr[eax+ecx*4],ymm0
		vmovaps YMMWORD ptr[eax+ecx*4+32],ymm2		
		add ecx,16
		sub edx,16
		jnz short aloop_3
		
		vzeroupper
		
		pop ebx
		pop esi
		pop edi
		
		ret
		
dotProd_m32_m16_FMA4 endp


dotProd_m48_m16_AVX2 proc data_:dword,weights:dword,vals:dword,n:dword,len:dword,istd:dword

	public dotProd_m32_m16_AVX2

		push edi
		push esi
		push ebx
		
		mov edi,weights
		mov eax,vals
		mov ebx,n
		mov esi,len
nloop2:
		mov ecx,data_
		vxorps ymm0,ymm0,ymm0
		vxorps ymm1,ymm1,ymm1
		vxorps ymm2,ymm2,ymm2
		vxorps ymm3,ymm3,ymm3
		mov edx,esi
lloop2:
		vmovaps ymm7,YMMWORD ptr[ecx]
		vmulps ymm4,ymm7,YMMWORD ptr[edi]
		vmulps ymm5,ymm7,YMMWORD ptr[edi+32]
		vmulps ymm6,ymm7,YMMWORD ptr[edi+64]
		vmulps ymm7,ymm7,YMMWORD ptr[edi+96]
		vaddps ymm0,ymm0,ymm4
		vaddps ymm1,ymm1,ymm5
		vaddps ymm2,ymm2,ymm6
		vaddps ymm3,ymm3,ymm7
		
		vmovaps ymm7,YMMWORD ptr[ecx+32]
		vmulps ymm4,ymm7,YMMWORD ptr[edi+128]
		vmulps ymm5,ymm7,YMMWORD ptr[edi+160]
		vmulps ymm6,ymm7,YMMWORD ptr[edi+192]
		vmulps ymm7,ymm7,YMMWORD ptr[edi+224]
		vaddps ymm0,ymm0,ymm4
		vaddps ymm1,ymm1,ymm5
		vaddps ymm2,ymm2,ymm6
		vaddps ymm3,ymm3,ymm7
		
		vmovaps ymm7,YMMWORD ptr[ecx+64]
		vmulps ymm4,ymm7,YMMWORD ptr[edi+256]
		vmulps ymm5,ymm7,YMMWORD ptr[edi+288]
		vmulps ymm6,ymm7,YMMWORD ptr[edi+320]
		vmulps ymm7,ymm7,YMMWORD ptr[edi+352]
		vaddps ymm0,ymm0,ymm4
		vaddps ymm1,ymm1,ymm5
		vaddps ymm2,ymm2,ymm6
		vaddps ymm3,ymm3,ymm7
		
		vmovaps ymm7,YMMWORD ptr[ecx+96]
		vmulps ymm4,ymm7,YMMWORD ptr[edi+384]
		vmulps ymm5,ymm7,YMMWORD ptr[edi+416]
		vmulps ymm6,ymm7,YMMWORD ptr[edi+448]
		vmulps ymm7,ymm7,YMMWORD ptr[edi+480]
		vaddps ymm0,ymm0,ymm4
		vaddps ymm1,ymm1,ymm5
		vaddps ymm2,ymm2,ymm6
		vaddps ymm3,ymm3,ymm7
		
		vmovaps ymm7,YMMWORD ptr[ecx+128]
		vmulps ymm4,ymm7,YMMWORD ptr[edi+512]
		vmulps ymm5,ymm7,YMMWORD ptr[edi+544]
		vmulps ymm6,ymm7,YMMWORD ptr[edi+576]
		vmulps ymm7,ymm7,YMMWORD ptr[edi+608]
		vaddps ymm0,ymm0,ymm4
		vaddps ymm1,ymm1,ymm5
		vaddps ymm2,ymm2,ymm6
		vaddps ymm3,ymm3,ymm7		
		
		vmovaps ymm7,YMMWORD ptr[ecx+160]
		vmulps ymm4,ymm7,YMMWORD ptr[edi+640]
		vmulps ymm5,ymm7,YMMWORD ptr[edi+672]
		vmulps ymm6,ymm7,YMMWORD ptr[edi+704]
		vmulps ymm7,ymm7,YMMWORD ptr[edi+736]
		vaddps ymm0,ymm0,ymm4
		vaddps ymm1,ymm1,ymm5
		vaddps ymm2,ymm2,ymm6
		vaddps ymm3,ymm3,ymm7				
		
		add ecx,192
		add edi,768
		sub edx,48
		jnz lloop2
		
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
		
		vmovaps XMMWORD ptr[eax],xmm0
		add eax,16
		sub ebx,4
		jnz nloop2
		
		mov ecx,istd
		mov eax,vals
		vmovss xmm7,dword ptr[ecx]
		mov edx,n
		vshufps xmm7,xmm7,xmm7,0
		xor ecx,ecx
		vinsertf128 ymm7,ymm7,xmm7,1
aloop2:
		vmulps ymm0,ymm7,YMMWORD ptr[eax+ecx*4]
		vmulps ymm2,ymm7,YMMWORD ptr[eax+ecx*4+32]
		vaddps ymm0,ymm0,YMMWORD ptr[edi+ecx*4]
		vaddps ymm2,ymm2,YMMWORD ptr[edi+ecx*4+32]
		vmovaps YMMWORD ptr[eax+ecx*4],ymm0
		vmovaps YMMWORD ptr[eax+ecx*4+32],ymm2		
		add ecx,16
		sub edx,16
		jnz short aloop2
		
		vzeroupper
		
		pop ebx
		pop esi
		pop edi
		
		ret
		
dotProd_m48_m16_AVX2 endp


dotProd_m48_m16_FMA3 proc data_:dword,weights:dword,vals:dword,n:dword,len:dword,istd:dword

	public dotProd_m48_m16_FMA3

		push edi
		push esi
		push ebx
		
		mov edi,weights
		mov eax,vals
		mov ebx,n
		mov esi,len
nloop2_2:
		mov ecx,data_
		vxorps ymm0,ymm0,ymm0
		vxorps ymm1,ymm1,ymm1
		vxorps ymm2,ymm2,ymm2
		vxorps ymm3,ymm3,ymm3
		mov edx,esi
lloop2_2:
		vmovaps ymm7,YMMWORD ptr[ecx]
		vfmadd231ps ymm0,ymm7,YMMWORD ptr[edi]
		vfmadd231ps ymm1,ymm7,YMMWORD ptr[edi+32]
		vfmadd231ps ymm2,ymm7,YMMWORD ptr[edi+64]
		vfmadd231ps ymm3,ymm7,YMMWORD ptr[edi+96]
				
		vmovaps ymm7,YMMWORD ptr[ecx+32]
		vfmadd231ps ymm0,ymm7,YMMWORD ptr[edi+128]
		vfmadd231ps ymm1,ymm7,YMMWORD ptr[edi+160]
		vfmadd231ps ymm2,ymm7,YMMWORD ptr[edi+192]
		vfmadd231ps ymm3,ymm7,YMMWORD ptr[edi+224]
		
		vmovaps ymm7,YMMWORD ptr[ecx+64]
		vfmadd231ps ymm0,ymm7,YMMWORD ptr[edi+256]
		vfmadd231ps ymm1,ymm7,YMMWORD ptr[edi+288]
		vfmadd231ps ymm2,ymm7,YMMWORD ptr[edi+320]
		vfmadd231ps ymm3,ymm7,YMMWORD ptr[edi+352]
		
		vmovaps ymm7,YMMWORD ptr[ecx+96]
		vfmadd231ps ymm0,ymm7,YMMWORD ptr[edi+384]
		vfmadd231ps ymm1,ymm7,YMMWORD ptr[edi+416]
		vfmadd231ps ymm2,ymm7,YMMWORD ptr[edi+448]
		vfmadd231ps ymm3,ymm7,YMMWORD ptr[edi+480]
		
		vmovaps ymm7,YMMWORD ptr[ecx+128]
		vfmadd231ps ymm0,ymm7,YMMWORD ptr[edi+512]
		vfmadd231ps ymm1,ymm7,YMMWORD ptr[edi+544]
		vfmadd231ps ymm2,ymm7,YMMWORD ptr[edi+576]
		vfmadd231ps ymm3,ymm7,YMMWORD ptr[edi+608]
		
		vmovaps ymm7,YMMWORD ptr[ecx+160]
		vfmadd231ps ymm0,ymm7,YMMWORD ptr[edi+640]
		vfmadd231ps ymm1,ymm7,YMMWORD ptr[edi+672]
		vfmadd231ps ymm2,ymm7,YMMWORD ptr[edi+704]
		vfmadd231ps ymm3,ymm7,YMMWORD ptr[edi+736]		
		
		add ecx,192
		add edi,768
		sub edx,48
		jnz lloop2_2

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
		
		vmovaps XMMWORD ptr[eax],xmm0
		add eax,16
		sub ebx,4
		jnz nloop2_2
		
		mov ecx,istd
		mov eax,vals
		vmovss xmm7,dword ptr[ecx]
		mov edx,n
		vshufps xmm7,xmm7,xmm7,0
		vinsertf128 ymm7,ymm7,xmm7,1
		xor ecx,ecx
aloop2_2:
		vmulps ymm0,ymm7,YMMWORD ptr[eax+ecx*4]
		vmulps ymm2,ymm7,YMMWORD ptr[eax+ecx*4+32]
		vaddps ymm0,ymm0,YMMWORD ptr[edi+ecx*4]
		vaddps ymm2,ymm2,YMMWORD ptr[edi+ecx*4+32]
		vmovaps YMMWORD ptr[eax+ecx*4],ymm0
		vmovaps YMMWORD ptr[eax+ecx*4+32],ymm2		
		add ecx,16
		sub edx,16
		jnz short aloop2_2
		
		vzeroupper
		
		pop ebx
		pop esi
		pop edi
		
		ret
		
dotProd_m48_m16_FMA3 endp


dotProd_m48_m16_FMA4 proc data_:dword,weights:dword,vals:dword,n:dword,len:dword,istd:dword

	public dotProd_m48_m16_FMA4

		push edi
		push esi
		push ebx
		
		mov edi,weights
		mov eax,vals
		mov ebx,n
		mov esi,len
nloop2_3:
		mov ecx,data_
		vxorps ymm0,ymm0,ymm0
		vxorps ymm1,ymm1,ymm1
		vxorps ymm2,ymm2,ymm2
		vxorps ymm3,ymm3,ymm3
		mov edx,esi
lloop2_3:
		vmovaps ymm7,YMMWORD ptr[ecx]
		vfmaddps ymm0,ymm7,YMMWORD ptr[edi],ymm0
		vfmaddps ymm1,ymm7,YMMWORD ptr[edi+32],ymm1
		vfmaddps ymm2,ymm7,YMMWORD ptr[edi+64],ymm2
		vfmaddps ymm3,ymm7,YMMWORD ptr[edi+96],ymm3
				
		vmovaps ymm7,YMMWORD ptr[ecx+32]
		vfmaddps ymm0,ymm7,YMMWORD ptr[edi+128],ymm0
		vfmaddps ymm1,ymm7,YMMWORD ptr[edi+160],ymm1
		vfmaddps ymm2,ymm7,YMMWORD ptr[edi+192],ymm2
		vfmaddps ymm3,ymm7,YMMWORD ptr[edi+224],ymm3
		
		vmovaps ymm7,YMMWORD ptr[ecx+64]
		vfmaddps ymm0,ymm7,YMMWORD ptr[edi+256],ymm0
		vfmaddps ymm1,ymm7,YMMWORD ptr[edi+288],ymm1
		vfmaddps ymm2,ymm7,YMMWORD ptr[edi+320],ymm2
		vfmaddps ymm3,ymm7,YMMWORD ptr[edi+352],ymm3
		
		vmovaps ymm7,YMMWORD ptr[ecx+96]
		vfmaddps ymm0,ymm7,YMMWORD ptr[edi+384],ymm0
		vfmaddps ymm1,ymm7,YMMWORD ptr[edi+416],ymm1
		vfmaddps ymm2,ymm7,YMMWORD ptr[edi+448],ymm2
		vfmaddps ymm3,ymm7,YMMWORD ptr[edi+480],ymm3
		
		vmovaps ymm7,YMMWORD ptr[ecx+128]
		vfmaddps ymm0,ymm7,YMMWORD ptr[edi+512],ymm0
		vfmaddps ymm1,ymm7,YMMWORD ptr[edi+544],ymm1
		vfmaddps ymm2,ymm7,YMMWORD ptr[edi+576],ymm2
		vfmaddps ymm3,ymm7,YMMWORD ptr[edi+608],ymm3
		
		vmovaps ymm7,YMMWORD ptr[ecx+160]
		vfmaddps ymm0,ymm7,YMMWORD ptr[edi+640],ymm0
		vfmaddps ymm1,ymm7,YMMWORD ptr[edi+672],ymm1
		vfmaddps ymm2,ymm7,YMMWORD ptr[edi+704],ymm2
		vfmaddps ymm3,ymm7,YMMWORD ptr[edi+736],ymm3
		
		add ecx,192
		add edi,768
		sub edx,48
		jnz lloop2_3

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
		
		vmovaps XMMWORD ptr[eax],xmm0
		add eax,16
		sub ebx,4
		jnz nloop2_3
		
		mov ecx,istd
		mov eax,vals
		vmovss xmm7,dword ptr[ecx]
		mov edx,n
		vshufps xmm7,xmm7,xmm7,0
		vinsertf128 ymm7,ymm7,xmm7,1
		xor ecx,ecx
		
aloop2_3:
		vmulps ymm0,ymm7,YMMWORD ptr[eax+ecx*4]
		vmulps ymm2,ymm7,YMMWORD ptr[eax+ecx*4+32]
		vaddps ymm0,ymm0,YMMWORD ptr[edi+ecx*4]
		vaddps ymm2,ymm2,YMMWORD ptr[edi+ecx*4+32]
		vmovaps YMMWORD ptr[eax+ecx*4],ymm0
		vmovaps YMMWORD ptr[eax+ecx*4+32],ymm2		
		add ecx,16
		sub edx,16
		jnz short aloop2_3
		
		vzeroupper
		
		pop ebx
		pop esi
		pop edi
		
		ret
		
dotProd_m48_m16_FMA4 endp


dotProd_m32_m16_i16_AVX2 proc dataf:dword,weightsf:dword,vals:dword,n:dword,len:dword,istd:dword

	public dotProd_m32_m16_i16_AVX2

		push edi
		push esi
		push ebx
		
		mov edi,weightsf
		mov eax,vals
		mov ebx,n
		mov esi,len
nloop_3:
		mov ecx,dataf
		vpxor ymm0,ymm0,ymm0
		vpxor ymm1,ymm1,ymm1
		vpxor ymm2,ymm2,ymm2
		vpxor ymm3,ymm3,ymm3
		mov edx,esi
lloop_3:
		vmovdqa ymm7,YMMWORD ptr [ecx]
		vpmaddwd ymm4,ymm7,YMMWORD ptr [edi]
		vpmaddwd ymm5,ymm7,YMMWORD ptr [edi+32]
		vpmaddwd ymm6,ymm7,YMMWORD ptr [edi+64]
		vpmaddwd ymm7,ymm7,YMMWORD ptr [edi+96]
		vpaddd ymm0,ymm0,ymm4
		vpaddd ymm1,ymm1,ymm5
		vpaddd ymm2,ymm2,ymm6
		vpaddd ymm3,ymm3,ymm7
				
		vmovdqa ymm7,YMMWORD ptr [ecx+32]
		vpmaddwd ymm4,ymm7,YMMWORD ptr [edi+128]
		vpmaddwd ymm5,ymm7,YMMWORD ptr [edi+160]
		vpmaddwd ymm6,ymm7,YMMWORD ptr [edi+192]
		vpmaddwd ymm7,ymm7,YMMWORD ptr [edi+224]
		vpaddd ymm0,ymm0,ymm4
		vpaddd ymm1,ymm1,ymm5
		vpaddd ymm2,ymm2,ymm6
		vpaddd ymm3,ymm3,ymm7
				
		add ecx,64
		add edi,256
		sub edx,32
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
		vmovdqa XMMWORD ptr [eax],xmm6
		add eax,16
		sub ebx,4
		jnz nloop_3
		mov ecx,istd
		mov eax,vals
		vmovss xmm7,dword ptr[ecx]
		mov edx,n
		vpshufd xmm7,xmm7,0
		xor ecx,ecx
aloop_3:
		vmovdqa ymm0,YMMWORD ptr[eax+ecx*4]
		vmovdqa ymm2,YMMWORD ptr[eax+ecx*4+32]
		vcvtdq2ps ymm0,ymm0
		vcvtdq2ps ymm2,ymm2
		vextractf128 xmm1,ymm0,1
		vextractf128 xmm3,ymm2,1
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
		jnz short aloop_3
		
		vzeroupper
		
		pop ebx
		pop esi
		pop edi
		
		ret
		
dotProd_m32_m16_i16_AVX2 endp


dotProd_m48_m16_i16_AVX2 proc dataf:dword,weightsf:dword,vals:dword,n:dword,len:dword,istd:dword

	public dotProd_m48_m16_i16_AVX2

		push edi
		push esi
		push ebx
		
		mov edi,weightsf
		mov eax,vals
		mov ebx,n
		mov esi,len
nloop_4:
		mov ecx,dataf
		vpxor ymm0,ymm0,ymm0
		vpxor ymm1,ymm1,ymm1
		vpxor ymm2,ymm2,ymm2
		vpxor ymm3,ymm3,ymm3
		mov edx,esi
lloop_4:
		vmovdqa ymm7,YMMWORD ptr [ecx]
		vpmaddwd ymm4,ymm7,YMMWORD ptr [edi]
		vpmaddwd ymm5,ymm7,YMMWORD ptr [edi+32]
		vpmaddwd ymm6,ymm7,YMMWORD ptr [edi+64]
		vpmaddwd ymm7,ymm7,YMMWORD ptr [edi+96]
		vpaddd ymm0,ymm0,ymm4
		vpaddd ymm1,ymm1,ymm5
		vpaddd ymm2,ymm2,ymm6
		vpaddd ymm3,ymm3,ymm7
				
		vmovdqa ymm7,YMMWORD ptr [ecx+32]
		vpmaddwd ymm4,ymm7,YMMWORD ptr [edi+128]
		vpmaddwd ymm5,ymm7,YMMWORD ptr [edi+160]
		vpmaddwd ymm6,ymm7,YMMWORD ptr [edi+192]
		vpmaddwd ymm7,ymm7,YMMWORD ptr [edi+224]
		vpaddd ymm0,ymm0,ymm4
		vpaddd ymm1,ymm1,ymm5
		vpaddd ymm2,ymm2,ymm6
		vpaddd ymm3,ymm3,ymm7		
		
		vmovdqa ymm7,YMMWORD ptr [ecx+64]
		vpmaddwd ymm4,ymm7,YMMWORD ptr [edi+256]
		vpmaddwd ymm5,ymm7,YMMWORD ptr [edi+288]
		vpmaddwd ymm6,ymm7,YMMWORD ptr [edi+320]
		vpmaddwd ymm7,ymm7,YMMWORD ptr [edi+352]
		vpaddd ymm0,ymm0,ymm4
		vpaddd ymm1,ymm1,ymm5
		vpaddd ymm2,ymm2,ymm6
		vpaddd ymm3,ymm3,ymm7		
		
		add ecx,96
		add edi,384
		sub edx,48
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
		vmovdqa XMMWORD ptr [eax],xmm6
		add eax,16
		sub ebx,4
		jnz nloop_4
		mov ecx,istd
		mov eax,vals
		vmovss xmm7,dword ptr[ecx]
		mov edx,n
		vpshufd xmm7,xmm7,0
		xor ecx,ecx
aloop_4:
		vmovdqa ymm0,YMMWORD ptr[eax+ecx*4]
		vmovdqa ymm2,YMMWORD ptr[eax+ecx*4+32]
		vcvtdq2ps ymm0,ymm0
		vcvtdq2ps ymm2,ymm2
		vextractf128 xmm1,ymm0,1
		vextractf128 xmm3,ymm2,1		
		vmulps xmm0,xmm0,XMMWORD ptr [edi+ecx*8]
		vmulps xmm1,xmm1,XMMWORD ptr [edi+ecx*8+32]
		vmulps xmm2,xmm2,XMMWORD ptr [edi+ecx*8+64]
		vmulps xmm3,xmm3,XMMWORD ptr [edi+ecx*8+96]
		vmulps xmm0,xmm0,xmm7
		vmulps xmm1,xmm1,xmm7
		vmulps xmm2,xmm2,xmm7
		vmulps xmm3,xmm3,xmm7
		vaddps xmm0,xmm0,XMMWORD ptr [edi+ecx*8+16]
		vaddps xmm1,xmm1,XMMWORD ptr [edi+ecx*8+48]
		vaddps xmm2,xmm2,XMMWORD ptr [edi+ecx*8+80]
		vaddps xmm3,xmm3,XMMWORD ptr [edi+ecx*8+112]
		vmovaps XMMWORD ptr [eax+ecx*4],xmm0
		vmovaps XMMWORD ptr [eax+ecx*4+16],xmm1
		vmovaps XMMWORD ptr [eax+ecx*4+32],xmm2
		vmovaps XMMWORD ptr [eax+ecx*4+48],xmm3
		add ecx,16
		sub edx,16
		jnz short aloop_4
		
		vzeroupper
		
		pop ebx
		pop esi
		pop edi
		
		ret

dotProd_m48_m16_i16_AVX2 endp


e0_m16_AVX2 proc ptr_s:dword,n:dword

	public e0_m16_AVX2
	
		mov eax,ptr_s
		mov ecx,n
		
		vmovdqa ymm2,YMMWORD ptr exp_hi
		vmovdqa ymm3,YMMWORD ptr exp_lo
		vmovdqa ymm4,YMMWORD ptr e0_mult
		vmovdqa ymm5,YMMWORD ptr e0_bias
		
eloop16:
		vmovaps ymm0,YMMWORD ptr [eax]
		vmovaps ymm1,YMMWORD ptr [eax+32]
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
		vmovaps YMMWORD ptr [eax],ymm0
		vmovaps YMMWORD ptr [eax+32],ymm1
		add eax,64
		sub ecx,16
		
		jnz short eloop16
		
		vzeroupper
		
		ret

e0_m16_AVX2 endp


e0_m16_FMA3 proc ptr_s:dword,n:dword

	public e0_m16_FMA3
	
		mov eax,ptr_s
		mov ecx,n
		
		vmovdqa ymm2,YMMWORD ptr exp_hi
		vmovdqa ymm3,YMMWORD ptr exp_lo
		vmovdqa ymm4,YMMWORD ptr e0_mult
		vmovdqa ymm5,YMMWORD ptr e0_bias
		
eloop16_2:
		vmovaps ymm0,YMMWORD ptr [eax]
		vmovaps ymm1,YMMWORD ptr [eax+32]
		vminps ymm0,ymm0,ymm2
		vminps ymm1,ymm1,ymm2
		vmaxps ymm0,ymm0,ymm3
		vmaxps ymm1,ymm1,ymm3
		
		vfmadd213ps ymm0,ymm4,ymm5
		vfmadd213ps ymm1,ymm4,ymm5
		
		vcvtps2dq ymm0,ymm0
		vcvtps2dq ymm1,ymm1
		vmovaps YMMWORD ptr [eax],ymm0
		vmovaps YMMWORD ptr [eax+32],ymm1
		add eax,64
		sub ecx,16
		
		jnz short eloop16_2
		
		vzeroupper
		
		ret

e0_m16_FMA3 endp


e0_m16_FMA4 proc ptr_s:dword,n:dword

	public e0_m16_FMA4
	
		mov eax,ptr_s
		mov ecx,n
		
		vmovdqa ymm2,YMMWORD ptr exp_hi
		vmovdqa ymm3,YMMWORD ptr exp_lo
		vmovdqa ymm4,YMMWORD ptr e0_mult
		vmovdqa ymm5,YMMWORD ptr e0_bias
		
eloop16_3:
		vmovaps ymm0,YMMWORD ptr [eax]
		vmovaps ymm1,YMMWORD ptr [eax+32]
		vminps ymm0,ymm0,ymm2
		vminps ymm1,ymm1,ymm2
		vmaxps ymm0,ymm0,ymm3
		vmaxps ymm1,ymm1,ymm3
		
		vfmaddps ymm0,ymm0,ymm4,ymm5
		vfmaddps ymm1,ymm1,ymm4,ymm5
		
		vcvtps2dq ymm0,ymm0
		vcvtps2dq ymm1,ymm1
		vmovaps YMMWORD ptr [eax],ymm0
		vmovaps YMMWORD ptr [eax+32],ymm1
		add eax,64
		sub ecx,16
		
		jnz short eloop16_3
		
		vzeroupper
		
		ret

e0_m16_FMA4 endp


e1_m16_AVX2 proc ptr_s:dword,n:dword

	public e1_m16_AVX2

		mov eax,ptr_s
		mov ecx,n
eloop8:
		vmovaps ymm0,YMMWORD ptr [eax]
		vminps ymm0,ymm0,YMMWORD ptr exp_hi
		vmaxps ymm0,ymm0,YMMWORD ptr exp_lo
		vmulps ymm0,ymm0,YMMWORD ptr e1_scale
		vmovaps ymm1,ymm0
		vaddps ymm0,ymm0,YMMWORD ptr e1_bias
		vpslld ymm2,ymm0,23
		vsubps ymm0,ymm0,YMMWORD ptr e1_bias
		vsubps ymm1,ymm1,ymm0
		vmulps ymm0,ymm1,YMMWORD ptr e1_c1
		vmulps ymm1,ymm1,ymm1
		vmulps ymm1,ymm1,YMMWORD ptr e1_c2
		vaddps ymm0,ymm0,YMMWORD ptr e1_c0
		vaddps ymm0,ymm0,ymm1
		vpaddd ymm0,ymm0,ymm2
		vmovaps YMMWORD ptr [eax],ymm0
		add eax,32
		sub ecx,8
		jnz short eloop8
		
		vzeroupper
		
		ret
		
e1_m16_AVX2 endp


e2_m16_AVX2 proc ptr_s:dword,n:dword

	public e2_m16_AVX2

		mov eax,ptr_s
		mov ecx,n
eloop4:
		vmovaps ymm0,YMMWORD ptr [eax]
		vminps ymm0,ymm0,YMMWORD ptr exp_hi
		vmaxps ymm0,ymm0,YMMWORD ptr exp_lo
		vmulps ymm1,ymm0,YMMWORD ptr exp_rln2
		vxorps ymm2,ymm2,ymm2
		vaddps ymm1,ymm1,YMMWORD ptr am_0p5
		vcmpnltps ymm2,ymm2,ymm1
		vpand ymm2,ymm2,YMMWORD ptr epi32_1
		vcvttps2dq ymm1,ymm1
		vpsubd ymm1,ymm1,ymm2
		vmovaps ymm5,YMMWORD ptr exp_c1
		vcvtdq2ps ymm3,ymm1
		vmulps ymm4,ymm3,YMMWORD ptr exp_c2
		vmulps ymm5,ymm5,ymm3
		vsubps ymm0,ymm0,ymm4
		vsubps ymm0,ymm0,ymm5
		vpaddd ymm1,ymm1,YMMWORD ptr epi32_0x7f
		vmovaps ymm2,ymm0
		vmulps ymm0,ymm0,ymm0
		vmulps ymm6,ymm0,YMMWORD ptr exp_q0
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
		vaddps ymm0,ymm2,YMMWORD ptr am_1
		vmulps ymm0,ymm0,ymm1
		vmovaps YMMWORD ptr [eax],ymm0
		add eax,32
		sub ecx,8
		jnz eloop4
		
		vzeroupper
		
		ret
		
e2_m16_AVX2 endp


end
