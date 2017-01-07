.xmm
.model flat,c

.data

align 16

sign_bits_f_zero_l qword 7FFFFFFF00000000h,7FFFFFFF7FFFFFFFh
sign_bits_f qword 2 dup(7FFFFFFF7FFFFFFFh)
ones_f real4 4 dup(1.0)

exp_hi real4 4 dup(80.0)
exp_lo real4 4 dup(-80.0)

; exp from:  A Fast, Compact Approximation of the Exponential Function (1998)
;            Nicol N. Schraudolph

e0_mult real4 4 dup(12102203.161561486)   ; (1.0/ln(2))*(2^23)
e0_bias real4 4 dup(1064866805.0)         ; (2^23)*127.0-486411.0

.code


computeNetwork0_FMA3 proc input:dword,weights:dword,ptr_d:dword

    public computeNetwork0_FMA3
;//    dotProd48_m4_SSE(input,weights,temp,4);	
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

		vfmadd231ps xmm0,xmm4,[edx+64]
		vfmadd231ps xmm1,xmm5,[edx+80]
		vfmadd231ps xmm2,xmm6,[edx+96]
		vfmadd231ps xmm3,xmm7,[edx+112]
	
		movaps xmm4,[ecx+32]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[edx+128]
		vfmadd231ps xmm1,xmm5,[edx+144]
		vfmadd231ps xmm2,xmm6,[edx+160]
		vfmadd231ps xmm3,xmm7,[edx+176]
		
		movaps xmm4,[ecx+48]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[edx+192]
		vfmadd231ps xmm1,xmm5,[edx+208]
		vfmadd231ps xmm2,xmm6,[edx+224]
		vfmadd231ps xmm3,xmm7,[edx+240]
		
		movaps xmm4,[ecx+64]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[edx+256]
		vfmadd231ps xmm1,xmm5,[edx+272]
		vfmadd231ps xmm2,xmm6,[edx+288]
		vfmadd231ps xmm3,xmm7,[edx+304]
		
		movaps xmm4,[ecx+80]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[edx+320]
		vfmadd231ps xmm1,xmm5,[edx+336]
		vfmadd231ps xmm2,xmm6,[edx+352]
		vfmadd231ps xmm3,xmm7,[edx+368]
		
		movaps xmm4,[ecx+96]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[edx+384]
		vfmadd231ps xmm1,xmm5,[edx+400]
		vfmadd231ps xmm2,xmm6,[edx+416]
		vfmadd231ps xmm3,xmm7,[edx+432]
		
		movaps xmm4,[ecx+112]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[edx+448]
		vfmadd231ps xmm1,xmm5,[edx+464]
		vfmadd231ps xmm2,xmm6,[edx+480]
		vfmadd231ps xmm3,xmm7,[edx+496]
		
		movaps xmm4,[ecx+128]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[edx+512]
		vfmadd231ps xmm1,xmm5,[edx+528]
		vfmadd231ps xmm2,xmm6,[edx+544]
		vfmadd231ps xmm3,xmm7,[edx+560]
		
		movaps xmm4,[ecx+144]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[edx+576]
		vfmadd231ps xmm1,xmm5,[edx+592]
		vfmadd231ps xmm2,xmm6,[edx+608]
		vfmadd231ps xmm3,xmm7,[edx+624]	
		
		movaps xmm4,[ecx+160]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[edx+640]
		vfmadd231ps xmm1,xmm5,[edx+656]
		vfmadd231ps xmm2,xmm6,[edx+672]
		vfmadd231ps xmm3,xmm7,[edx+688]	
		
		movaps xmm4,[ecx+176]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[edx+704]
		vfmadd231ps xmm1,xmm5,[edx+720]
		vfmadd231ps xmm2,xmm6,[edx+736]
		vfmadd231ps xmm3,xmm7,[edx+752]	
		
   ; This block performs a horizontal sum of each accumulator (m0..m3) and packs the results in m0 (sum(m3) sum(m2) sum(m1) sum(m0)).
   ; Sadly replacing the twelve instructions with three haddps makes no difference whatsoever on this Core 2 Duo.
		
		haddps xmm0, xmm1
		haddps xmm2, xmm3
		haddps xmm0, xmm2
		
		addps xmm0,[edx+768]
   ;// const float t = temp[0];
   ;// elliott4_SSE(temp);
   ;// temp[0] = t;
		movaps xmm1,xmm0
		andps xmm0,oword ptr sign_bits_f_zero_l
		addps xmm0,ones_f
		rcpps xmm0,xmm0
		mulps xmm0,xmm1
		
