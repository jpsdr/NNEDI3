.data

FLT_EPSILON  equ   1.192092896e-07

align 16

sign_bits_f_zero_l qword 7FFFFFFF00000000h,7FFFFFFF7FFFFFFFh
sign_bits_f qword 2 dup(7FFFFFFF7FFFFFFFh)
ones_f real4 4 dup(1.0)

flt_epsilon_sse real4 4 dup(FLT_EPSILON)

exp_hi real4 4 dup(80.0)
exp_lo real4 4 dup(-80.0)

; exp from:  A Fast, Compact Approximation of the Exponential Function (1998)
;            Nicol N. Schraudolph

e0_mult real4 4 dup(12102203.161561486)   ; (1.0/ln(2))*(2^23)
e0_bias real4 4 dup(1064866805.0)         ; (2^23)*127.0-486411.0

.code


;computeNetwork0_FMA3 proc input:dword,weights:dword,ptr_d:dword
; input = rcx
; weights = rdx
; ptr_d = r8

computeNetwork0_FMA3 proc public frame

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
		
		vfmadd231ps xmm0,xmm4,[rdx+64]
		vfmadd231ps xmm1,xmm5,[rdx+80]
		vfmadd231ps xmm2,xmm6,[rdx+96]
		vfmadd231ps xmm3,xmm7,[rdx+112]
		
		movaps xmm4,[rcx+32]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[rdx+128]
		vfmadd231ps xmm1,xmm5,[rdx+144]
		vfmadd231ps xmm2,xmm6,[rdx+160]
		vfmadd231ps xmm3,xmm7,[rdx+176]
		
		movaps xmm4,[rcx+48]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[rdx+192]
		vfmadd231ps xmm1,xmm5,[rdx+208]
		vfmadd231ps xmm2,xmm6,[rdx+224]
		vfmadd231ps xmm3,xmm7,[rdx+240]
		
		movaps xmm4,[rcx+64]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[rdx+256]
		vfmadd231ps xmm1,xmm5,[rdx+272]
		vfmadd231ps xmm2,xmm6,[rdx+288]
		vfmadd231ps xmm3,xmm7,[rdx+304]
		
		movaps xmm4,[rcx+80]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[rdx+320]
		vfmadd231ps xmm1,xmm5,[rdx+336]
		vfmadd231ps xmm2,xmm6,[rdx+352]
		vfmadd231ps xmm3,xmm7,[rdx+368]
		
		movaps xmm4,[rcx+96]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[rdx+384]
		vfmadd231ps xmm1,xmm5,[rdx+400]
		vfmadd231ps xmm2,xmm6,[rdx+416]
		vfmadd231ps xmm3,xmm7,[rdx+432]
		
		movaps xmm4,[rcx+112]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[rdx+448]
		vfmadd231ps xmm1,xmm5,[rdx+464]
		vfmadd231ps xmm2,xmm6,[rdx+480]
		vfmadd231ps xmm3,xmm7,[rdx+496]
		
		movaps xmm4,[rcx+128]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[rdx+512]
		vfmadd231ps xmm1,xmm5,[rdx+528]
		vfmadd231ps xmm2,xmm6,[rdx+544]
		vfmadd231ps xmm3,xmm7,[rdx+560]
		
		movaps xmm4,[rcx+144]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[rdx+576]
		vfmadd231ps xmm1,xmm5,[rdx+592]
		vfmadd231ps xmm2,xmm6,[rdx+608]
		vfmadd231ps xmm3,xmm7,[rdx+624]	
		
		movaps xmm4,[rcx+160]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[rdx+640]
		vfmadd231ps xmm1,xmm5,[rdx+656]
		vfmadd231ps xmm2,xmm6,[rdx+672]
		vfmadd231ps xmm3,xmm7,[rdx+688]	
		
		movaps xmm4,[rcx+176]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[rdx+704]
		vfmadd231ps xmm1,xmm5,[rdx+720]
		vfmadd231ps xmm2,xmm6,[rdx+736]
		vfmadd231ps xmm3,xmm7,[rdx+752]	
		
		haddps xmm0, xmm1
		haddps xmm2, xmm3
		haddps xmm0, xmm2
		
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
		vfmadd231ps xmm1,xmm2,[rdx+784+16]
		mulps xmm3,[rdx+784+32]
		vfmadd231ps xmm3,xmm4,[rdx+784+48]
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
		vfmadd231ps xmm0,xmm1,[rdx+864+16]
		mulps xmm2,[rdx+864+32]
		vfmadd231ps xmm2,xmm3,[rdx+864+48]
		
		pshufd xmm4,xmm7,0
		pshufd xmm5,xmm7,85
		pshufd xmm6,xmm7,170
		pshufd xmm7,xmm7,255
		
		mulps xmm4,[rdx+864+64]
		vfmadd231ps xmm4,xmm5,[rdx+864+80]
		mulps xmm6,[rdx+864+96]
		vfmadd231ps xmm6,xmm7,[rdx+864+112]		
		
		addps xmm0,xmm2
		addps xmm4,xmm6
		addps xmm0,xmm4
		mov rcx,r8
		addps xmm0,[rdx+864+128]
		movhlps xmm1,xmm0
		maxps xmm0,xmm1
		pshuflw xmm1,xmm0,14
		comiss xmm1,xmm0
		jbe finish_1a
		xor rax,rax
