;
;                    nnedi3 for Avs+/Avisynth 2.6.x
;
;   Copyright (C) 2010-2011 Kevin Stone
;
;   This program is free software; you can redistribute it and/or modify
;   it under the terms of the GNU General Public License as published by
;   the Free Software Foundation; either version 2 of the License, or
;   (at your option) any later version.
;
;   This program is distributed in the hope that it will be useful,
;   but WITHOUT ANY WARRANTY; without even the implied warranty of
;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;   GNU General Public License for more details.
;
;   You should have received a copy of the GNU General Public License
;   along with this program; if not, write to the Free Software
;   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
;
;   Modified by JPSDR
;

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

data segment align(64)

exp_hi real4 16 dup(80.0)
exp_lo real4 16 dup(-80.0)

; exp from:  A Fast, Compact Approximation of the Exponential Function (1998)
;            Nicol N. Schraudolph

e0_mult real4 16 dup(12102203.161561486)   ; (1.0/ln(2))*(2^23)
e0_bias real4 16 dup(1064866805.0)         ; (2^23)*127.0-486411.0

; exp from Loren Merritt

e1_scale real4 16 dup(1.4426950409)        ; 1/ln(2)
e1_bias real4 16 dup(12582912.0)           ; 3<<22
e1_c1 real4 16 dup(0.701277797)
e1_c2 real4 16 dup(0.237348593)
e1_c0 real4 16 dup(1.00035)

; exp from Intel Approximate Math (AM) Library

exp_rln2 real4 16 dup(1.442695041)
am_0p5 real4 16 dup(0.5)
epi32_1 sdword 16 dup(1)
exp_c2 real4 16 dup(1.428606820e-6)
exp_c1 real4 16 dup(6.931457520e-1)
exp_q0 real4 16 dup(3.001985051e-6)
exp_p0 real4 16 dup(1.261771931e-4)
epi32_0x7f sdword 16 dup(7Fh)
exp_q1 real4 16 dup(2.524483403e-3)
exp_p1 real4 16 dup(3.029944077e-2)
exp_q2 real4 16 dup(2.272655482e-1)
am_1 real4 16 dup(1.0)
exp_q3 real4 16 dup(2.0)

w_19 sword 32 dup(19)
w_3 sword 32 dup(3)
uw_16 word 32 dup(16)
ub_1 byte 64 dup(1)

d_19 sdword 16 dup(19)
d_3 sdword 16 dup(3)
ud_16 dword 16 dup(16)
uw_1 word 32 dup(1)

f_19 real4 16 dup(0.59375)
f_3 real4 16 dup(0.09375)

sign_bits_f_32 qword 8 dup(7FFFFFFF7FFFFFFFh)
ones_f_32 real4 16 dup(1.0)

.code


;computeNetwork0_i16_AVX512 proc inputf:dword,weightsf:dword,ptr_d:dword
; inputf = rcx
; weightsf = rdx
; ptr_d = r8

