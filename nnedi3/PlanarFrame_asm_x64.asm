.data

align 16

Ymask qword 2 dup(00FF00FF00FF00FFh)

.code

;checkCPU_ASM proc

checkCPU_ASM proc public frame

	push rdi
	.pushreg rdi
	push rbx
	.pushreg rbx
	.endprolog
	
	
		xor rdi,rdi     ; zero to  begin
		; remove  CPUID check, it exists, we are on x64 CPU !
		xor rax,rax   ;check for features register.
		cpuid
		or eax,eax
		jz TEST_END
		mov eax,1
		cpuid
		test edx,00800000h  ;check MMX
		jz TEST_SSE
		or edi,1
TEST_SSE:
		test edx,02000000h  ;check SSE
		jz TEST_SSE2
		or edi,2
		or edi,4
TEST_SSE2:
		test edx,04000000h  ;check SSE2
		jz TEST_AMD
		or edi,8
		test ecx,00000001h  ;check SSE3
		jz TEST_AMD
		or edi,64
		test ecx,00000200h  ;check SSSE3
		jz TEST_AMD
		or edi,128
		test ecx,00080000h  ;check SSE4.1
		jz TEST_AMD
		or edi,256
		test ecx,00100000h  ;check SSE4.2
		jz TEST_AMD
		or edi,512
TEST_AMD:  ;check for vendor feature register (K6/Athlon).
		mov eax,80000000h
		cpuid
		mov ecx,80000001h
		cmp eax,ecx
		jb TEST_END
		mov eax,80000001h
		cpuid
		test edx,80000000h ; check 3DNOW
		jz TEST_3DNOW2
		or edi,16
TEST_3DNOW2:
		test edx,40000000h ; check 3DNOW2
		jz TEST_SSEMMX
		or edi,32
TEST_SSEMMX:
		test edx,00400000h  ;check iSSE
		jz TEST_END
		or edi,2
TEST_END:
		mov eax,edi
		
		pop rbx
		pop rdi
		
		ret
		
checkCPU_ASM  endp


;checkSSEOSSupport_ASM proc

checkSSEOSSupport_ASM proc public frame

.endprolog
	
	xorps xmm0,xmm0
	
	ret
	
checkSSEOSSupport_ASM endp


;checkSSE2OSSupport_ASM proc

checkSSE2OSSupport_ASM proc public frame
.endprolog
	
	xorpd xmm0,xmm0
	
	ret
	
checkSSE2OSSupport_ASM endp


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
		jl xloop
		add rdi,r9
		add rbx,r10
		add rdx,r11
		add rsi,r11
		dec r8
		jnz yloop
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
		
yloop_2:
		xor rax,rax
		align 16
xloop_2:
		movdqa xmm0,[rdi+rax*4] ;VYUYVYUYVYUYVYUY
		movdqa xmm1,xmm0        ;VYUYVYUYVYUYVYUY
		pand xmm0,xmm3          ;0Y0Y0Y0Y0Y0Y0Y0Y
		psrlw xmm1,8	        ;0V0U0V0U0V0U0V0U
		packuswb xmm0,xmm0      ;xxxxxxxxYYYYYYYY
		packuswb xmm1,xmm1      ;xxxxxxxxVUVUVUVU
		movdqa xmm2,xmm1        ;xxxxxxxxVUVUVUVU
		pand xmm1,xmm3          ;xxxxxxxx0U0U0U0U
		psrlw xmm2,8            ;xxxxxxxx0V0V0V0V
		packuswb xmm1,xmm1      ;xxxxxxxxxxxxUUUU
		packuswb xmm2,xmm2      ;xxxxxxxxxxxxVVVV
		movlpd qword ptr[rbx+rax*2],xmm0 ;store y
		movd dword ptr[rdx+rax],xmm1     ;store u
		movd dword ptr[rsi+rax],xmm2     ;store v
		add rax,r12
		cmp rax,rcx
		jl xloop_2
		add rdi,r9
		add rbx,r10
		add rdx,r11
		add rsi,r11
		dec r8
		jnz yloop_2
		
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp		
				
		ret
		
convYUY2to422_SSE2 endp


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
		jl xloop_3
		add rbx,r9
		add rdx,r10
		add rsi,r10
		add rdi,r11
		dec r8
		jnz yloop_3
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
		