finish_1a:
		mov BYTE PTR[rcx],al
		
	movdqu xmm7,oword ptr[rsp+16]
	movdqu xmm6,oword ptr[rsp]
	add rsp,32		
		
		ret

computeNetwork0_FMA3 endp


;computeNetwork0_FMA4 proc input:dword,weights:dword,ptr_d:dword
; input = rcx
; weights = rdx
; ptr_d = r8

computeNetwork0_FMA4 proc public frame

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
		
		vfmaddps xmm0,xmm4,[rdx+64],xmm0
		vfmaddps xmm1,xmm5,[rdx+80],xmm1
		vfmaddps xmm2,xmm6,[rdx+96],xmm2
		vfmaddps xmm3,xmm7,[rdx+112],xmm3		
		
		movaps xmm4,[rcx+32]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[rdx+128],xmm0
		vfmaddps xmm1,xmm5,[rdx+144],xmm1
		vfmaddps xmm2,xmm6,[rdx+160],xmm2
		vfmaddps xmm3,xmm7,[rdx+176],xmm3
				
		movaps xmm4,[rcx+48]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[rdx+192],xmm0
		vfmaddps xmm1,xmm5,[rdx+208],xmm1
		vfmaddps xmm2,xmm6,[rdx+224],xmm2
		vfmaddps xmm3,xmm7,[rdx+240],xmm3
				
		movaps xmm4,[rcx+64]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[rdx+256],xmm0
		vfmaddps xmm1,xmm5,[rdx+272],xmm1
		vfmaddps xmm2,xmm6,[rdx+288],xmm2
		vfmaddps xmm3,xmm7,[rdx+304],xmm3
				
		movaps xmm4,[rcx+80]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[rdx+320],xmm0
		vfmaddps xmm1,xmm5,[rdx+336],xmm1
		vfmaddps xmm2,xmm6,[rdx+352],xmm2
		vfmaddps xmm3,xmm7,[rdx+368],xmm3
				
		movaps xmm4,[rcx+96]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[rdx+384],xmm0
		vfmaddps xmm1,xmm5,[rdx+400],xmm1
		vfmaddps xmm2,xmm6,[rdx+416],xmm2
		vfmaddps xmm3,xmm7,[rdx+432],xmm3
				
		movaps xmm4,[rcx+112]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[rdx+448],xmm0
		vfmaddps xmm1,xmm5,[rdx+464],xmm1
		vfmaddps xmm2,xmm6,[rdx+480],xmm2
		vfmaddps xmm3,xmm7,[rdx+496],xmm3
				
		movaps xmm4,[rcx+128]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[rdx+512],xmm0
		vfmaddps xmm1,xmm5,[rdx+528],xmm1
		vfmaddps xmm2,xmm6,[rdx+544],xmm2
		vfmaddps xmm3,xmm7,[rdx+560],xmm3
				
		movaps xmm4,[rcx+144]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[rdx+576],xmm0
		vfmaddps xmm1,xmm5,[rdx+592],xmm1
		vfmaddps xmm2,xmm6,[rdx+608],xmm2
		vfmaddps xmm3,xmm7,[rdx+624],xmm3		
				
		movaps xmm4,[rcx+160]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[rdx+640],xmm0
		vfmaddps xmm1,xmm5,[rdx+656],xmm1
		vfmaddps xmm2,xmm6,[rdx+672],xmm2
		vfmaddps xmm3,xmm7,[rdx+688],xmm3		
				
		movaps xmm4,[rcx+176]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[rdx+704],xmm0
		vfmaddps xmm1,xmm5,[rdx+720],xmm1
		vfmaddps xmm2,xmm6,[rdx+736],xmm2
		vfmaddps xmm3,xmm7,[rdx+752],xmm3
				
		haddps xmm0, xmm1
		haddps xmm2, xmm3
		haddps xmm0, xmm2
		
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
		vfmaddps xmm1,xmm2,[rdx+784+16],xmm1
		mulps xmm3,[rdx+784+32]
		vfmaddps xmm3,xmm4,[rdx+784+48],xmm3
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
		vfmaddps xmm0,xmm1,[rdx+864+16],xmm0
		mulps xmm2,[rdx+864+32]
		vfmaddps xmm2,xmm3,[rdx+864+48],xmm2
		
		pshufd xmm4,xmm7,0
		pshufd xmm5,xmm7,85
		pshufd xmm6,xmm7,170
		pshufd xmm7,xmm7,255
		
		mulps xmm4,[rdx+864+64]
		vfmaddps xmm4,xmm5,[rdx+864+80],xmm4
		mulps xmm6,[rdx+864+96]
		vfmaddps xmm6,xmm7,[rdx+864+112],xmm6
		
		addps xmm0,xmm2
		addps xmm4,xmm6
		addps xmm0,xmm4
		mov rcx,r8
		addps xmm0,[rdx+864+128]
		movhlps xmm1,xmm0
		maxps xmm0,xmm1
		pshuflw xmm1,xmm0,14
		comiss xmm1,xmm0
		jbe finish_1b
		xor rax,rax