computeNetwork0_i16_AVX512 proc public frame

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

		mov rax,1

		vmovdqa64 zmm7,ZMMWORD ptr [rcx]
		vpmaddwd zmm0,zmm7,ZMMWORD ptr [rdx]
		vpmaddwd zmm1,zmm7,ZMMWORD ptr [rdx+64]
		vpmaddwd zmm2,zmm7,ZMMWORD ptr [rdx+128]
		vpmaddwd zmm3,zmm7,ZMMWORD ptr [rdx+192]
		
		vmovdqa64 zmm7,ZMMWORD ptr [rcx+64]
		vpmaddwd zmm4,zmm7,ZMMWORD ptr [rdx+256]
		vpmaddwd zmm5,zmm7,ZMMWORD ptr [rdx+320]
		vpmaddwd zmm6,zmm7,ZMMWORD ptr [rdx+384]
		vpmaddwd zmm7,zmm7,ZMMWORD ptr [rdx+448]
		vpaddd zmm0,zmm0,zmm4
		vpaddd zmm1,zmm1,zmm5
		vpaddd zmm2,zmm2,zmm6
		vpaddd zmm3,zmm3,zmm7

		vmovdqa ymm8,ymm0
		vmovdqa ymm9,ymm1
		
		vextracti32x8 ymm6,zmm0,1
		vextracti32x8 ymm5,zmm1,1
		vextracti32x8 ymm7,zmm2,1
		vextracti32x8 ymm4,zmm3,1

		vpunpckhqdq ymm0,ymm6,ymm5
		vpunpckhqdq ymm1,ymm2,ymm4
		vpunpcklqdq ymm6,ymm6,ymm5
		vpunpcklqdq ymm7,ymm7,ymm4
		vpaddd ymm6,ymm6,ymm0
		vpaddd ymm7,ymm7,ymm1

		vmovdqa ymm0,ymm8
		vmovdqa ymm1,ymm9
		
		vpunpckhqdq ymm4,ymm0,ymm1
		vpunpckhqdq ymm5,ymm2,ymm3
		vpunpcklqdq ymm0,ymm0,ymm1
		vpunpcklqdq ymm2,ymm2,ymm3
		vpaddd ymm0,ymm0,ymm4
		vpaddd ymm2,ymm2,ymm5

		vpaddd ymm0,ymm0,ymm6
		vpaddd ymm2,ymm2,ymm7

		vextracti128 xmm4,ymm0,1
		vextracti128 xmm5,ymm2,1
		vpaddd xmm0,xmm0,xmm4
		vpaddd xmm2,xmm2,xmm5
		
		vshufps xmm6,xmm0,xmm2,221
		vshufps xmm0,xmm0,xmm2,136
		vpaddd xmm0,xmm0,xmm6
		vcvtdq2ps xmm0,xmm0
		vmulps xmm0,xmm0,XMMWORD ptr [rdx+512]
		vaddps xmm0,xmm0,XMMWORD ptr [rdx+528]
		vmovaps xmm1,xmm0
		vandps xmm0,xmm0,XMMWORD ptr sign_bits_f_zero_l
		vaddps xmm0,xmm0,XMMWORD ptr ones_f
		vrcpps xmm0,xmm0
		vmulps xmm0,xmm0,xmm1
		vpshufd xmm1,xmm0,0
		vpshufd xmm2,xmm0,85
		vpshufd xmm3,xmm0,170
		vpshufd xmm4,xmm0,255
		vmulps xmm1,xmm1,XMMWORD ptr [rdx+544]
		vmulps xmm2,xmm2,XMMWORD ptr [rdx+544+16]
		vmulps xmm3,xmm3,XMMWORD ptr [rdx+544+32]
		vmulps xmm4,xmm4,XMMWORD ptr [rdx+544+48]
		vaddps xmm1,xmm1,xmm2
		vaddps xmm3,xmm3,xmm4
		vaddps xmm1,xmm1,xmm3
		vaddps xmm1,xmm1,XMMWORD ptr [rdx+544+64]
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
		vmulps xmm0,xmm0,XMMWORD ptr [rdx+624]
		vmulps xmm1,xmm1,XMMWORD ptr [rdx+624+16]
		vmulps xmm2,xmm2,XMMWORD ptr [rdx+624+32]
		vmulps xmm3,xmm3,XMMWORD ptr [rdx+624+48]
		vpshufd xmm4,xmm7,0
		vpshufd xmm5,xmm7,85
		vpshufd xmm6,xmm7,170
		vpshufd xmm7,xmm7,255
		vmulps xmm4,xmm4,XMMWORD ptr [rdx+624+64]
		vmulps xmm5,xmm5,XMMWORD ptr [rdx+624+80]
		vmulps xmm6,xmm6,XMMWORD ptr [rdx+624+96]
		vmulps xmm7,xmm7,XMMWORD ptr [rdx+624+112]
		vaddps xmm0,xmm0,xmm1
		vaddps xmm2,xmm2,xmm3
		vaddps xmm4,xmm4,xmm5
		vaddps xmm6,xmm6,xmm7
		vaddps xmm0,xmm0,xmm2
		vaddps xmm4,xmm4,xmm6
		vaddps xmm0,xmm0,xmm4
		mov rcx,r8
		vaddps xmm0,xmm0,XMMWORD ptr [rdx+624+128]
		vmovhlps xmm1,xmm1,xmm0
		vmaxps xmm0,xmm0,xmm1
		vpshuflw xmm1,xmm0,14
		vcomiss xmm1,xmm0
		jbe short finish_2
		xor rax,rax
finish_2:
		mov BYTE PTR[rcx],al
			
	vmovdqu xmm9,XMMWORD ptr[rsp+48]
	vmovdqu xmm8,XMMWORD ptr[rsp+32]
	vmovdqu xmm7,XMMWORD ptr[rsp+16]
	vmovdqu xmm6,XMMWORD ptr[rsp]
	add rsp,64
		
		vzeroupper
		
		ret
		
computeNetwork0_i16_AVX512 endp


;computeNetwork0new_AVX512 proc datai:dword,weights:dword,ptr_d:dword
; datai = rcx
; weights = rdx
; ptr_d = r8

computeNetwork0new_AVX512 proc public frame

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

		mov rax,rdx

		vmovdqa64 zmm7,ZMMWORD ptr [rcx]
		vpmaddwd zmm0,zmm7,ZMMWORD ptr [rax]
		vpmaddwd zmm1,zmm7,ZMMWORD ptr [rax+64]
		vpmaddwd zmm2,zmm7,ZMMWORD ptr [rax+128]
		vpmaddwd zmm3,zmm7,ZMMWORD ptr [rax+192]
		
		vmovdqa64 zmm7,ZMMWORD ptr [rcx+64]
		vpmaddwd zmm4,zmm7,ZMMWORD ptr [rax+256]
		vpmaddwd zmm5,zmm7,ZMMWORD ptr [rax+320]
		vpmaddwd zmm6,zmm7,ZMMWORD ptr [rax+384]
		vpmaddwd zmm7,zmm7,ZMMWORD ptr [rax+448]
		vpaddd zmm0,zmm0,zmm4
		vpaddd zmm1,zmm1,zmm5
		vpaddd zmm2,zmm2,zmm6
		vpaddd zmm3,zmm3,zmm7
		
		vextracti32x8 ymm6,zmm0,1
		vextracti32x8 ymm5,zmm1,1
		vextracti32x8 ymm7,zmm2,1
		vextracti32x8 ymm4,zmm3,1

		vpunpckhqdq ymm8,ymm6,ymm5
		vpunpckhqdq ymm9,ymm7,ymm4
		vpunpcklqdq ymm6,ymm6,ymm5
		vpunpcklqdq ymm7,ymm7,ymm4
		vpaddd ymm6,ymm6,ymm8
		vpaddd ymm7,ymm7,ymm9

		vpunpckhqdq ymm4,ymm0,ymm1
		vpunpckhqdq ymm5,ymm2,ymm3
		vpunpcklqdq ymm0,ymm0,ymm1
		vpunpcklqdq ymm2,ymm2,ymm3
		vpaddd ymm0,ymm0,ymm4
		vpaddd ymm2,ymm2,ymm5

		vpaddd ymm0,ymm0,ymm6
		vpaddd ymm2,ymm2,ymm7

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
		
	vmovdqu xmm9,XMMWORD ptr[rsp+48]
	vmovdqu xmm8,XMMWORD ptr[rsp+32]	
	vmovdqu xmm7,XMMWORD ptr[rsp+16]
	vmovdqu xmm6,XMMWORD ptr[rsp]	
	add rsp,64
		
		vzeroupper
		
		ret
		