yloop_4:
		xor rax,rax
		align 16
xloop_4:
		movlpd xmm0,qword ptr[rbx+rax*2] ;????????YYYYYYYY
		movd xmm1,dword ptr[rdx+rax]     ;000000000000UUUU
		movd xmm2,dword ptr[rsi+rax]     ;000000000000VVVV
		punpcklbw xmm1,xmm2     ;00000000VUVUVUVU
		punpcklbw xmm0,xmm1     ;VYUYVYUYVYUYVYUY
		movdqa [rdi+rax*4],xmm0 ;store
		add rax,r12
		cmp rax,rcx
		jl xloop_4
		add rbx,r9
		add rdx,r10
		add rsi,r10
		add rdi,r11
		dec r8
		jnz yloop_4
		
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp		
				
		ret
		
conv422toYUY2_SSE2 endp


;asm_BitBlt_ISSE_1 proc srcStart:dword,dstStart:dword,row_size:dword,height:dword,src_pitch:dword,dst_pitch:dword
; srcStart = rcx
; dstStart = rdx
; row_size = r8d
; height = r9d

asm_BitBlt_ISSE_1 proc public frame

src_pitch equ dword ptr[rbp+48]
dst_pitch equ dword ptr[rbp+56]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rbx
	.pushreg rbx
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	.endprolog
	
			mov   rsi,rcx
			mov   rdi,rdx
			xor rdx,rdx
			mov   edx,r8d
			dec   edx
			xor rbx,rbx
			mov   ebx,r9d
			
			movsxd r8,src_pitch
			movsxd r9,dst_pitch
			mov r10,1
			
			align 16
memoptS_rowloop:
			mov   rcx,rdx
memoptS_byteloop:
			mov   al,[rsi+rcx]
			mov   [rdi+rcx],al
			sub   rcx,r10
			jnc   memoptS_byteloop
			sub   rsi,r8
			sub   rdi,r9
			dec   rbx
			jne   memoptS_rowloop
			
	pop rdi
	pop rsi
	pop rbx
	pop rbp		
					
		ret
		
asm_BitBlt_ISSE_1 endp


;asm_BitBlt_ISSE_2 proc srcStart:dword,dstStart:dword,row_size:dword,height:dword,src_pitch:dword,dst_pitch:dword
; srcStart = rcx
; dstStart = rdx
; row_size = r8d
; height = r9d

asm_BitBlt_ISSE_2 proc public frame

src_pitch equ dword ptr[rbp+48]
dst_pitch equ dword ptr[rbp+56]

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
	.endprolog
	
			mov   rsi,rcx
			mov   al,[rsi]
			mov   rdi,rdx
			xor rdx,rdx
			mov   edx,r8d
			xor rbx,rbx
			mov   ebx,r9d
			
			movsxd r8,src_pitch
			movsxd r9,dst_pitch
			mov r10,8
			mov r11,0FFFFFFFFFFFFFFC0h
			mov r12,64
			mov r13,63
			mov r14,7
		
			align 16
memoptU_rowloop:
			mov   rcx,rdx
			dec   rcx
			add   rcx,rsi
			and   rcx,r11
memoptU_prefetchloop:
			mov   ax,[rcx]
			sub   rcx,r12
			cmp   rcx,rsi
			jae   memoptU_prefetchloop
			movq    mm6,[rsi]
			movntq  [rdi],mm6
			mov   rax,rdi
			neg   rax
			mov   rcx,rax
			and   rax,r13
			and   rcx,r14
			align 16
memoptU_prewrite8loop:
			cmp   rcx,rax
			jz    memoptU_pre8done
			movq    mm7,[rsi+rcx]
			movntq  [rdi+rcx],mm7
			add   rcx,r10
			jmp   memoptU_prewrite8loop
			align 16
memoptU_write64loop:
			movntq  [rdi+rcx-64],mm0
			movntq  [rdi+rcx-56],mm1
			movntq  [rdi+rcx-48],mm2
			movntq  [rdi+rcx-40],mm3
			movntq  [rdi+rcx-32],mm4
			movntq  [rdi+rcx-24],mm5
			movntq  [rdi+rcx-16],mm6
			movntq  [rdi+rcx- 8],mm7