;//    dotProd4_m4_SSE2(temp,weights+4*49,temp+4,4);		
		pshufd xmm1,xmm0,0
		pshufd xmm2,xmm0,85
		pshufd xmm3,xmm0,170
		pshufd xmm4,xmm0,255
		
		mulps xmm1,[edx+784]
		vfmadd231ps xmm1,xmm2,[edx+784+16]
		mulps xmm3,[edx+784+32]
		vfmadd231ps xmm3,xmm4,[edx+784+48]
		addps xmm1,xmm3
		addps xmm1,[edx+784+64]
		;// elliott4_SSE(temp+4);
		movaps xmm7,xmm1
		andps xmm1, oword ptr sign_bits_f
		movaps xmm3,xmm0
		addps xmm1,oword ptr ones_f
		rcpps xmm1,xmm1
		mulps xmm7,xmm1
		
		;//    dotProd8_m4_SSE2(temp,weights+4*49+4*5,temp+32,4);
		pshufd xmm0,xmm0,0
		pshufd xmm1,xmm3,85
		pshufd xmm2,xmm3,170
		pshufd xmm3,xmm3,255
		mulps xmm0,[edx+864]
		vfmadd231ps xmm0,xmm1,[edx+864+16]
		mulps xmm2,[edx+864+32]
		vfmadd231ps xmm2,xmm3,[edx+864+48]
		
		pshufd xmm4,xmm7,0
		pshufd xmm5,xmm7,85
		pshufd xmm6,xmm7,170
		pshufd xmm7,xmm7,255
		
		mulps xmm4,[edx+864+64]
		vfmadd231ps xmm4,xmm5,[edx+864+80]
		mulps xmm6,[edx+864+96]
		vfmadd231ps xmm6,xmm7,[edx+864+112]
		
		addps xmm0,xmm2
		addps xmm4,xmm6
		addps xmm0,xmm4
		mov ecx,ptr_d
		addps xmm0,[edx+864+128]
		movhlps xmm1,xmm0
		maxps xmm0,xmm1
		pshuflw xmm1,xmm0,14
		comiss xmm1,xmm0
		jbe finish_1a
		xor eax,eax
finish_1a:
		mov BYTE PTR[ecx],al
		
		ret

computeNetwork0_FMA3 endp


computeNetwork0_FMA4 proc input:dword,weights:dword,ptr_d:dword

    public computeNetwork0_FMA4
