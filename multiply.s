	.arch armv8-a
	.file	"multiply.c"
	.text
	.align	2
	.p2align 3,,7
	.global	mult_std
	.type	mult_std, %function
mult_std:
	cmp	w3, 0
	ble	.L1
	add	x5, x0, 16
	add	x4, x2, 16
	cmp	x2, x5
	add	x5, x1, 16
	ccmp	x0, x4, 2, cc
	ccmp	w3, 7, 0, cs
	cset	w6, hi
	cmp	x5, x2
	ccmp	x1, x4, 2, hi
	cset	w4, cs
	tst	w6, w4
	beq	.L9
	neg	x5, x0, lsr 2
	mov	w7, 0
	ands	w5, w5, 3
	beq	.L4
	ldr	s0, [x0]
	mov	w7, 1
	ldr	s1, [x1]
	cmp	w5, w7
	fmul	s0, s0, s1
	str	s0, [x2]
	beq	.L4
	ldr	s0, [x0, 4]
	mov	w7, 2
	ldr	s1, [x1, 4]
	cmp	w5, 3
	fmul	s0, s0, s1
	str	s0, [x2, 4]
	bne	.L4
	ldr	s0, [x0, 8]
	mov	w7, w5
	ldr	s1, [x1, 8]
	fmul	s0, s0, s1
	str	s0, [x2, 8]
.L4:
	sub	w11, w3, w5
	ubfiz	x5, x5, 2, 2
	add	x10, x0, x5
	add	x9, x1, x5
	lsr	w8, w11, 2
	add	x5, x2, x5
	mov	x4, 0
	mov	w6, 0
	.p2align 3
.L6:
	ldr	q0, [x9, x4]
	add	w6, w6, 1
	ldr	q1, [x10, x4]
	cmp	w8, w6
	fmul	v0.4s, v0.4s, v1.4s
	str	q0, [x5, x4]
	add	x4, x4, 16
	bhi	.L6
	and	w5, w11, -4
	add	w4, w5, w7
	cmp	w11, w5
	beq	.L1
	sxtw	x6, w4
	add	w5, w4, 1
	cmp	w3, w5
	lsl	x5, x6, 2
	ldr	s0, [x0, x6, lsl 2]
	ldr	s1, [x1, x6, lsl 2]
	fmul	s0, s0, s1
	str	s0, [x2, x6, lsl 2]
	ble	.L1
	add	x6, x5, 4
	add	w7, w4, 2
	cmp	w3, w7
	ldr	s0, [x0, x6]
	ldr	s1, [x1, x6]
	fmul	s0, s0, s1
	str	s0, [x2, x6]
	ble	.L1
	add	x6, x5, 8
	add	w7, w4, 3
	cmp	w3, w7
	ldr	s0, [x0, x6]
	ldr	s1, [x1, x6]
	fmul	s0, s0, s1
	str	s0, [x2, x6]
	ble	.L1
	add	x6, x5, 12
	add	w7, w4, 4
	cmp	w3, w7
	ldr	s0, [x0, x6]
	ldr	s1, [x1, x6]
	fmul	s0, s0, s1
	str	s0, [x2, x6]
	ble	.L1
	add	x6, x5, 16
	add	w4, w4, 5
	cmp	w3, w4
	ldr	s0, [x0, x6]
	ldr	s1, [x1, x6]
	fmul	s0, s0, s1
	str	s0, [x2, x6]
	ble	.L1
	add	x5, x5, 20
	ldr	s0, [x0, x5]
	ldr	s1, [x1, x5]
	fmul	s0, s0, s1
	str	s0, [x2, x5]
.L1:
	ret
	.p2align 2
.L9:
	mov	x4, 0
	.p2align 3
.L3:
	ldr	s0, [x0, x4, lsl 2]
	ldr	s1, [x1, x4, lsl 2]
	fmul	s0, s0, s1
	str	s0, [x2, x4, lsl 2]
	add	x4, x4, 1
	cmp	w3, w4
	bgt	.L3
	ret
	.size	mult_std, .-mult_std
	.align	2
	.p2align 3,,7
	.global	mult_vect
	.type	mult_vect, %function
mult_vect:
	cmp	w3, 0
	ble	.L18
	sub	w3, w3, #1
	add	x4, x0, 16
	lsr	w3, w3, 2
	add	x3, x4, x3, uxtw 4
	.p2align 3
.L20:
	ldr	q1, [x0], 16
	ldr	q0, [x1], 16
	cmp	x0, x3
	fmul	v0.4s, v0.4s, v1.4s
	str	q0, [x2], 16
	bne	.L20
.L18:
	ret
	.size	mult_vect, .-mult_vect
	.section	.text.startup,"ax",@progbits
	.align	2
	.p2align 3,,7
	.global	main
	.type	main, %function
