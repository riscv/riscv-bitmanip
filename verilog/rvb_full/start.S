	.section .text
	.global start
	.global main
	.global shtst

start:
	addi x1,zero,0
	addi x2,zero,0
	addi x3,zero,0
	addi x4,zero,0
	addi x5,zero,0
	addi x6,zero,0
	addi x7,zero,0
	addi x8,zero,0
	addi x9,zero,0
	addi x10,zero,0
	addi x11,zero,0
	addi x12,zero,0
	addi x13,zero,0
	addi x14,zero,0
	addi x15,zero,0
	addi x16,zero,0
	addi x17,zero,0
	addi x18,zero,0
	addi x19,zero,0
	addi x20,zero,0
	addi x21,zero,0
	addi x22,zero,0
	addi x23,zero,0
	addi x24,zero,0
	addi x25,zero,0
	addi x26,zero,0
	addi x27,zero,0
	addi x28,zero,0
	addi x29,zero,0
	addi x30,zero,0
	addi x31,zero,0

	/* print "START\n" */
	lui a0,0x10000000>>12
	addi a1,zero,'S'
	addi a2,zero,'T'
	addi a3,zero,'A'
	addi a4,zero,'R'
	addi a5,zero,'\n'
	sw a1,0(a0)
	sw a2,0(a0)
	sw a3,0(a0)
	sw a4,0(a0)
	sw a2,0(a0)
	sw a5,0(a0)

	/* execute some insns for "make timing" */
	lui a0,0
	auipc a0,0
	slli a0,a0,0
	slli a0,a0,31
	addi a1,zero,0
	sll a0,a0,a1
	addi a1,zero,31
	sll a0,a0,a1

	/* set stack pointer */
	lui sp,(64*1024)>>12

	/* jump to main C code */
	jal ra,main

	/* print "DONE\n" */
	lui a0,0x10000000>>12
	addi a1,zero,'D'
	addi a2,zero,'O'
	addi a3,zero,'N'
	addi a4,zero,'E'
	addi a5,zero,'\n'
	sw a1,0(a0)
	sw a2,0(a0)
	sw a3,0(a0)
	sw a4,0(a0)
	sw a5,0(a0)

	/* trap */
	ebreak

shtst:
	li t1, 0
	li t2, 5
	li t3, 25

	srli x0, x0, 0

	li t0, 0x87654321
	crc32c.w a0, t0

	slli a1, t0, 0
	xor a0, a0, a1
	crc32c.w a0, a0

	slli a1, t0, 5
	xor a0, a0, a1
	crc32c.w a0, a0

	slli a1, t0, 25
	xor a0, a0, a1
	crc32c.w a0, a0

	srli a1, t0, 0
	xor a0, a0, a1
	crc32c.w a0, a0

	srli a1, t0, 5
	xor a0, a0, a1
	crc32c.w a0, a0

	srli a1, t0, 25
	xor a0, a0, a1
	crc32c.w a0, a0

	srai a1, t0, 0
	xor a0, a0, a1
	crc32c.w a0, a0

	srai a1, t0, 5
	xor a0, a0, a1
	crc32c.w a0, a0

	srai a1, t0, 25
	xor a0, a0, a1
	crc32c.w a0, a0

	sll a1, t0, t1
	xor a0, a0, a1
	crc32c.w a0, a0

	sll a1, t0, t2
	xor a0, a0, a1
	crc32c.w a0, a0

	sll a1, t0, t3
	xor a0, a0, a1
	crc32c.w a0, a0

	srl a1, t0, t1
	xor a0, a0, a1
	crc32c.w a0, a0

	srl a1, t0, t2
	xor a0, a0, a1
	crc32c.w a0, a0

	srl a1, t0, t3
	xor a0, a0, a1
	crc32c.w a0, a0

	sra a1, t0, t1
	xor a0, a0, a1
	crc32c.w a0, a0

	sra a1, t0, t2
	xor a0, a0, a1
	crc32c.w a0, a0

	sra a1, t0, t3
	xor a0, a0, a1
	crc32c.w a0, a0

	ret