finish_1b:
		mov BYTE PTR[rcx],al
		
	movdqu xmm7,oword ptr[rsp+16]
	movdqu xmm6,oword ptr[rsp]
	add rsp,32		
		
		ret

computeNetwork0_FMA4 endp


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
		
		vfmadd231ps xmm0,xmm4,[rdi]
		vfmadd231ps xmm1,xmm5,[rdi+r11]
		vfmadd231ps xmm2,xmm6,[rdi+r12]
		vfmadd231ps xmm3,xmm7,[rdi+48]		
		
		movaps xmm4,[rcx+r11]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[rdi+2*r12]
		vfmadd231ps xmm1,xmm5,[rdi+80]
		vfmadd231ps xmm2,xmm6,[rdi+96]
		vfmadd231ps xmm3,xmm7,[rdi+112]		
		
		movaps xmm4,[rcx+r12]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[rdi+r13]
		vfmadd231ps xmm1,xmm5,[rdi+144]
		vfmadd231ps xmm2,xmm6,[rdi+160]
		vfmadd231ps xmm3,xmm7,[rdi+176]		
		
		movaps xmm4,[rcx+48]
		movaps xmm5,xmm4
		movaps xmm6,xmm4		
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[rdi+192]
		vfmadd231ps xmm1,xmm5,[rdi+208]
		vfmadd231ps xmm2,xmm6,[rdi+224]
		vfmadd231ps xmm3,xmm7,[rdi+240]
				
		movaps xmm4,[rcx+2*r12]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[rdi+2*r13]
		vfmadd231ps xmm1,xmm5,[rdi+272]
		vfmadd231ps xmm2,xmm6,[rdi+288]
		vfmadd231ps xmm3,xmm7,[rdi+304]
				
		movaps xmm4,[rcx+80]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[rdi+320]
		vfmadd231ps xmm1,xmm5,[rdi+336]
		vfmadd231ps xmm2,xmm6,[rdi+352]
		vfmadd231ps xmm3,xmm7,[rdi+368]
		
		movaps xmm4,[rcx+96]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[rdi+384]
		vfmadd231ps xmm1,xmm5,[rdi+400]
		vfmadd231ps xmm2,xmm6,[rdi+416]
		vfmadd231ps xmm3,xmm7,[rdi+432]		
		
		movaps xmm4,[rcx+112]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[rdi+448]
		vfmadd231ps xmm1,xmm5,[rdi+464]
		vfmadd231ps xmm2,xmm6,[rdi+480]
		vfmadd231ps xmm3,xmm7,[rdi+496]
		
		add rcx,r13
		add rdi,r14
		sub rdx,r12
		jnz lloop_2
				
		haddps xmm0,xmm1
		haddps xmm2,xmm3
		haddps xmm0,xmm2		
		
		movaps [rax],xmm0
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
		
		vfmadd213ps xmm0,xmm7,[rdi+rcx*4]
		vfmadd213ps xmm1,xmm7,[rdi+rcx*4+16]
		vfmadd213ps xmm2,xmm7,[rdi+rcx*4+32]
		vfmadd213ps xmm3,xmm7,[rdi+rcx*4+48]
		
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
nloop_3:
		mov rcx,r15
		xorps xmm0,xmm0
		xorps xmm1,xmm1
		xorps xmm2,xmm2
		xorps xmm3,xmm3
		mov rdx,rsi
