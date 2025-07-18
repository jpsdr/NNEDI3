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
; AVX512F,AVX512BW,AVX512DQ

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

SAVE_ZMM0 real4 16 dup(0.0)
SAVE_ZMM1 real4 16 dup(0.0)

.code


computeNetwork0_i16_AVX512 proc inputf:dword,weightsf:dword,ptr_d:dword

    public computeNetwork0_i16_AVX512

		mov ecx,inputf
		mov edx,weightsf
		mov eax,1
		
		vmovdqa64 zmm7,ZMMWORD ptr [ecx]
		vpmaddwd zmm0,zmm7,ZMMWORD ptr [edx]
		vpmaddwd zmm1,zmm7,ZMMWORD ptr [edx+64]
		vpmaddwd zmm2,zmm7,ZMMWORD ptr [edx+128]
		vpmaddwd zmm3,zmm7,ZMMWORD ptr [edx+192]
		
		vmovdqa64 zmm7,ZMMWORD ptr [ecx+64]
		vpmaddwd zmm4,zmm7,ZMMWORD ptr [edx+256]
		vpmaddwd zmm5,zmm7,ZMMWORD ptr [edx+320]
		vpmaddwd zmm6,zmm7,ZMMWORD ptr [edx+384]
		vpmaddwd zmm7,zmm7,ZMMWORD ptr [edx+448]
		vpaddd zmm0,zmm0,zmm4
		vpaddd zmm1,zmm1,zmm5
		vpaddd zmm2,zmm2,zmm6
		vpaddd zmm3,zmm3,zmm7

		vmovdqa YMMWORD ptr SAVE_ZMM0,ymm0
		vmovdqa YMMWORD ptr SAVE_ZMM1,ymm1
		
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

		vmovdqa ymm0,YMMWORD ptr SAVE_ZMM0
		vmovdqa ymm1,YMMWORD ptr SAVE_ZMM1

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
		vmulps xmm0,xmm0,XMMWORD ptr [edx+512]
		vaddps xmm0,xmm0,XMMWORD ptr [edx+528]
		vmovaps xmm1,xmm0
		vandps xmm0,xmm0,XMMWORD ptr sign_bits_f_zero_l
		vaddps xmm0,xmm0,XMMWORD ptr ones_f
		vrcpps xmm0,xmm0
		vmulps xmm0,xmm0,xmm1
		vpshufd xmm1,xmm0,0
		vpshufd xmm2,xmm0,85
		vpshufd xmm3,xmm0,170
		vpshufd xmm4,xmm0,255
		vmulps xmm1,xmm1,XMMWORD ptr [edx+544]
		vmulps xmm2,xmm2,XMMWORD ptr [edx+544+16]
		vmulps xmm3,xmm3,XMMWORD ptr [edx+544+32]
		vmulps xmm4,xmm4,XMMWORD ptr [edx+544+48]
		vaddps xmm1,xmm1,xmm2
		vaddps xmm3,xmm3,xmm4
		vaddps xmm1,xmm1,xmm3
		vaddps xmm1,xmm1,XMMWORD ptr [edx+544+64]
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
		vmulps xmm0,xmm0,XMMWORD ptr [edx+624]
		vmulps xmm1,xmm1,XMMWORD ptr [edx+624+16]
		vmulps xmm2,xmm2,XMMWORD ptr [edx+624+32]
		vmulps xmm3,xmm3,XMMWORD ptr [edx+624+48]
		vpshufd xmm4,xmm7,0
		vpshufd xmm5,xmm7,85
		vpshufd xmm6,xmm7,170
		vpshufd xmm7,xmm7,255
		vmulps xmm4,xmm4,XMMWORD ptr [edx+624+64]
		vmulps xmm5,xmm5,XMMWORD ptr [edx+624+80]
		vmulps xmm6,xmm6,XMMWORD ptr [edx+624+96]
		vmulps xmm7,xmm7,XMMWORD ptr [edx+624+112]
		vaddps xmm0,xmm0,xmm1
		vaddps xmm2,xmm2,xmm3
		vaddps xmm4,xmm4,xmm5
		vaddps xmm6,xmm6,xmm7
		vaddps xmm0,xmm0,xmm2
		vaddps xmm4,xmm4,xmm6
		vaddps xmm0,xmm0,xmm4
		mov ecx,ptr_d
		vaddps xmm0,xmm0,XMMWORD ptr [edx+624+128]
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
		