computeNetwork0new_AVX512 endp


; From FMA3
;computeNetwork0_AVX512 proc input:dword,weights:dword,ptr_d:dword
; input = rcx
; weights = rdx
; ptr_d = r8

computeNetwork0_AVX512 proc public frame

	sub rsp,32
	.allocstack 32
	vmovdqu XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqu XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog
	
		mov rax,1

		vmovaps zmm4,ZMMWORD ptr [rcx]
		vmulps zmm0,zmm4,ZMMWORD ptr [rdx]
		vmulps zmm1,zmm4,ZMMWORD ptr [rdx+64]
		vmulps zmm2,zmm4,ZMMWORD ptr [rdx+128]
		vmulps zmm3,zmm4,ZMMWORD ptr [rdx+192]
		
		vmovaps zmm4,ZMMWORD ptr [rcx+64]

		vfmadd231ps zmm0,zmm4,ZMMWORD ptr [rdx+256]
		vfmadd231ps zmm1,zmm4,ZMMWORD ptr [rdx+320]
		vfmadd231ps zmm2,zmm4,ZMMWORD ptr [rdx+384]
		vfmadd231ps zmm3,zmm4,ZMMWORD ptr [rdx+448]
	
		vmovaps zmm4,ZMMWORD ptr [rcx+128]
		
		vfmadd231ps zmm0,zmm4,ZMMWORD ptr [rdx+512]
		vfmadd231ps zmm1,zmm4,ZMMWORD ptr [rdx+576]
		vfmadd231ps zmm2,zmm4,ZMMWORD ptr [rdx+640]
		vfmadd231ps zmm3,zmm4,ZMMWORD ptr [rdx+704]
		
		vextractf32x8 ymm6,zmm0,1
		vextractf32x8 ymm5,zmm1,1
		vextractf32x8 ymm7,zmm2,1
		vextractf32x8 ymm4,zmm3,1
		
		vhaddps ymm0,ymm0,ymm1
		vhaddps ymm2,ymm2,ymm3
		vhaddps ymm0,ymm0,ymm2

		vhaddps ymm6,ymm6,ymm5
		vhaddps ymm7,ymm7,ymm4
		vhaddps ymm6,ymm6,ymm7
		
		vaddps ymm0,ymm0,ymm6

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
		jbe short finish_1a
		xor rax,rax
finish_1a:
		mov BYTE PTR[rcx],al
				
	vmovdqu xmm7,XMMWORD ptr[rsp+16]
	vmovdqu xmm6,XMMWORD ptr[rsp]
	add rsp,32		
		
	vzeroupper
		
		ret

computeNetwork0_AVX512 endp


;processLine0_AVX512_ASM proc tempu:dword,width_:dword,dstp:dword,src3p:dword,src_pitch:dword,val_min_max:dword
; tempu = rcx
; width_ = edx
; dstp = r8
; src3p = r9

processLine0_AVX512_ASM proc public frame

src_pitch equ dword ptr[rbp+48]
val_min_max equ qword ptr[rbp+56]

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
			
		mov rax,rcx
		mov rbx,r9
		xor rcx,rcx
		mov ecx,edx
		movsxd rdx,src_pitch
		mov rsi,r8
		mov r8,64
		mov r10,val_min_max
		
		lea rdi,[rbx+rdx*4]
		
		vmovdqa64 zmm8,ZMMWORD ptr w_19
		vmovdqa64 zmm9,ZMMWORD ptr w_3
		vmovdqa64 zmm10,ZMMWORD ptr ub_1
		vmovdqa64 zmm11,ZMMWORD ptr uw_16		
		vmovdqa64 zmm12,ZMMWORD ptr[r10]
		vmovdqa64 zmm13,ZMMWORD ptr[r10+r8]
		vpxord zmm6,zmm6,zmm6
		vpxord zmm7,zmm7,zmm7
		