;//    dotProd48_m4_SSE(input,weights,temp,4);	
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

		vfmaddps xmm0,xmm4,[edx+64],xmm0
		vfmaddps xmm1,xmm5,[edx+80],xmm1
		vfmaddps xmm2,xmm6,[edx+96],xmm2
		vfmaddps xmm3,xmm7,[edx+112],xmm3
	
		movaps xmm4,[ecx+32]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[edx+128],xmm0
		vfmaddps xmm1,xmm5,[edx+144],xmm1
		vfmaddps xmm2,xmm6,[edx+160],xmm2
		vfmaddps xmm3,xmm7,[edx+176],xmm3
		
		movaps xmm4,[ecx+48]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[edx+192],xmm0
		vfmaddps xmm1,xmm5,[edx+208],xmm1
		vfmaddps xmm2,xmm6,[edx+224],xmm2
		vfmaddps xmm3,xmm7,[edx+240],xmm3
		
		movaps xmm4,[ecx+64]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[edx+256],xmm0
		vfmaddps xmm1,xmm5,[edx+272],xmm1
		vfmaddps xmm2,xmm6,[edx+288],xmm2
		vfmaddps xmm3,xmm7,[edx+304],xmm3
		
		movaps xmm4,[ecx+80]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[edx+320],xmm0
		vfmaddps xmm1,xmm5,[edx+336],xmm1
		vfmaddps xmm2,xmm6,[edx+352],xmm2
		vfmaddps xmm3,xmm7,[edx+368],xmm3
		
		movaps xmm4,[ecx+96]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[edx+384],xmm0
		vfmaddps xmm1,xmm5,[edx+400],xmm1
		vfmaddps xmm2,xmm6,[edx+416],xmm2
		vfmaddps xmm3,xmm7,[edx+432],xmm3
		
		movaps xmm4,[ecx+112]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[edx+448],xmm0
		vfmaddps xmm1,xmm5,[edx+464],xmm1
		vfmaddps xmm2,xmm6,[edx+480],xmm2
		vfmaddps xmm3,xmm7,[edx+496],xmm3
		
		movaps xmm4,[ecx+128]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[edx+512],xmm0
		vfmaddps xmm1,xmm5,[edx+528],xmm1
		vfmaddps xmm2,xmm6,[edx+544],xmm2
		vfmaddps xmm3,xmm7,[edx+560],xmm3
		
		movaps xmm4,[ecx+144]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[edx+576],xmm0
		vfmaddps xmm1,xmm5,[edx+592],xmm1
		vfmaddps xmm2,xmm6,[edx+608],xmm2
		vfmaddps xmm3,xmm7,[edx+624],xmm3
		
		movaps xmm4,[ecx+160]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[edx+640],xmm0
		vfmaddps xmm1,xmm5,[edx+656],xmm1
		vfmaddps xmm2,xmm6,[edx+672],xmm2
		vfmaddps xmm3,xmm7,[edx+688],xmm3
		
		movaps xmm4,[ecx+176]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[edx+704],xmm0
		vfmaddps xmm1,xmm5,[edx+720],xmm1
		vfmaddps xmm2,xmm6,[edx+736],xmm2
		vfmaddps xmm3,xmm7,[edx+752],xmm3
		
   ; This block performs a horizontal sum of each accumulator (m0..m3) and packs the results in m0 (sum(m3) sum(m2) sum(m1) sum(m0)).
   ; Sadly replacing the twelve instructions with three haddps makes no difference whatsoever on this Core 2 Duo.
		
		haddps xmm0, xmm1
		haddps xmm2, xmm3
		haddps xmm0, xmm2
		
		addps xmm0,[edx+768]
   ;// const float t = temp[0];
   ;// elliott4_SSE(temp);
   ;// temp[0] = t;
		movaps xmm1,xmm0
		andps xmm0,oword ptr sign_bits_f_zero_l
		addps xmm0,ones_f
		rcpps xmm0,xmm0
		mulps xmm0,xmm1
		