computeNetwork0_i16_AVX512 endp


computeNetwork0new_AVX512 proc datai:dword,weights:dword,ptr_d:dword

	public computeNetwork0new_AVX512

		mov ecx,datai
		mov eax,weights
		
		vmovdqa64 zmm7,ZMMWORD ptr [ecx]
		vpmaddwd zmm0,zmm7,ZMMWORD ptr [eax]
		vpmaddwd zmm1,zmm7,ZMMWORD ptr [eax+64]
		vpmaddwd zmm2,zmm7,ZMMWORD ptr [eax+128]
		vpmaddwd zmm3,zmm7,ZMMWORD ptr [eax+192]
		
		vmovdqa64 zmm7,ZMMWORD ptr [ecx+64]
		vpmaddwd zmm4,zmm7,ZMMWORD ptr [eax+256]
		vpmaddwd zmm5,zmm7,ZMMWORD ptr [eax+320]
		vpmaddwd zmm6,zmm7,ZMMWORD ptr [eax+384]
		vpmaddwd zmm7,zmm7,ZMMWORD ptr [eax+448]
		vpaddd zmm0,zmm0,zmm4
		vpaddd zmm1,zmm1,zmm5
		vpaddd zmm2,zmm2,zmm6
		vpaddd zmm3,zmm3,zmm7

		vmovdqa YMMWORD ptr SAVE_ZMM0,ymm0
		vmovdqa YMMWORD ptr SAVE_ZMM1,ymm1
		
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

		vmovdqa ymm0,YMMWORD ptr SAVE_ZMM0
		vmovdqa ymm1,YMMWORD ptr SAVE_ZMM1

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
		
computeNetwork0new_AVX512 endp


; From FMA3
computeNetwork0_AVX512 proc input:dword,weights:dword,ptr_d:dword

    public computeNetwork0_AVX512
;//    dotProd48_m4_SSE(input,weights,temp,4);	
		mov ecx,input
		mov edx,weights
		mov eax,1
		
		vmovaps zmm4,ZMMWORD ptr [ecx]
		vmulps zmm0,zmm4,ZMMWORD ptr [edx]
		vmulps zmm1,zmm4,ZMMWORD ptr [edx+64]
		vmulps zmm2,zmm4,ZMMWORD ptr [edx+128]
		vmulps zmm3,zmm4,ZMMWORD ptr [edx+192]
		
		vmovaps zmm4,ZMMWORD ptr [ecx+64]

		vfmadd231ps zmm0,zmm4,ZMMWORD ptr [edx+256]
		vfmadd231ps zmm1,zmm4,ZMMWORD ptr [edx+320]
		vfmadd231ps zmm2,zmm4,ZMMWORD ptr [edx+384]
		vfmadd231ps zmm3,zmm4,ZMMWORD ptr [edx+448]
	
		vmovaps zmm4,ZMMWORD ptr [ecx+128]
		
		vfmadd231ps zmm0,zmm4,ZMMWORD ptr [edx+512]
		vfmadd231ps zmm1,zmm4,ZMMWORD ptr [edx+576]
		vfmadd231ps zmm2,zmm4,ZMMWORD ptr [edx+640]
		vfmadd231ps zmm3,zmm4,ZMMWORD ptr [edx+704]
		
		vextractf32x8 ymm6,zmm0,1
		vextractf32x8 ymm5,zmm1,1
		vextractf32x8 ymm7,zmm2,1
		vextractf32x8 ymm4,zmm3,1
		
   ; This block performs a horizontal sum of each accumulator (m0..m3) and packs the results in m0 (sum(m3) sum(m2) sum(m1) sum(m0)).
   ; Sadly replacing the twelve instructions with three haddps makes no difference whatsoever on this Core 2 Duo.
		
		vhaddps ymm0,ymm0,ymm1
		vhaddps ymm2,ymm2,ymm3
		vhaddps ymm0,ymm0,ymm2

		vhaddps ymm6,ymm6,ymm5
		vhaddps ymm7,ymm7,ymm4
		vhaddps ymm6,ymm6,ymm7
		
		vaddps ymm0,ymm0,ymm6
		
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

computeNetwork0_AVX512 endp