xloop:
		vmovdqu64 zmm0,ZMMWORD PTR [rbx+rdx*2]
		vmovdqu64 zmm1,ZMMWORD PTR [rdi]
		vpunpckhbw zmm2,zmm0,zmm7
		vpunpckhbw zmm3,zmm1,zmm7
		vpunpcklbw zmm0,zmm0,zmm7
		vpunpcklbw zmm1,zmm1,zmm7
		vpaddw zmm0,zmm0,zmm1
		vpaddw zmm2,zmm2,zmm3
		vpmullw zmm0,zmm0,zmm8
		vpmullw zmm2,zmm2,zmm8

		vmovdqu64 zmm1,ZMMWORD PTR [rbx]
		vmovdqu64 zmm3,ZMMWORD PTR [rdi+rdx*2]
		vpunpckhbw zmm4,zmm1,zmm7
		vpunpckhbw zmm5,zmm3,zmm7
		vpunpcklbw zmm1,zmm1,zmm7
		vpunpcklbw zmm3,zmm3,zmm7
		vpaddw zmm1,zmm1,zmm3
		vpaddw zmm4,zmm4,zmm5
		vpmullw zmm1,zmm1,zmm9
		vpmullw zmm4,zmm4,zmm9

		vmovdqu64 zmm5,ZMMWORD PTR [rax]
		vpsubusw zmm0,zmm0,zmm1
		vpsubusw zmm2,zmm2,zmm4
		vpxord zmm5,zmm5,zmm10
		vpaddusw zmm0,zmm0,zmm11
		vpaddusw zmm2,zmm2,zmm11
		vpsadbw zmm5,zmm5,zmm7		
		vpsraw zmm0,zmm0,5
		vpsraw zmm2,zmm2,5

		vmovdqa64 zmm3,zmm5
		vpminuw zmm0,zmm0,zmm13
		vpsrldq zmm5,zmm5,8
		vpminuw zmm2,zmm2,zmm13
		vpaddusw zmm5,zmm5,zmm3
		vpmaxuw zmm0,zmm0,zmm12
		vpmaxuw zmm2,zmm2,zmm12

		vextracti32x8 ymm1,zmm5,1

		vextracti128 xmm3,ymm5,1
		vextracti128 xmm4,ymm1,1

		vpackuswb zmm0,zmm0,zmm2

		vpaddusw xmm5,xmm5,xmm3
		vpaddusw xmm1,xmm1,xmm4

		vmovdqu64 ZMMWORD PTR [rsi],zmm0

		vpaddusw xmm6,xmm6,xmm5		
		vpaddusw xmm6,xmm6,xmm1
		
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
		
processLine0_AVX512_ASM endp


;processLine0_AVX512_ASM_16 proc tempu:dword,width_:dword,dstp:dword,src3p:dword,src_pitch:dword,val_min_max:dword
; tempu = rcx
; width_ = edx
; dstp = r8
; src3p = r9

processLine0_AVX512_ASM_16 proc public frame

src_pitch equ dword ptr[rbp+48]
val_min_max equ qword ptr[rbp+56]

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
		
		mov rax,rcx
		mov rbx,r9
		xor rcx,rcx
		mov ecx,edx
		movsxd rdx,src_pitch
		mov rsi,r8
		mov r8,64
		mov r9,32
		mov r10,val_min_max
			
		lea rdi,[rbx+rdx*4]
		
		vmovdqa64 zmm8,ZMMWORD ptr d_19
		vmovdqa64 zmm9,ZMMWORD ptr d_3
		vmovdqa ymm10,YMMWORD ptr ub_1
		vmovdqa64 zmm11,ZMMWORD ptr ud_16
		vmovdqa64 zmm12,ZMMWORD ptr[r10]
		vmovdqa64 zmm13,ZMMWORD ptr[r10+r8]

		vpxord zmm6,zmm6,zmm6
		vpxord zmm7,zmm7,zmm7
		
xloop_16:
		vmovdqa64 zmm0,ZMMWORD ptr[rbx+rdx*2]
		vmovdqa64 zmm1,ZMMWORD ptr[rdi]
		vpunpckhwd zmm2,zmm0,zmm7
		vpunpckhwd zmm3,zmm1,zmm7
		vpunpcklwd zmm0,zmm0,zmm7
		vpunpcklwd zmm1,zmm1,zmm7
		vpaddd zmm0,zmm0,zmm1
		vpaddd zmm2,zmm2,zmm3
		vpmulld zmm0,zmm0,zmm8
		vpmulld zmm2,zmm2,zmm8

		vmovdqa64 zmm1,ZMMWORD ptr[rbx]
		vmovdqa64 zmm3,ZMMWORD ptr[rdi+rdx*2]
		vpunpckhwd zmm4,zmm1,zmm7
		vpunpckhwd zmm5,zmm3,zmm7
		vpunpcklwd zmm1,zmm1,zmm7
		vpunpcklwd zmm3,zmm3,zmm7
		vpaddd zmm1,zmm1,zmm3
		vpaddd zmm4,zmm4,zmm5
		vpmulld zmm1,zmm1,zmm9
		vpmulld zmm4,zmm4,zmm9

		vmovdqa ymm5,YMMWORD ptr [rax]
		vpsubd zmm0,zmm0,zmm1
		vpsubd zmm2,zmm2,zmm4
		vpxor ymm5,ymm5,ymm10
		vpaddd zmm0,zmm0,zmm11
		vpaddd zmm2,zmm2,zmm11
		vpsadbw ymm5,ymm5,ymm7
		vpsrad zmm0,zmm0,5		
		vpsrad zmm2,zmm2,5
		vmovdqa ymm3,ymm5

		vpackusdw zmm0,zmm0,zmm2
		vpsrldq ymm5,ymm5,8
		vpminuw zmm0,zmm0,zmm13
		vpaddusw ymm5,ymm5,ymm3
		vpmaxuw zmm0,zmm0,zmm12

		vextracti128 xmm3,ymm5,1
		vmovdqa64 ZMMWORD ptr [rsi],zmm0

		vpaddusw xmm5,xmm5,xmm3
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
		