;//    dotProd4_m4_SSE2(temp,weights+4*49,temp+4,4);		
		pshufd xmm1,xmm0,0
		pshufd xmm2,xmm0,85
		pshufd xmm3,xmm0,170
		pshufd xmm4,xmm0,255
		
		mulps xmm1,[edx+784]
		vfmaddps xmm1,xmm2,[edx+784+16],xmm1
		mulps xmm3,[edx+784+32]
		vfmaddps xmm3,xmm4,[edx+784+48],xmm3
		addps xmm1,xmm3
		addps xmm1,[edx+784+64]
		;// elliott4_SSE(temp+4);
		movaps xmm7,xmm1
		andps xmm1, oword ptr sign_bits_f
		movaps xmm3,xmm0
		addps xmm1,oword ptr ones_f
		rcpps xmm1,xmm1
		mulps xmm7,xmm1
		
		;//    dotProd8_m4_SSE2(temp,weights+4*49+4*5,temp+32,4);
		pshufd xmm0,xmm0,0
		pshufd xmm1,xmm3,85
		pshufd xmm2,xmm3,170
		pshufd xmm3,xmm3,255
		mulps xmm0,[edx+864]
		vfmaddps xmm0,xmm1,[edx+864+16],xmm0
		mulps xmm2,[edx+864+32]
		vfmaddps xmm2,xmm3,[edx+864+48],xmm2
		
		pshufd xmm4,xmm7,0
		pshufd xmm5,xmm7,85
		pshufd xmm6,xmm7,170
		pshufd xmm7,xmm7,255
		
		mulps xmm4,[edx+864+64]
		vfmaddps xmm4,xmm5,[edx+864+80],xmm4
		mulps xmm6,[edx+864+96]
		vfmaddps xmm6,xmm7,[edx+864+112],xmm6
		
		addps xmm0,xmm2
		addps xmm4,xmm6
		addps xmm0,xmm4
		mov ecx,ptr_d
		addps xmm0,[edx+864+128]
		movhlps xmm1,xmm0
		maxps xmm0,xmm1
		pshuflw xmm1,xmm0,14
		comiss xmm1,xmm0
		jbe finish_1b
		xor eax,eax
finish_1b:
		mov BYTE PTR[ecx],al
		
		ret

computeNetwork0_FMA4 endp


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
		
		vfmadd231ps xmm0,xmm4,[edi]
		vfmadd231ps xmm1,xmm5,[edi+16]
		vfmadd231ps xmm2,xmm6,[edi+32]
		vfmadd231ps xmm3,xmm7,[edi+48]
		
		movaps xmm4,[ecx+16]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[edi+64]
		vfmadd231ps xmm1,xmm5,[edi+80]
		vfmadd231ps xmm2,xmm6,[edi+96]
		vfmadd231ps xmm3,xmm7,[edi+112]
		
		movaps xmm4,[ecx+32]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[edi+128]
		vfmadd231ps xmm1,xmm5,[edi+144]
		vfmadd231ps xmm2,xmm6,[edi+160]
		vfmadd231ps xmm3,xmm7,[edi+176]
		
		movaps xmm4,[ecx+48]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[edi+192]
		vfmadd231ps xmm1,xmm5,[edi+208]
		vfmadd231ps xmm2,xmm6,[edi+224]
		vfmadd231ps xmm3,xmm7,[edi+240]
		
		movaps xmm4,[ecx+64]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[edi+256]
		vfmadd231ps xmm1,xmm5,[edi+272]
		vfmadd231ps xmm2,xmm6,[edi+288]
		vfmadd231ps xmm3,xmm7,[edi+304]
		
		movaps xmm4,[ecx+80]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[edi+320]
		vfmadd231ps xmm1,xmm5,[edi+336]
		vfmadd231ps xmm2,xmm6,[edi+352]
		vfmadd231ps xmm3,xmm7,[edi+368]
		
		movaps xmm4,[ecx+96]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[edi+384]
		vfmadd231ps xmm1,xmm5,[edi+400]
		vfmadd231ps xmm2,xmm6,[edi+416]
		vfmadd231ps xmm3,xmm7,[edi+432]
		
		movaps xmm4,[ecx+112]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[edi+448]
		vfmadd231ps xmm1,xmm5,[edi+464]
		vfmadd231ps xmm2,xmm6,[edi+480]
		vfmadd231ps xmm3,xmm7,[edi+496]
		
		add ecx,128
		add edi,512
		sub edx,32
		jnz lloop_2

		haddps xmm0,xmm1
		haddps xmm2,xmm3
		haddps xmm0,xmm2		
		
		movaps [eax],xmm0
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
		
		vfmadd213ps xmm0,xmm7,[edi+ecx*4]
		vfmadd213ps xmm1,xmm7,[edi+ecx*4+16]
		vfmadd213ps xmm2,xmm7,[edi+ecx*4+32]
		vfmadd213ps xmm3,xmm7,[edi+ecx*4+48]
		
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
		xorps xmm0,xmm0
		xorps xmm1,xmm1
		xorps xmm2,xmm2
		xorps xmm3,xmm3
		mov edx,esi