lloop_3:
		movaps xmm4,[rcx]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
				
		vfmaddps xmm0,xmm4,[rdi],xmm0
		vfmaddps xmm1,xmm5,[rdi+r11],xmm1
		vfmaddps xmm2,xmm6,[rdi+r12],xmm2
		vfmaddps xmm3,xmm7,[rdi+48],xmm3		
		
		movaps xmm4,[rcx+r11]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[rdi+2*r12],xmm0
		vfmaddps xmm1,xmm5,[rdi+80],xmm1
		vfmaddps xmm2,xmm6,[rdi+96],xmm2
		vfmaddps xmm3,xmm7,[rdi+112],xmm3
		
		movaps xmm4,[rcx+r12]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[rdi+r13],xmm0
		vfmaddps xmm1,xmm5,[rdi+144],xmm1
		vfmaddps xmm2,xmm6,[rdi+160],xmm2
		vfmaddps xmm3,xmm7,[rdi+176],xmm3
				
		movaps xmm4,[rcx+48]
		movaps xmm5,xmm4
		movaps xmm6,xmm4		
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[rdi+192],xmm0
		vfmaddps xmm1,xmm5,[rdi+208],xmm1
		vfmaddps xmm2,xmm6,[rdi+224],xmm2
		vfmaddps xmm3,xmm7,[rdi+240],xmm3
						
		movaps xmm4,[rcx+2*r12]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[rdi+2*r13],xmm0
		vfmaddps xmm1,xmm5,[rdi+272],xmm1
		vfmaddps xmm2,xmm6,[rdi+288],xmm2
		vfmaddps xmm3,xmm7,[rdi+304],xmm3
						
		movaps xmm4,[rcx+80]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[rdi+320],xmm0
		vfmaddps xmm1,xmm5,[rdi+336],xmm1
		vfmaddps xmm2,xmm6,[rdi+352],xmm2
		vfmaddps xmm3,xmm7,[rdi+368],xmm3		
				
		movaps xmm4,[rcx+96]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[rdi+384],xmm0
		vfmaddps xmm1,xmm5,[rdi+400],xmm1
		vfmaddps xmm2,xmm6,[rdi+416],xmm2
		vfmaddps xmm3,xmm7,[rdi+432],xmm3
				
		movaps xmm4,[rcx+112]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[rdi+448],xmm0
		vfmaddps xmm1,xmm5,[rdi+464],xmm1
		vfmaddps xmm2,xmm6,[rdi+480],xmm2
		vfmaddps xmm3,xmm7,[rdi+496],xmm3
				
		add rcx,r13
		add rdi,r14
		sub rdx,r12
		jnz lloop_3
				
		haddps xmm0,xmm1
		haddps xmm2,xmm3
		haddps xmm0,xmm2		
		
		movaps [rax],xmm0
		add rax,r11
		sub rbx,r10
		jnz nloop_3
		
		mov rcx,istd
		mov rax,r8
		movss xmm7,dword ptr[rcx]
		xor rdx,rdx
		mov edx,r9d
		shufps xmm7,xmm7,0
		xor rcx,rcx