processLine0_AVX512_ASM_16 endp


;processLine0_AVX512_ASM_32 proc tempu:dword,width_:dword,dstp:dword,src3p:dword,src_pitch:dword
; tempu = rcx
; width_ = edx
; dstp = r8
; src3p = r9

processLine0_AVX512_ASM_32 proc public frame

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
	sub rsp,80
	.allocstack 80
	vmovdqu XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqu XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	vmovdqu XMMWORD ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	vmovdqu XMMWORD ptr[rsp+48],xmm9
	.savexmm128 xmm9,48
	vmovdqu XMMWORD ptr[rsp+64],xmm10
	.savexmm128 xmm9,64
	.endprolog

		mov rax,rcx
		mov rbx,r9
		xor rcx,rcx
		mov ecx,edx
		movsxd rdx,src_pitch
		mov rsi,r8
		mov r8,64
		mov r9,16
		
		lea rdi,[rbx+rdx*4]

		vpxord zmm5,zmm5,zmm5
		vpxord zmm6,zmm6,zmm6
		vmovaps zmm7,ZMMWORD ptr f_19
		vmovaps zmm8,ZMMWORD ptr f_3
		vmovdqa xmm9,XMMWORD ptr uw_1
		
xloop_32:
		vmovdqa xmm4,XMMWORD ptr [rax]
		vmovaps zmm2,ZMMWORD ptr[rbx]		
		vmovaps zmm0,ZMMWORD ptr[rbx+rdx*2]
		vpunpckhbw xmm10,xmm4,xmm6
		vpunpcklbw xmm4,xmm4,xmm6

		vmovaps zmm1,ZMMWORD ptr[rdi]
		vmovaps zmm3,ZMMWORD ptr[rdi+rdx*2]		
		vaddps zmm0,zmm0,zmm1
		vpxor xmm4,xmm4,xmm9		
		vpxor xmm10,xmm10,xmm9		
		vaddps zmm2,zmm2,zmm3		
		vpsadbw xmm4,xmm4,xmm6
		vpsadbw xmm10,xmm10,xmm6

		vmulps zmm0,zmm0,zmm7
		vmovdqa xmm3,xmm4
		vmovdqa xmm1,xmm10
		vmulps zmm2,zmm2,zmm8
		vpsrldq xmm4,xmm4,8
		vpsrldq xmm10,xmm10,8
		vpaddusw xmm4,xmm4,xmm3
		vpaddusw xmm10,xmm10,xmm1
		vsubps zmm0,zmm0,zmm2

		vpaddusw xmm4,xmm4,xmm10
		vmovaps ZMMWORD ptr[rsi],zmm0
		vpaddusw xmm5,xmm5,xmm4

		add rbx,r8
		add rdi,r8
		add rax,r9
		add rsi,r8
		sub rcx,r9
		jnz xloop_32
				
		xor  rax,rax
		vmovd eax,xmm5
		
	vmovdqu xmm10,XMMWORD ptr[rsp+64]
	vmovdqu xmm9,XMMWORD ptr[rsp+48]
	vmovdqu xmm8,XMMWORD ptr[rsp+32]
	vmovdqu xmm7,XMMWORD ptr[rsp+16]
	vmovdqu xmm6,XMMWORD ptr[rsp]	
	add rsp,80
	pop rdi
	pop rsi
	pop rbx
	pop rbp
			
	vzeroupper		
			
		ret
		
processLine0_AVX512_ASM_32 endp


; From FMA3
;weightedAvgElliottMul5_m16_AVX512 proc ptr_w:dword,n:dword,mstd:dword
; ptr_w = rcx
; n = edx
; mstd = r8

weightedAvgElliottMul5_m16_AVX512 proc public frame

	push rdi
	.pushreg rdi
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
		xor rcx,rcx
		mov ecx,edx
		
		mov r9,16
		vmovdqa64 zmm6,ZMMWORD ptr sign_bits_f_32
		vmovaps zmm7,ZMMWORD ptr ones_f_32
	
		lea rdx,[rax+rcx*4]
		xor rdi,rdi
		vxorps zmm0,zmm0,zmm0
		vxorps zmm1,zmm1,zmm1
		
nloop_52:
		vmovaps zmm2,ZMMWORD ptr [rax+rdi*4]
		vmovaps zmm4,ZMMWORD ptr [rdx+rdi*4]
		vaddps zmm0,zmm0,zmm2
		vandps zmm5,zmm4,zmm6
		vaddps zmm5,zmm5,zmm7

		vextractf32x8 ymm8,zmm5,1
		vrcpps ymm5,ymm5
		vrcpps ymm8,ymm8
		vinsertf32x8 zmm5,zmm5,ymm8,1

		vmulps zmm4,zmm4,zmm5
		vfmadd231ps zmm1,zmm2,zmm4
		
		add rdi,r9
		sub rcx,r9
		jnz short nloop_52

		vextractf32x8 ymm2,zmm0,1
		vextractf32x8 ymm3,zmm1,1
		
		vaddps ymm0,ymm0,ymm2
		vaddps ymm1,ymm1,ymm3

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
		vmulss xmm1,xmm1,dword ptr[r8+4]
		vaddss xmm1,xmm1,dword ptr[r8]
		vaddss xmm1,xmm1,dword ptr[r8+12]
		vmovss dword ptr[r8+12],xmm1
		
	vmovdqa xmm8,XMMWORD ptr[rsp+32]
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]	
	add rsp,48
		
		pop rdi
		
		ret
		