lloop_3:
		movaps xmm4,[ecx]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[edi],xmm0
		vfmaddps xmm1,xmm5,[edi+16],xmm1
		vfmaddps xmm2,xmm6,[edi+32],xmm2
		vfmaddps xmm3,xmm7,[edi+48],xmm3
		
		movaps xmm4,[ecx+16]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[edi+64],xmm0
		vfmaddps xmm1,xmm5,[edi+80],xmm1
		vfmaddps xmm2,xmm6,[edi+96],xmm2
		vfmaddps xmm3,xmm7,[edi+112],xmm3
		
		movaps xmm4,[ecx+32]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[edi+128],xmm0
		vfmaddps xmm1,xmm5,[edi+144],xmm1
		vfmaddps xmm2,xmm6,[edi+160],xmm2
		vfmaddps xmm3,xmm7,[edi+176],xmm3
		
		movaps xmm4,[ecx+48]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[edi+192],xmm0
		vfmaddps xmm1,xmm5,[edi+208],xmm1
		vfmaddps xmm2,xmm6,[edi+224],xmm2
		vfmaddps xmm3,xmm7,[edi+240],xmm3
		
		movaps xmm4,[ecx+64]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[edi+256],xmm0
		vfmaddps xmm1,xmm5,[edi+272],xmm1
		vfmaddps xmm2,xmm6,[edi+288],xmm2
		vfmaddps xmm3,xmm7,[edi+304],xmm3
		
		movaps xmm4,[ecx+80]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[edi+320],xmm0
		vfmaddps xmm1,xmm5,[edi+336],xmm1
		vfmaddps xmm2,xmm6,[edi+352],xmm2
		vfmaddps xmm3,xmm7,[edi+368],xmm3
		
		movaps xmm4,[ecx+96]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[edi+384],xmm0
		vfmaddps xmm1,xmm5,[edi+400],xmm1
		vfmaddps xmm2,xmm6,[edi+416],xmm2
		vfmaddps xmm3,xmm7,[edi+432],xmm3
		
		movaps xmm4,[ecx+112]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[edi+448],xmm0
		vfmaddps xmm1,xmm5,[edi+464],xmm1
		vfmaddps xmm2,xmm6,[edi+480],xmm2
		vfmaddps xmm3,xmm7,[edi+496],xmm3
		
		add ecx,128
		add edi,512
		sub edx,32
		jnz lloop_3

		haddps xmm0,xmm1
		haddps xmm2,xmm3
		haddps xmm0,xmm2		
		
		movaps [eax],xmm0
		add eax,16
		sub ebx,4
		jnz nloop_3
		
		mov ecx,istd
		mov eax,vals
		movss xmm7,dword ptr[ecx]
		mov edx,n
		shufps xmm7,xmm7,0
		xor ecx,ecx
		
aloop_3:
		movaps xmm0,[eax+ecx*4]
		movaps xmm1,[eax+ecx*4+16]
		movaps xmm2,[eax+ecx*4+32]
		movaps xmm3,[eax+ecx*4+48]
		
		vfmaddps xmm0,xmm0,xmm7,[edi+ecx*4]
		vfmaddps xmm1,xmm1,xmm7,[edi+ecx*4+16]
		vfmaddps xmm2,xmm2,xmm7,[edi+ecx*4+32]
		vfmaddps xmm3,xmm3,xmm7,[edi+ecx*4+48]
		
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
		
dotProd_m32_m16_FMA4 endp