aloop_3:
		movaps xmm0,[rax+rcx*4]
		movaps xmm1,[rax+rcx*4+16]
		movaps xmm2,[rax+rcx*4+32]
		movaps xmm3,[rax+rcx*4+48]
		
		vfmaddps xmm0,xmm0,xmm7,[rdi+rcx*4]
		vfmaddps xmm1,xmm1,xmm7,[rdi+rcx*4+16]
		vfmaddps xmm2,xmm2,xmm7,[rdi+rcx*4+32]
		vfmaddps xmm3,xmm3,xmm7,[rdi+rcx*4+48]
				
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
		
dotProd_m32_m16_FMA4 endp


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
			
nloop_2_2:
		mov rcx,r15
		xorps xmm0,xmm0
		xorps xmm1,xmm1
		xorps xmm2,xmm2
		xorps xmm3,xmm3
		mov rdx,rsi
lloop_2_2:
		movaps xmm4,[rcx]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[rdi]
		vfmadd231ps xmm1,xmm5,[rdi+r11]
		vfmadd231ps xmm2,xmm6,[rdi+2*r11]
		vfmadd231ps xmm3,xmm7,[rdi+r12]
		
		movaps xmm4,[rcx+r11]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[rdi+4*r11]
		vfmadd231ps xmm1,xmm5,[rdi+80]
		vfmadd231ps xmm2,xmm6,[rdi+96]
		vfmadd231ps xmm3,xmm7,[rdi+112]
				
		movaps xmm4,[rcx+2*r11]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[rdi+8*r11]
		vfmadd231ps xmm1,xmm5,[rdi+144]
		vfmadd231ps xmm2,xmm6,[rdi+160]
		vfmadd231ps xmm3,xmm7,[rdi+176]		
		
		movaps xmm4,[rcx+r12]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[rdi+r13]
		vfmadd231ps xmm1,xmm5,[rdi+208]
		vfmadd231ps xmm2,xmm6,[rdi+224]
		vfmadd231ps xmm3,xmm7,[rdi+240]
		
		movaps xmm4,[rcx+4*r11]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[rdi+256]
		vfmadd231ps xmm1,xmm5,[rdi+272]
		vfmadd231ps xmm2,xmm6,[rdi+288]
		vfmadd231ps xmm3,xmm7,[rdi+304]
		
		movaps xmm4,[rcx+80]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[rdi+320]
		vfmadd231ps xmm1,xmm5,[rdi+336]
		vfmadd231ps xmm2,xmm6,[rdi+352]
		vfmadd231ps xmm3,xmm7,[rdi+368]		
		
		movaps xmm4,[rcx+96]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[rdi+384]
		vfmadd231ps xmm1,xmm5,[rdi+400]
		vfmadd231ps xmm2,xmm6,[rdi+416]
		vfmadd231ps xmm3,xmm7,[rdi+432]		
		
		movaps xmm4,[rcx+112]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[rdi+448]
		vfmadd231ps xmm1,xmm5,[rdi+464]
		vfmadd231ps xmm2,xmm6,[rdi+480]
		vfmadd231ps xmm3,xmm7,[rdi+496]		
		
		movaps xmm4,[rcx+8*r11]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[rdi+512]
		vfmadd231ps xmm1,xmm5,[rdi+528]
		vfmadd231ps xmm2,xmm6,[rdi+544]
		vfmadd231ps xmm3,xmm7,[rdi+560]		
		
		movaps xmm4,[rcx+144]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[rdi+576]
		vfmadd231ps xmm1,xmm5,[rdi+592]
		vfmadd231ps xmm2,xmm6,[rdi+608]
		vfmadd231ps xmm3,xmm7,[rdi+624]		
		
		movaps xmm4,[rcx+160]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[rdi+640]
		vfmadd231ps xmm1,xmm5,[rdi+656]
		vfmadd231ps xmm2,xmm6,[rdi+672]
		vfmadd231ps xmm3,xmm7,[rdi+688]		
		
		movaps xmm4,[rcx+176]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmadd231ps xmm0,xmm4,[rdi+704]
		vfmadd231ps xmm1,xmm5,[rdi+720]
		vfmadd231ps xmm2,xmm6,[rdi+736]
		vfmadd231ps xmm3,xmm7,[rdi+752]		
		
		add rcx,r13
		add rdi,r14
		sub rdx,r12
		jnz lloop_2_2
				
		haddps xmm0,xmm1
		haddps xmm2,xmm3
		haddps xmm0,xmm2				
		
		movaps [rax],xmm0
		add rax,r11
		sub rbx,r10
		jnz nloop_2_2
		mov rcx,istd
		mov rax,r8
		movss xmm7,dword ptr[rcx]
		xor rdx,rdx
		mov edx,r9d
		shufps xmm7,xmm7,0
		xor rcx,rcx
		