weightedAvgElliottMul5_m16_AVX512 endp


; From FMA3
;dotProd_m32_m16_AVX512 proc data_:dword,weights:dword,vals:dword,n:dword,len:dword,istd:dword
; data_ = rcx
; weights = rdx
; vals = r8
; n = r9d

dotProd_m32_m16_AVX512 proc public frame

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
		vxorps zmm0,zmm0,zmm0
		vxorps zmm1,zmm1,zmm1
		vxorps zmm2,zmm2,zmm2
		vxorps zmm3,zmm3,zmm3
		mov rdx,rsi
lloop_2:
		vmovaps zmm7,ZMMWORD ptr[rcx]
		vfmadd231ps zmm0,zmm7,ZMMWORD ptr[rdi]
		vfmadd231ps zmm1,zmm7,ZMMWORD ptr[rdi+2*r12]
		vfmadd231ps zmm2,zmm7,ZMMWORD ptr[rdi+r13]
		vfmadd231ps zmm3,zmm7,ZMMWORD ptr[rdi+192]
		
		vmovaps zmm7,ZMMWORD ptr[rcx+2*r12]
		vfmadd231ps zmm0,zmm7,ZMMWORD ptr[rdi+2*r13]
		vfmadd231ps zmm1,zmm7,ZMMWORD ptr[rdi+320]
		vfmadd231ps zmm2,zmm7,ZMMWORD ptr[rdi+384]
		vfmadd231ps zmm3,zmm7,ZMMWORD ptr[rdi+448]
				
		add rcx,r13
		add rdi,r14
		sub rdx,r12
		jnz short lloop_2
		
		vextractf32x8 ymm4,zmm0,1
		vextractf32x8 ymm5,zmm1,1
		vextractf32x8 ymm6,zmm2,1
		vextractf32x8 ymm7,zmm3,1
		
		vaddps ymm0,ymm0,ymm4
		vaddps ymm1,ymm1,ymm5
		vaddps ymm2,ymm2,ymm6
		vaddps ymm3,ymm3,ymm7
				
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
		
dotProd_m32_m16_AVX512 endp


; From FMA3
;dotProd_m48_m16_AVX512 proc data_:dword,weights:dword,vals:dword,n:dword,len:dword,istd:dword
; data_ = rcx
; weights = rdx
; vals = r8
; n = r9d

dotProd_m48_m16_AVX512 proc public frame

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
		vmovaps zmm7,ZMMWORD ptr[rcx]
		vfmadd231ps zmm0,zmm7,ZMMWORD ptr[rdi]
		vfmadd231ps zmm1,zmm7,ZMMWORD ptr[rdi+4*r11]
		vfmadd231ps zmm2,zmm7,ZMMWORD ptr[rdi+8*r11]
		vfmadd231ps zmm3,zmm7,ZMMWORD ptr[rdi+r13]
				
		vmovaps zmm7,ZMMWORD ptr[rcx+4*r11]
		vfmadd231ps zmm0,zmm7,ZMMWORD ptr[rdi+256]
		vfmadd231ps zmm1,zmm7,ZMMWORD ptr[rdi+320]
		vfmadd231ps zmm2,zmm7,ZMMWORD ptr[rdi+2*r13]
		vfmadd231ps zmm3,zmm7,ZMMWORD ptr[rdi+448]
		
		vmovaps zmm7,ZMMWORD ptr[rcx+8*r11]
		vfmadd231ps zmm0,zmm7,ZMMWORD ptr[rdi+512]
		vfmadd231ps zmm1,zmm7,ZMMWORD ptr[rdi+576]
		vfmadd231ps zmm2,zmm7,ZMMWORD ptr[rdi+640]
		vfmadd231ps zmm3,zmm7,ZMMWORD ptr[rdi+704]
						
		add rcx,r13
		add rdi,r14
		sub rdx,r12
		jnz short lloop2_2

		vextractf32x8 ymm4,zmm0,1
		vextractf32x8 ymm5,zmm1,1
		vextractf32x8 ymm6,zmm2,1
		vextractf32x8 ymm7,zmm3,1
		
		vaddps ymm0,ymm0,ymm4
		vaddps ymm1,ymm1,ymm5
		vaddps ymm2,ymm2,ymm6
		vaddps ymm3,ymm3,ymm7

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
		
dotProd_m48_m16_AVX512 endp


;dotProd_m32_m16_i16_AVX512 proc dataf:dword,weightsf:dword,vals:dword,n:dword,len:dword,istd:dword
; dataf = rcx
; weightsf = rdx
; vals = r8
; n = r9d

dotProd_m32_m16_i16_AVX512 proc public frame

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
		vpxord zmm0,zmm0,zmm0
		vpxord zmm1,zmm1,zmm1
		vpxord zmm2,zmm2,zmm2
		vpxord zmm3,zmm3,zmm3
		mov rdx,rsi