; From FMA3
weightedAvgElliottMul5_m16_AVX512 proc ptr_w:dword,n:dword,mstd:dword

	public weightedAvgElliottMul5_m16_AVX512

		push edi
		
		mov eax,ptr_w
		mov ecx,n
		lea edx,[eax+ecx*4]
		xor edi,edi

		vmovdqa64 zmm6,ZMMWORD ptr sign_bits_f_32
		
		vxorps zmm0,zmm0,zmm0
		vxorps zmm1,zmm1,zmm1
		
nloop_52:
		vmovaps zmm2,ZMMWORD ptr [eax+edi*4]
		vmovaps zmm4,ZMMWORD ptr [edx+edi*4]
		vaddps zmm0,zmm0,zmm2
		vandps zmm5,zmm4,zmm6
		vaddps zmm5,zmm5,ZMMWORD ptr ones_f_32

		vextractf32x8 ymm7,zmm5,1
		vrcpps ymm5,ymm5
		vrcpps ymm7,ymm7
		vinsertf32x8 zmm5,zmm5,ymm7,1

		vmulps zmm4,zmm4,zmm5
		vfmadd231ps zmm1,zmm2,zmm4

		add edi,16
		sub ecx,16
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
		mov eax,mstd
		vmulss xmm1,xmm1,dword ptr[eax+4]
		vaddss xmm1,xmm1,dword ptr[eax]
		vaddss xmm1,xmm1,dword ptr[eax+12]
		vmovss dword ptr[eax+12],xmm1
		
		vzeroupper
		
		pop edi
		
		ret
		
weightedAvgElliottMul5_m16_AVX512 endp


; From FMA3
dotProd_m32_m16_AVX512 proc data_:dword,weights:dword,vals:dword,n:dword,len:dword,istd:dword

	public dotProd_m32_m16_AVX512

		push edi
		push esi
		push ebx
		
		mov edi,weights
		mov eax,vals
		mov ebx,n
		mov esi,len
nloop_2:
		mov ecx,data_
		vxorps zmm0,zmm0,zmm0
		vxorps zmm1,zmm1,zmm1
		vxorps zmm2,zmm2,zmm2
		vxorps zmm3,zmm3,zmm3
		mov edx,esi
lloop_2:
		vmovaps zmm7,ZMMWORD ptr[ecx]
		vfmadd231ps zmm0,zmm7,ZMMWORD ptr[edi]
		vfmadd231ps zmm1,zmm7,ZMMWORD ptr[edi+64]
		vfmadd231ps zmm2,zmm7,ZMMWORD ptr[edi+128]
		vfmadd231ps zmm3,zmm7,ZMMWORD ptr[edi+192]
		
		vmovaps zmm7,ZMMWORD ptr[ecx+64]
		vfmadd231ps zmm0,zmm7,ZMMWORD ptr[edi+256]
		vfmadd231ps zmm1,zmm7,ZMMWORD ptr[edi+320]
		vfmadd231ps zmm2,zmm7,ZMMWORD ptr[edi+384]
		vfmadd231ps zmm3,zmm7,ZMMWORD ptr[edi+448]
		
		add ecx,128
		add edi,512
		sub edx,32
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
		
dotProd_m32_m16_AVX512 endp


; From FMA3
dotProd_m48_m16_AVX512 proc data_:dword,weights:dword,vals:dword,n:dword,len:dword,istd:dword

	public dotProd_m48_m16_AVX512

		push edi
		push esi
		push ebx
		
		mov edi,weights
		mov eax,vals
		mov ebx,n
		mov esi,len
nloop2_2:
		mov ecx,data_
		vxorps zmm0,zmm0,zmm0
		vxorps zmm1,zmm1,zmm1
		vxorps zmm2,zmm2,zmm2
		vxorps zmm3,zmm3,zmm3
		mov edx,esi