aloop_2_2:
		movaps xmm0,[rax+rcx*4]
		movaps xmm1,[rax+rcx*4+16]
		movaps xmm2,[rax+rcx*4+32]
		movaps xmm3,[rax+rcx*4+48]
		
		vfmadd213ps xmm0,xmm7,[rdi+rcx*4]
		vfmadd213ps xmm1,xmm7,[rdi+rcx*4+16]
		vfmadd213ps xmm2,xmm7,[rdi+rcx*4+32]
		vfmadd213ps xmm3,xmm7,[rdi+rcx*4+48]		
		
		movaps [rax+rcx*4],xmm0
		movaps [rax+rcx*4+16],xmm1
		movaps [rax+rcx*4+32],xmm2
		movaps [rax+rcx*4+48],xmm3
		add rcx,r11
		sub rdx,r11
		jnz aloop_2_2
		
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
			
nloop_2_3:
		mov rcx,r15
		xorps xmm0,xmm0
		xorps xmm1,xmm1
		xorps xmm2,xmm2
		xorps xmm3,xmm3
		mov rdx,rsi
lloop_2_3:
		movaps xmm4,[rcx]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
				
		vfmaddps xmm0,xmm4,[rdi],xmm0
		vfmaddps xmm1,xmm5,[rdi+r11],xmm1
		vfmaddps xmm2,xmm6,[rdi+2*r11],xmm2
		vfmaddps xmm3,xmm7,[rdi+r12],xmm3		
		
		movaps xmm4,[rcx+r11]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[rdi+4*r11],xmm0
		vfmaddps xmm1,xmm5,[rdi+80],xmm1
		vfmaddps xmm2,xmm6,[rdi+96],xmm2
		vfmaddps xmm3,xmm7,[rdi+112],xmm3
						
		movaps xmm4,[rcx+2*r11]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[rdi+8*r11],xmm0
		vfmaddps xmm1,xmm5,[rdi+144],xmm1
		vfmaddps xmm2,xmm6,[rdi+160],xmm2
		vfmaddps xmm3,xmm7,[rdi+176],xmm3
				
		movaps xmm4,[rcx+r12]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[rdi+r13],xmm0
		vfmaddps xmm1,xmm5,[rdi+208],xmm1
		vfmaddps xmm2,xmm6,[rdi+224],xmm2
		vfmaddps xmm3,xmm7,[rdi+240],xmm3
				
		movaps xmm4,[rcx+4*r11]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[rdi+256],xmm0
		vfmaddps xmm1,xmm5,[rdi+272],xmm1
		vfmaddps xmm2,xmm6,[rdi+288],xmm2
		vfmaddps xmm3,xmm7,[rdi+304],xmm3
		
		movaps xmm4,[rcx+80]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[rdi+320],xmm0
		vfmaddps xmm1,xmm5,[rdi+336],xmm1
		vfmaddps xmm2,xmm6,[rdi+352],xmm2
		vfmaddps xmm3,xmm7,[rdi+368],xmm3
		
		movaps xmm4,[rcx+96]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[rdi+384],xmm0
		vfmaddps xmm1,xmm5,[rdi+400],xmm1
		vfmaddps xmm2,xmm6,[rdi+416],xmm2
		vfmaddps xmm3,xmm7,[rdi+432],xmm3
		
		movaps xmm4,[rcx+112]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4

		vfmaddps xmm0,xmm4,[rdi+448],xmm0
		vfmaddps xmm1,xmm5,[rdi+464],xmm1
		vfmaddps xmm2,xmm6,[rdi+480],xmm2
		vfmaddps xmm3,xmm7,[rdi+496],xmm3
				
		movaps xmm4,[rcx+8*r11]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[rdi+512],xmm0
		vfmaddps xmm1,xmm5,[rdi+528],xmm1
		vfmaddps xmm2,xmm6,[rdi+544],xmm2
		vfmaddps xmm3,xmm7,[rdi+560],xmm3
				
		movaps xmm4,[rcx+144]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[rdi+576],xmm0
		vfmaddps xmm1,xmm5,[rdi+592],xmm1
		vfmaddps xmm2,xmm6,[rdi+608],xmm2
		vfmaddps xmm3,xmm7,[rdi+624],xmm3
				
		movaps xmm4,[rcx+160]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[rdi+640],xmm0
		vfmaddps xmm1,xmm5,[rdi+656],xmm1
		vfmaddps xmm2,xmm6,[rdi+672],xmm2
		vfmaddps xmm3,xmm7,[rdi+688],xmm3		
				
		movaps xmm4,[rcx+176]
		movaps xmm5,xmm4
		movaps xmm6,xmm4
		movaps xmm7,xmm4
		
		vfmaddps xmm0,xmm4,[rdi+704],xmm0
		vfmaddps xmm1,xmm5,[rdi+720],xmm1
		vfmaddps xmm2,xmm6,[rdi+736],xmm2
		vfmaddps xmm3,xmm7,[rdi+752],xmm3
				
		add rcx,r13
		add rdi,r14
		sub rdx,r12
		jnz lloop_2_3
				
		haddps xmm0,xmm1
		haddps xmm2,xmm3
		haddps xmm0,xmm2				
		
		movaps [rax],xmm0
		add rax,r11
		sub rbx,r10
		jnz nloop_2_3
		mov rcx,istd
		mov rax,r8
		movss xmm7,dword ptr[rcx]
		xor rdx,rdx
		mov edx,r9d
		shufps xmm7,xmm7,0
		xor rcx,rcx
		