lloop_3:
		vmovdqa64 zmm7,ZMMWORD ptr [rcx]
		vpmaddwd zmm4,zmm7,ZMMWORD ptr [rdi]
		vpmaddwd zmm5,zmm7,ZMMWORD ptr [rdi+r13]
		vpmaddwd zmm6,zmm7,ZMMWORD ptr [rdi+2*r13]
		vpmaddwd zmm7,zmm7,ZMMWORD ptr [rdi+192]
		vpaddd zmm0,zmm0,zmm4
		vpaddd zmm1,zmm1,zmm5
		vpaddd zmm2,zmm2,zmm6
		vpaddd zmm3,zmm3,zmm7

		add rcx,r13
		add rdi,r14
		sub rdx,r12
		jnz short lloop_3

		vextracti32x8 ymm4,zmm0,1
		vextracti32x8 ymm5,zmm1,1
		vextracti32x8 ymm6,zmm2,1
		vextracti32x8 ymm7,zmm3,1

		vpaddd ymm0,ymm0,ymm4
		vpaddd ymm1,ymm1,ymm5
		vpaddd ymm2,ymm2,ymm6
		vpaddd ymm3,ymm3,ymm7

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
		
dotProd_m32_m16_i16_AVX512 endp


;dotProd_m64_m16_i16_AVX512 proc dataf:dword,weightsf:dword,vals:dword,n:dword,len:dword,istd:dword
; dataf = rcx
; weightsf = rdx
; vals = r8
; n = r9d

dotProd_m64_m16_i16_AVX512 proc public frame

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
		mov r12,64
		mov r13,128
		mov r14,512
		
nloop_4:
		mov rcx,r15
		vpxord zmm0,zmm0,zmm0
		vpxord zmm1,zmm1,zmm1
		vpxord zmm2,zmm2,zmm2
		vpxord zmm3,zmm3,zmm3
		mov rdx,rsi
lloop_4:
		vmovdqa64 zmm7,ZMMWORD ptr [rcx]
		vpmaddwd zmm4,zmm7,ZMMWORD ptr [rdi]
		vpmaddwd zmm5,zmm7,ZMMWORD ptr [rdi+r12]
		vpmaddwd zmm6,zmm7,ZMMWORD ptr [rdi+r13]
		vpmaddwd zmm7,zmm7,ZMMWORD ptr [rdi+192]
		vpaddd zmm0,zmm0,zmm4
		vpaddd zmm1,zmm1,zmm5
		vpaddd zmm2,zmm2,zmm6
		vpaddd zmm3,zmm3,zmm7

		vmovdqa64 zmm7,ZMMWORD ptr [rcx+r12]
		vpmaddwd zmm4,zmm7,ZMMWORD ptr [rdi+2*r13]
		vpmaddwd zmm5,zmm7,ZMMWORD ptr [rdi+320]
		vpmaddwd zmm6,zmm7,ZMMWORD ptr [rdi+384]
		vpmaddwd zmm7,zmm7,ZMMWORD ptr [rdi+448]
		vpaddd zmm0,zmm0,zmm4
		vpaddd zmm1,zmm1,zmm5
		vpaddd zmm2,zmm2,zmm6
		vpaddd zmm3,zmm3,zmm7

		add rcx,r13
		add rdi,r14
		sub rdx,r12
		jnz short lloop_4

		vextracti32x8 ymm4,zmm0,1
		vextracti32x8 ymm5,zmm1,1
		vextracti32x8 ymm6,zmm2,1
		vextracti32x8 ymm7,zmm3,1

		vpaddd ymm0,ymm0,ymm4
		vpaddd ymm1,ymm1,ymm5
		vpaddd ymm2,ymm2,ymm6
		vpaddd ymm3,ymm3,ymm7

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

dotProd_m64_m16_i16_AVX512 endp


; From FMA3
;e0_m16_AVX512 proc ptr_s:dword,n:dword
; ptr_s = rcx
; n = edx

e0_m16_AVX512 proc public frame

	.endprolog
	
		mov rax,rcx
		xor rcx,rcx
		mov ecx,edx
		
		vmovaps zmm2,ZMMWORD ptr exp_hi
		vmovaps zmm3,ZMMWORD ptr exp_lo
		vmovaps zmm4,ZMMWORD ptr e0_mult
		vmovaps zmm5,ZMMWORD ptr e0_bias
				
		mov rdx,32
		mov r8,64
		mov r10,128
		
eloop16_2:
		vmovaps zmm0,ZMMWORD ptr[rax]
		vmovaps zmm1,ZMMWORD ptr[rax+r8]
		vminps zmm0,zmm0,zmm2
		vminps zmm1,zmm1,zmm2
		vmaxps zmm0,zmm0,zmm3
		vmaxps zmm1,zmm1,zmm3
		
		vfmadd213ps zmm0,zmm4,zmm5
		vfmadd213ps zmm1,zmm4,zmm5
				
		vcvtps2dq zmm0,zmm0
		vcvtps2dq zmm1,zmm1
		vmovaps ZMMWORD ptr[rax],zmm0
		vmovaps ZMMWORD ptr[rax+r8],zmm1

		add rax,r10
		sub rcx,rdx
		
		jnz short eloop16_2		
		
		vzeroupper
		
		ret

e0_m16_AVX512 endp


;e1_m16_AVX512 proc ptr_s:dword,n:dword
; ptr_s = rcx
; n = edx