memoptU_pre8done:
			add   rcx,r12
			cmp   rcx,rdx
			ja    memoptU_done64
			movq    mm0,[rsi+rcx-64]
			movq    mm1,[rsi+rcx-56]
			movq    mm2,[rsi+rcx-48]
			movq    mm3,[rsi+rcx-40]
			movq    mm4,[rsi+rcx-32]
			movq    mm5,[rsi+rcx-24]
			movq    mm6,[rsi+rcx-16]
			movq    mm7,[rsi+rcx- 8]
			jmp   memoptU_write64loop
memoptU_done64:
			sub     rcx,r12
			align 16
memoptU_write8loop:
			add     rcx,r10
			cmp     rcx,rdx
			ja      memoptU_done8
			movq    mm0,[rsi+rcx-8]
			movntq  [rdi+rcx-8],mm0
			jmp   memoptU_write8loop
memoptU_done8:
			movq    mm1,[rsi+rdx-8]
			movntq  [rdi+rdx-8],mm1
			sub   rsi,r8
			sub   rdi,r9
			dec   rbx
			jne   memoptU_rowloop
			sfence
			emms
					
	pop r14
	pop r13
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp		
		
		ret
		
asm_BitBlt_ISSE_2 endp
			

;asm_BitBlt_ISSE_3 proc srcStart:dword,dstStart:dword,row_size:dword,height:dword,src_pitch:dword,dst_pitch:dword
; srcStart = rcx
; dstStart = rdx
; row_size = r8d
; height = r9d

asm_BitBlt_ISSE_3 proc public frame

src_pitch equ dword ptr[rbp+48]
dst_pitch equ dword ptr[rbp+56]

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
	.endprolog
	
			mov   rsi,rcx
			mov   rdi,rdx
			xor rdx,rdx
			mov   edx,r8d
			xor rbx,rbx
			mov   ebx,r9d
			
			movsxd r8,src_pitch
			movsxd r9,dst_pitch
			mov r10,8
			mov r11,0FFFFFFFFFFFFFFC0h
			mov r12,64
			mov r13,63

			align 16
memoptA_rowloop:
			mov   rcx,rdx
			dec   rcx
			add   rcx,rsi
			and   rcx,r11
			align 16
memoptA_prefetchloop:
			mov   ax,[rcx]
			sub   rcx,r12
			cmp   rcx,rsi
			jae   memoptA_prefetchloop
			mov   rax,rdi
			xor   rcx,rcx
			neg   rax
			and   rax,r13
			align 16
memoptA_prewrite8loop:
			cmp   rcx,rax
			jz    memoptA_pre8done
			movq    mm7,[rsi+rcx]
			movntq  [rdi+rcx],mm7
			add   rcx,r10
			jmp   memoptA_prewrite8loop
			align 16
			memoptA_write64loop:
			movntq  [rdi+rcx-64],mm0
			movntq  [rdi+rcx-56],mm1
			movntq  [rdi+rcx-48],mm2
			movntq  [rdi+rcx-40],mm3
			movntq  [rdi+rcx-32],mm4
			movntq  [rdi+rcx-24],mm5
			movntq  [rdi+rcx-16],mm6
			movntq  [rdi+rcx- 8],mm7
memoptA_pre8done:
			add   rcx,r12
			cmp   rcx,rdx
			ja    memoptA_done64
			movq    mm0,[rsi+rcx-64]
			movq    mm1,[rsi+rcx-56]
			movq    mm2,[rsi+rcx-48]
			movq    mm3,[rsi+rcx-40]
			movq    mm4,[rsi+rcx-32]
			movq    mm5,[rsi+rcx-24]
			movq    mm6,[rsi+rcx-16]
			movq    mm7,[rsi+rcx- 8]
			jmp   memoptA_write64loop
memoptA_done64:
			sub   rcx,r12
			align 16
memoptA_write8loop:
			add   rcx,r10
			cmp   rcx,rdx
			ja    memoptA_done8
			movq    mm7,[rsi+rcx-8]
			movntq  [rdi+rcx-8],mm7
			jmp   memoptA_write8loop
memoptA_done8:
			sub   rsi,r8
			sub   rdi,r9
			dec   rbx
			jne   memoptA_rowloop
			sfence
			emms
			
	pop r13
	pop r12
	pop rdi
	pop rsi
	pop rbx
	pop rbp		
		
		ret
		
asm_BitBlt_ISSE_3 endp
			

end