aloop_2_3:
		movaps xmm0,[rax+rcx*4]
		movaps xmm1,[rax+rcx*4+16]
		movaps xmm2,[rax+rcx*4+32]
		movaps xmm3,[rax+rcx*4+48]
		
		vfmaddps xmm0,xmm0,xmm7,[rdi+rcx*4]
		vfmaddps xmm1,xmm1,xmm7,[rdi+rcx*4+16]
		vfmaddps xmm2,xmm2,xmm7,[rdi+rcx*4+32]
		vfmaddps xmm3,xmm3,xmm7,[rdi+rcx*4+48]
				
		movaps [rax+rcx*4],xmm0
		movaps [rax+rcx*4+16],xmm1
		movaps [rax+rcx*4+32],xmm2
		movaps [rax+rcx*4+48],xmm3
		add rcx,r11
		sub rdx,r11
		jnz aloop_2_3
		
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
		
dotProd_m48_m16_FMA4 endp


;e0_m16_FMA3 proc ptr_s:dword,n:dword
; ptr_s = rcx
; n = edx

e0_m16_FMA3 proc public frame

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
		
eloop16_2:
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
		
		vfmadd213ps xmm0,xmm6,xmm7
		vfmadd213ps xmm1,xmm6,xmm7
		vfmadd213ps xmm2,xmm6,xmm7
		vfmadd213ps xmm3,xmm6,xmm7
				
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
		
		jnz eloop16_2
		
	movdqu xmm7,oword ptr[rsp+16]
	movdqu xmm6,oword ptr[rsp]	
	add rsp,32			
		
		ret

e0_m16_FMA3 endp


;e0_m16_FMA4 proc ptr_s:dword,n:dword
; ptr_s = rcx
; n = edx

e0_m16_FMA4 proc public frame

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
		
eloop16_3:
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
		
		vfmaddps xmm0,xmm0,xmm6,xmm7
		vfmaddps xmm1,xmm1,xmm6,xmm7
		vfmaddps xmm2,xmm2,xmm6,xmm7
		vfmaddps xmm3,xmm3,xmm6,xmm7
						
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
		
		jnz eloop16_3
		
	movdqu xmm7,oword ptr[rsp+16]
	movdqu xmm6,oword ptr[rsp]	
	add rsp,32			
		
		ret

e0_m16_FMA4 endp


end