e1_m16_AVX512 proc public frame

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
		xor rcx,rcx
		mov ecx,edx
		
		vmovaps zmm3,ZMMWORD ptr exp_hi
		vmovaps zmm4,ZMMWORD ptr exp_lo
		vmovaps zmm5,ZMMWORD ptr e1_scale
		vmovaps zmm6,ZMMWORD ptr e1_bias
		vmovaps zmm7,ZMMWORD ptr e1_c1
		vmovaps zmm8,ZMMWORD ptr e1_c2
		vmovaps zmm9,ZMMWORD ptr e1_c0
		
		mov rdx,16
		mov r8,64
		
eloop8:
		vmovaps zmm0,ZMMWORD ptr[rax]
		vminps zmm0,zmm0,zmm3
		vmaxps zmm0,zmm0,zmm4
		vmulps zmm0,zmm0,zmm5
		vmovaps zmm1,zmm0
		vaddps zmm0,zmm0,zmm6
		vpslld zmm2,zmm0,23
		vsubps zmm0,zmm0,zmm6
		vsubps zmm1,zmm1,zmm0
		vmulps zmm0,zmm1,zmm7
		vmulps zmm1,zmm1,zmm1
		vmulps zmm1,zmm1,zmm8
		vaddps zmm0,zmm0,zmm9
		vaddps zmm0,zmm0,zmm1
		vpaddd zmm0,zmm0,zmm2
		vmovaps ZMMWORD ptr[rax],zmm0
		add rax,r8
		sub rcx,rdx
		jnz short eloop8
		
	vmovdqu xmm9,XMMWORD ptr[rsp+48]
	vmovdqu xmm8,XMMWORD ptr[rsp+32]
	vmovdqu xmm7,XMMWORD ptr[rsp+16]
	vmovdqu xmm6,XMMWORD ptr[rsp]	
	add rsp,64
		
	vzeroupper
		
		ret
		
e1_m16_AVX512 endp


;e2_m16_AVX512 proc ptr_s:dword,n:dword
; ptr_s = rcx
; n = edx

e2_m16_AVX512 proc public frame

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
		
		vmovaps zmm7,ZMMWORD ptr exp_hi
		vmovaps zmm8,ZMMWORD ptr exp_lo
		vmovaps zmm9,ZMMWORD ptr exp_rln2
		vmovaps zmm10,ZMMWORD ptr am_0p5
		vmovaps zmm11,ZMMWORD ptr epi32_1
		vmovaps zmm12,ZMMWORD ptr exp_c2
		vmovaps zmm13,ZMMWORD ptr exp_c1
		vmovaps zmm14,ZMMWORD ptr exp_q0
		vmovaps zmm15,ZMMWORD ptr am_1
		
		mov rdx,16
		mov r8,64

eloop4:
		vmovaps zmm0,ZMMWORD ptr[rax]		
		vminps zmm0,zmm0,zmm7
		vmaxps zmm0,zmm0,zmm8
		vmulps zmm1,zmm0,zmm9
		vxorps zmm2,zmm2,zmm2
		vaddps zmm1,zmm1,zmm10

		vextractf32x8 ymm3,zmm1,1		
		vextractf32x8 ymm4,zmm2,1		
		vcmpnltps ymm2,ymm2,ymm1
		vcmpnltps ymm4,ymm4,ymm3
		vinsertf32x8 zmm2,zmm2,ymm4,1

		vpandd zmm2,zmm2,zmm11
		vcvttps2dq zmm1,zmm1
		vpsubd zmm1,zmm1,zmm2
		vmovaps zmm5,zmm13
		vcvtdq2ps zmm3,zmm1
		vmulps zmm4,zmm3,zmm12
		vmulps zmm5,zmm5,zmm3
		vsubps zmm0,zmm0,zmm4
		vsubps zmm0,zmm0,zmm5
		vpaddd zmm1,zmm1,ZMMWORD ptr epi32_0x7f
		vmovaps zmm2,zmm0
		vmulps zmm0,zmm0,zmm0
		vmulps zmm6,zmm0,zmm14
		vmulps zmm4,zmm0,ZMMWORD ptr exp_p0
		vaddps zmm6,zmm6,ZMMWORD ptr exp_q1
		vaddps zmm4,zmm4,ZMMWORD ptr exp_p1
		vmulps zmm6,zmm6,zmm0
		vmulps zmm4,zmm4,zmm0
		vaddps zmm6,zmm6,ZMMWORD ptr exp_q2
		vmulps zmm4,zmm4,zmm2
		vmulps zmm6,zmm6,zmm0
		vaddps zmm2,zmm2,zmm4
		vaddps zmm6,zmm6,ZMMWORD ptr exp_q3
		vpslld zmm1,zmm1,23
		vsubps zmm6,zmm6,zmm2

		vextractf32x8 ymm5,zmm6,1		
		vrcpps ymm6,ymm6
		vrcpps ymm5,ymm5
		vinsertf32x8 zmm6,zmm6,ymm5,1

		vmulps zmm2,zmm2,zmm6
		vaddps zmm2,zmm2,zmm2
		vaddps zmm0,zmm2,zmm15
		vmulps zmm0,zmm0,zmm1		
		vmovaps ZMMWORD ptr[rax],zmm0

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
		
e2_m16_AVX512 endp

end