dotProd_m48_m16_FMA3 proc data_:dword,weights:dword,vals:dword,n:dword,len:dword,istd:dword

	public dotProd_m48_m16_FMA3
	
		push edi
		push esi
		push ebx
		
		mov edi,weights
		mov eax,vals
		mov ebx,n
		mov esi,len
nloop_2_2:
		mov ecx,data_
		xorps xmm0,xmm0
		xorps xmm1,xmm1
		xorps xmm2,xmm2
		xorps xmm3,xmm3
		mov edx,esi
lloop_2_2:
		movaps xmm4,[ecx]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[edi]
		vfmadd231ps xmm1,xmm5,[edi+16]
		vfmadd231ps xmm2,xmm6,[edi+32]
		vfmadd231ps xmm3,xmm7,[edi+48]
		
		movaps xmm4,[ecx+16]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[edi+64]
		vfmadd231ps xmm1,xmm5,[edi+80]
		vfmadd231ps xmm2,xmm6,[edi+96]
		vfmadd231ps xmm3,xmm7,[edi+112]
		
		movaps xmm4,[ecx+32]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[edi+128]
		vfmadd231ps xmm1,xmm5,[edi+144]
		vfmadd231ps xmm2,xmm6,[edi+160]
		vfmadd231ps xmm3,xmm7,[edi+176]
		
		movaps xmm4,[ecx+48]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[edi+192]
		vfmadd231ps xmm1,xmm5,[edi+208]
		vfmadd231ps xmm2,xmm6,[edi+224]
		vfmadd231ps xmm3,xmm7,[edi+240]
		
		movaps xmm4,[ecx+64]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[edi+256]
		vfmadd231ps xmm1,xmm5,[edi+272]
		vfmadd231ps xmm2,xmm6,[edi+288]
		vfmadd231ps xmm3,xmm7,[edi+304]
		
		movaps xmm4,[ecx+80]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[edi+320]
		vfmadd231ps xmm1,xmm5,[edi+336]
		vfmadd231ps xmm2,xmm6,[edi+352]
		vfmadd231ps xmm3,xmm7,[edi+368]
		
		movaps xmm4,[ecx+96]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[edi+384]
		vfmadd231ps xmm1,xmm5,[edi+400]
		vfmadd231ps xmm2,xmm6,[edi+416]
		vfmadd231ps xmm3,xmm7,[edi+432]
		
		movaps xmm4,[ecx+112]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[edi+448]
		vfmadd231ps xmm1,xmm5,[edi+464]
		vfmadd231ps xmm2,xmm6,[edi+480]
		vfmadd231ps xmm3,xmm7,[edi+496]
		
		movaps xmm4,[ecx+128]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[edi+512]
		vfmadd231ps xmm1,xmm5,[edi+528]
		vfmadd231ps xmm2,xmm6,[edi+544]
		vfmadd231ps xmm3,xmm7,[edi+560]
		
		movaps xmm4,[ecx+144]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[edi+576]
		vfmadd231ps xmm1,xmm5,[edi+592]
		vfmadd231ps xmm2,xmm6,[edi+608]
		vfmadd231ps xmm3,xmm7,[edi+624]
		
		movaps xmm4,[ecx+160]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[edi+640]
		vfmadd231ps xmm1,xmm5,[edi+656]
		vfmadd231ps xmm2,xmm6,[edi+672]
		vfmadd231ps xmm3,xmm7,[edi+688]
		
		movaps xmm4,[ecx+176]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[edi+704]
		vfmadd231ps xmm1,xmm5,[edi+720]
		vfmadd231ps xmm2,xmm6,[edi+736]
		vfmadd231ps xmm3,xmm7,[edi+752]
		
		add ecx,192
		add edi,768
		sub edx,48
		jnz lloop_2_2
		
		haddps xmm0,xmm1
		haddps xmm2,xmm3
		haddps xmm0,xmm2		
		
		movaps [eax],xmm0
		add eax,16
		sub ebx,4
		jnz nloop_2_2
		mov ecx,istd
		mov eax,vals
		movss xmm7,dword ptr[ecx]
		mov edx,n
		shufps xmm7,xmm7,0
		xor ecx,ecx
		