lloop2_2:
		vmovaps zmm7,ZMMWORD ptr[ecx]
		vfmadd231ps zmm0,zmm7,ZMMWORD ptr[edi]
		vfmadd231ps zmm1,zmm7,ZMMWORD ptr[edi+64]
		vfmadd231ps zmm2,zmm7,ZMMWORD ptr[edi+128]
		vfmadd231ps zmm3,zmm7,ZMMWORD ptr[edi+192]
				
		vmovaps zmm7,ZMMWORD ptr[ecx+64]
		vfmadd231ps zmm0,zmm7,ZMMWORD ptr[edi+256]
		vfmadd231ps zmm1,zmm7,ZMMWORD ptr[edi+320]
		vfmadd231ps zmm2,zmm7,ZMMWORD ptr[edi+384]
		vfmadd231ps zmm3,zmm7,ZMMWORD ptr[edi+448]
		
		vmovaps zmm7,ZMMWORD ptr[ecx+128]
		vfmadd231ps zmm0,zmm7,ZMMWORD ptr[edi+512]
		vfmadd231ps zmm1,zmm7,ZMMWORD ptr[edi+576]
		vfmadd231ps zmm2,zmm7,ZMMWORD ptr[edi+640]
		vfmadd231ps zmm3,zmm7,ZMMWORD ptr[edi+704]
		
		add ecx,192
		add edi,768
		sub edx,48
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
		
dotProd_m48_m16_AVX512 endp


dotProd_m32_m16_i16_AVX512 proc dataf:dword,weightsf:dword,vals:dword,n:dword,len:dword,istd:dword

	public dotProd_m32_m16_i16_AVX512

		push edi
		push esi
		push ebx
		
		mov edi,weightsf
		mov eax,vals
		mov ebx,n
		mov esi,len
nloop_3:
		mov ecx,dataf
		vpxord zmm0,zmm0,zmm0
		vpxord zmm1,zmm1,zmm1
		vpxord zmm2,zmm2,zmm2
		vpxord zmm3,zmm3,zmm3
		mov edx,esi
lloop_3:
		vmovdqa64 zmm7,ZMMWORD ptr [ecx]
		vpmaddwd zmm4,zmm7,ZMMWORD ptr [edi]
		vpmaddwd zmm5,zmm7,ZMMWORD ptr [edi+64]
		vpmaddwd zmm6,zmm7,ZMMWORD ptr [edi+128]
		vpmaddwd zmm7,zmm7,ZMMWORD ptr [edi+192]
		vpaddd zmm0,zmm0,zmm4
		vpaddd zmm1,zmm1,zmm5
		vpaddd zmm2,zmm2,zmm6
		vpaddd zmm3,zmm3,zmm7
				
		add ecx,64
		add edi,256
		sub edx,32
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
		
dotProd_m32_m16_i16_AVX512 endp


dotProd_m64_m16_i16_AVX512 proc dataf:dword,weightsf:dword,vals:dword,n:dword,len:dword,istd:dword

	public dotProd_m64_m16_i16_AVX512

		push edi
		push esi
		push ebx
		
		mov edi,weightsf
		mov eax,vals
		mov ebx,n
		mov esi,len
nloop_4:
		mov ecx,dataf
		vpxord zmm0,zmm0,zmm0
		vpxord zmm1,zmm1,zmm1
		vpxord zmm2,zmm2,zmm2
		vpxord zmm3,zmm3,zmm3
		mov edx,esi
lloop_4:
		vmovdqa64 zmm7,ZMMWORD ptr [ecx]
		vpmaddwd zmm4,zmm7,ZMMWORD ptr [edi]
		vpmaddwd zmm5,zmm7,ZMMWORD ptr [edi+64]
		vpmaddwd zmm6,zmm7,ZMMWORD ptr [edi+128]
		vpmaddwd zmm7,zmm7,ZMMWORD ptr [edi+192]
		vpaddd zmm0,zmm0,zmm4
		vpaddd zmm1,zmm1,zmm5
		vpaddd zmm2,zmm2,zmm6
		vpaddd zmm3,zmm3,zmm7

		vmovdqa64 zmm7,ZMMWORD ptr [ecx+64]
		vpmaddwd zmm4,zmm7,ZMMWORD ptr [edi+256]
		vpmaddwd zmm5,zmm7,ZMMWORD ptr [edi+320]
		vpmaddwd zmm6,zmm7,ZMMWORD ptr [edi+384]
		vpmaddwd zmm7,zmm7,ZMMWORD ptr [edi+448]
		vpaddd zmm0,zmm0,zmm4
		vpaddd zmm1,zmm1,zmm5
		vpaddd zmm2,zmm2,zmm6
		vpaddd zmm3,zmm3,zmm7

		add ecx,128
		add edi,512
		sub edx,64
		jnz lloop_4

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
		jnz short aloop_4
		
		vzeroupper
		
		pop ebx
		pop esi
		pop edi
		
		ret
		
dotProd_m64_m16_i16_AVX512 endp


end
