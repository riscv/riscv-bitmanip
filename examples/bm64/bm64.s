# void bm64m_bitmanip_kernel(const uint64_t in1[64] = a0, const uint64_t in2[8] = a1, uint64_t out[8] = a2)
.global bm64m_bitmanip_kernel
.global bm64m_bitmanip_kernel_ideal

# -----------------------------------------------

bm64m_bitmanip_kernel:

# load in2[] to t0,..,t6,a1
ld t0, 0(a1); bmatflip t0,t0
ld t1, 8(a1); bmatflip t1,t1
ld t2,16(a1); bmatflip t2,t2
ld t3,24(a1); bmatflip t3,t3
ld t4,32(a1); bmatflip t4,t4
ld t5,40(a1); bmatflip t5,t5
ld t6,48(a1); bmatflip t6,t6
ld a1,56(a1); bmatflip a1,a1

li a3, 8
1:
addi a3,a3,-1
addi a2,a2,8

ld a5, 0(a0); bmatxor a4,a5,t0
ld a5, 8(a0); bmatxor a5,a5,t1; xor a4,a4,a5
ld a5,16(a0); bmatxor a5,a5,t2; xor a4,a4,a5
ld a5,24(a0); bmatxor a5,a5,t3; xor a4,a4,a5
ld a5,32(a0); bmatxor a5,a5,t4; xor a4,a4,a5
ld a5,40(a0); bmatxor a5,a5,t5; xor a4,a4,a5
ld a5,48(a0); bmatxor a5,a5,t6; xor a4,a4,a5
ld a5,56(a0); bmatxor a5,a5,a1; xor a4,a4,a5

bmatflip a4,a4
addi a0,a0,64
sd a4,-8(a2)
bnez a3,1b
ret

# -----------------------------------------------

bm64m_bitmanip_kernel_ideal:

# load in2[] to t0,..,t6,a1
ld t0, 0(a1)
ld t1, 8(a1)
ld t2,16(a1)
ld t3,24(a1)
ld t4,32(a1)
ld t5,40(a1)
ld t6,48(a1)
ld a1,56(a1)

li a3, 8
1:
addi a3,a3,-1
addi a2,a2,8

ld a5, 0(a0); bmatxor a4,a5,t0
ld a5, 8(a0); bmatxor a5,a5,t1; xor a4,a4,a5
ld a5,16(a0); bmatxor a5,a5,t2; xor a4,a4,a5
ld a5,24(a0); bmatxor a5,a5,t3; xor a4,a4,a5
ld a5,32(a0); bmatxor a5,a5,t4; xor a4,a4,a5
ld a5,40(a0); bmatxor a5,a5,t5; xor a4,a4,a5
ld a5,48(a0); bmatxor a5,a5,t6; xor a4,a4,a5
ld a5,56(a0); bmatxor a5,a5,a1; xor a4,a4,a5

addi a0,a0,64
sd a4,-8(a2)
bnez a3,1b
ret