aloop_2_2:
		movaps xmm0,[eax+ecx*4]
		movaps xmm1,[eax+ecx*4+16]
		movaps xmm2,[eax+ecx*4+32]
		movaps xmm3,[eax+ecx*4+48]
		
		vfmadd213ps xmm0,xmm7,[edi+ecx*4]
		vfmadd213ps xmm1,xmm7,[edi+ecx*4+16]
		vfmadd213ps xmm2,xmm7,[edi+ecx*4+32]
		vfmadd213ps xmm3,xmm7,[edi+ecx*4+48]
		
		movaps [eax+ecx*4],xmm0
		movaps [eax+ecx*4+16],xmm1
		movaps [eax+ecx*4+32],xmm2
		movaps [eax+ecx*4+48],xmm3
		add ecx,16
		sub edx,16
		jnz aloop_2_2
		
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
nloop_2_3:
		mov ecx,data_
		xorps xmm0,xmm0
		xorps xmm1,xmm1
		xorps xmm2,xmm2
		xorps xmm3,xmm3
		mov edx,esi
lloop_2_3:
		movaps xmm4,[ecx]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[edi],xmm0
		vfmaddps xmm1,xmm5,[edi+16],xmm1
		vfmaddps xmm2,xmm6,[edi+32],xmm2
		vfmaddps xmm3,xmm7,[edi+48],xmm3
		
		movaps xmm4,[ecx+16]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[edi+64],xmm0
		vfmaddps xmm1,xmm5,[edi+80],xmm1
		vfmaddps xmm2,xmm6,[edi+96],xmm2
		vfmaddps xmm3,xmm7,[edi+112],xmm3
		
		movaps xmm4,[ecx+32]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[edi+128],xmm0
		vfmaddps xmm1,xmm5,[edi+144],xmm1
		vfmaddps xmm2,xmm6,[edi+160],xmm2
		vfmaddps xmm3,xmm7,[edi+176],xmm3
		
		movaps xmm4,[ecx+48]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[edi+192],xmm0
		vfmaddps xmm1,xmm5,[edi+208],xmm1
		vfmaddps xmm2,xmm6,[edi+224],xmm2
		vfmaddps xmm3,xmm7,[edi+240],xmm3
		
		movaps xmm4,[ecx+64]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[edi+256],xmm0
		vfmaddps xmm1,xmm5,[edi+272],xmm1
		vfmaddps xmm2,xmm6,[edi+288],xmm2
		vfmaddps xmm3,xmm7,[edi+304],xmm3
		
		movaps xmm4,[ecx+80]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[edi+320],xmm0
		vfmaddps xmm1,xmm5,[edi+336],xmm1
		vfmaddps xmm2,xmm6,[edi+352],xmm2
		vfmaddps xmm3,xmm7,[edi+368],xmm3
		
		movaps xmm4,[ecx+96]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[edi+384],xmm0
		vfmaddps xmm1,xmm5,[edi+400],xmm1
		vfmaddps xmm2,xmm6,[edi+416],xmm2
		vfmaddps xmm3,xmm7,[edi+432],xmm3
		
		movaps xmm4,[ecx+112]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[edi+448],xmm0
		vfmaddps xmm1,xmm5,[edi+464],xmm1
		vfmaddps xmm2,xmm6,[edi+480],xmm2
		vfmaddps xmm3,xmm7,[edi+496],xmm3
		
		movaps xmm4,[ecx+128]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[edi+512],xmm0
		vfmaddps xmm1,xmm5,[edi+528],xmm1
		vfmaddps xmm2,xmm6,[edi+544],xmm2
		vfmaddps xmm3,xmm7,[edi+560],xmm3
		
		movaps xmm4,[ecx+144]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[edi+576],xmm0
		vfmaddps xmm1,xmm5,[edi+592],xmm1
		vfmaddps xmm2,xmm6,[edi+608],xmm2
		vfmaddps xmm3,xmm7,[edi+624],xmm3
		
		movaps xmm4,[ecx+160]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[edi+640],xmm0
		vfmaddps xmm1,xmm5,[edi+656],xmm1
		vfmaddps xmm2,xmm6,[edi+672],xmm2
		vfmaddps xmm3,xmm7,[edi+688],xmm3
		
		movaps xmm4,[ecx+176]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[edi+704],xmm0
		vfmaddps xmm1,xmm5,[edi+720],xmm1
		vfmaddps xmm2,xmm6,[edi+736],xmm2
		vfmaddps xmm3,xmm7,[edi+752],xmm3
		
		add ecx,192
		add edi,768
		sub edx,48
		jnz lloop_2_3
		
		haddps xmm0,xmm1
		haddps xmm2,xmm3
		haddps xmm0,xmm2		
		
		movaps [eax],xmm0
		add eax,16
		sub ebx,4
		jnz nloop_2_3
		mov ecx,istd
		mov eax,vals
		movss xmm7,dword ptr[ecx]
		mov edx,n
		shufps xmm7,xmm7,0
		xor ecx,ecx
		