main:
	stp	x29, x30, [sp, -128]!
	mov	x1, 33792
	movk	x1, 0x17d7, lsl 16
	mov	x0, 16
	add	x29, sp, 0
	str	x23, [sp, 48]
	adrp	x23, :got:__stack_chk_guard
	stp	x19, x20, [sp, 16]
	ldr	x2, [x23, #:got_lo12:__stack_chk_guard]
	stp	x21, x22, [sp, 32]
	ldr	x3, [x2]
	str	x3, [x29, 120]
	mov	x3,0
	str	d8, [sp, 56]
	bl	aligned_alloc
	mov	x20, x0
	mov	x1, 33792
	mov	x0, 16
	movk	x1, 0x17d7, lsl 16
	bl	aligned_alloc
	mov	x1, 33792
	mov	x21, x0
	movk	x1, 0x17d7, lsl 16
	mov	x0, 16
	bl	aligned_alloc
	mov	x22, x0
	adrp	x5, .LC0
	adrp	x4, .LC1
	adrp	x3, .LC2
	adrp	x2, .LC3
	adrp	x1, .LC4
	adrp	x0, .LC5
	ldr	q1, [x5, #:lo12:.LC0]
	movi	v18.4s, 0x4
	ldr	q5, [x4, #:lo12:.LC1]
	ldr	q17, [x3, #:lo12:.LC2]
	ldr	q4, [x2, #:lo12:.LC3]
	ldr	q16, [x1, #:lo12:.LC4]
	mov	x1, 33792
	ldr	q7, [x0, #:lo12:.LC5]
	movk	x1, 0x17d7, lsl 16
	mov	x0, 0
	.p2align 3
.L23:
	smull2	v2.2d, v1.4s, v5.4s
	smull	v0.2d, v1.2s, v5.2s
	smull	v3.2d, v1.2s, v4.2s
	smull2	v6.2d, v1.4s, v4.4s
	uzp2	v0.4s, v0.4s, v2.4s
	uzp2	v3.4s, v3.4s, v6.4s
	add	v0.4s, v0.4s, v1.4s
	sshr	v3.4s, v3.4s, 6
	sshr	v2.4s, v0.4s, 6
	mov	v0.16b, v1.16b
	mls	v0.4s, v3.4s, v16.4s
	mov	v3.16b, v0.16b
	shl	v0.4s, v2.4s, 7
	scvtf	v3.4s, v3.4s
	sub	v0.4s, v0.4s, v2.4s
	fmul	v2.4s, v3.4s, v7.4s
	sub	v0.4s, v1.4s, v0.4s
	add	v1.4s, v1.4s, v18.4s
	str	q2, [x21, x0]
	scvtf	v0.4s, v0.4s
	fmul	v0.4s, v0.4s, v17.4s
	str	q0, [x20, x0]
	add	x0, x0, 16
	cmp	x0, x1
	bne	.L23
	add	x1, x29, 72
	mov	w0, 1
	bl	clock_gettime
	mov	x19, 0
	mov	x0, 33792
	movk	x0, 0x17d7, lsl 16
	.p2align 3
.L24:
	ldr	q0, [x21, x19]
	ldr	q1, [x20, x19]
	fmul	v0.4s, v0.4s, v1.4s
	str	q0, [x22, x19]
	add	x19, x19, 16
	cmp	x19, x0
	bne	.L24
	add	x1, x29, 88
	mov	w0, 1
	bl	clock_gettime
	add	x19, x20, x19
	mov	x0, x20
	mov	x2, x21
	mov	x1, x22
	.p2align 3
.L25:
	ldr	q0, [x0], 16
	ldr	q1, [x2], 16
	cmp	x19, x0
	fmul	v0.4s, v0.4s, v1.4s
	str	q0, [x1], 16
	bne	.L25
	add	x1, x29, 104
	mov	w0, 1
	bl	clock_gettime
	ldp	x1, x3, [x29, 72]
	ldp	x5, x4, [x29, 88]
	ldp	x2, x0, [x29, 104]
	sub	x3, x4, x3
	sub	x1, x5, x1
	sub	x0, x0, x4
	adrp	x4, .LC6
	scvtf	d2, x3
	sub	x2, x2, x5
	scvtf	d8, x0
	ldr	d3, [x4, #:lo12:.LC6]
	scvtf	d1, x2
	scvtf	d0, x1
	mov	w0, 1
	adrp	x1, .LC7
	fmadd	d0, d2, d3, d0
	add	x1, x1, :lo12:.LC7
	fmadd	d8, d8, d3, d1
	bl	__printf_chk
	fmov	d0, d8
	adrp	x1, .LC8
	add	x1, x1, :lo12:.LC8
	mov	w0, 1
	bl	__printf_chk
	mov	x0, x20
	bl	free
	mov	x0, x21
	bl	free
	mov	x0, x22
	bl	free
	ldr	x23, [x23, #:got_lo12:__stack_chk_guard]
	mov	w0, 0
	ldr	x2, [x29, 120]
	ldr	x1, [x23]
	eor	x1, x2, x1
	cbnz	x1, .L31
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldr	d8, [sp, 56]
	ldp	x29, x30, [sp], 128
	ret
.L31:
	bl	__stack_chk_fail
	.size	main, .-main
	.section	.rodata.cst16,"aM",@progbits,16
	.align	4
.LC0:
	.word	0
	.word	1
	.word	2
	.word	3
	.align	4
.LC1:
	.word	-2130574327
	.word	-2130574327
	.word	-2130574327
	.word	-2130574327
	.align	4
.LC2:
	.word	1041576545
	.word	1041576545
	.word	1041576545
	.word	1041576545
	.align	4
.LC3:
	.word	830446849
	.word	830446849
	.word	830446849
	.word	830446849
	.align	4
.LC4:
	.word	331
	.word	331
	.word	331
	.word	331
	.align	4
.LC5:
	.word	1039932378
	.word	1039932378
	.word	1039932378
	.word	1039932378
	.section	.rodata.cst8,"aM",@progbits,8
	.align	3
.LC6:
	.word	3894859413
	.word	1041313291
	.section	.text.startup
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC7:
	.string	"Elapsed time std: %f\n"
	.zero	2
.LC8:
	.string	"Elapsed time vec: %f\n"
	.ident	"GCC: (Ubuntu/Linaro 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