aloop_2_3:
		movaps xmm0,[eax+ecx*4]
		movaps xmm1,[eax+ecx*4+16]
		movaps xmm2,[eax+ecx*4+32]
		movaps xmm3,[eax+ecx*4+48]
		
		vfmaddps xmm0,xmm0,xmm7,[edi+ecx*4]
		vfmaddps xmm1,xmm1,xmm7,[edi+ecx*4+16]
		vfmaddps xmm2,xmm2,xmm7,[edi+ecx*4+32]
		vfmaddps xmm3,xmm3,xmm7,[edi+ecx*4+48]
		
		movaps [eax+ecx*4],xmm0
		movaps [eax+ecx*4+16],xmm1
		movaps [eax+ecx*4+32],xmm2
		movaps [eax+ecx*4+48],xmm3
		add ecx,16
		sub edx,16
		jnz aloop_2_3
		
		pop ebx
		pop esi
		pop edi
		
		ret
		
dotProd_m48_m16_FMA4 endp


e0_m16_FMA3 proc ptr_s:dword,n:dword

	public e0_m16_FMA3
	
		mov eax,ptr_s
		mov ecx,n
		
		movdqa xmm4,oword ptr exp_hi
		movdqa xmm5,oword ptr exp_lo
		movdqa xmm6,oword ptr e0_mult
		movdqa xmm7,oword ptr e0_bias
		
eloop16_2:
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
		
		vfmadd213ps xmm0,xmm6,xmm7
		vfmadd213ps xmm1,xmm6,xmm7
		vfmadd213ps xmm2,xmm6,xmm7
		vfmadd213ps xmm3,xmm6,xmm7
		
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
		
		jnz eloop16_2
		
		ret

e0_m16_FMA3 endp


e0_m16_FMA4 proc ptr_s:dword,n:dword

	public e0_m16_FMA4
	
		mov eax,ptr_s
		mov ecx,n
		
		movdqa xmm4,oword ptr exp_hi
		movdqa xmm5,oword ptr exp_lo
		movdqa xmm6,oword ptr e0_mult
		movdqa xmm7,oword ptr e0_bias
		
eloop16_3:
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
		
		vfmaddps xmm0,xmm0,xmm6,xmm7
		vfmaddps xmm1,xmm1,xmm6,xmm7
		vfmaddps xmm2,xmm2,xmm6,xmm7
		vfmaddps xmm3,xmm3,xmm6,xmm7
		
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
		
		jnz eloop16_3
		
		ret

e0_m16_FMA4 endp



end
