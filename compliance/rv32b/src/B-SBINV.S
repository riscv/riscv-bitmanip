#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s8, 0x778bd1db
    li s1, 0xdef3c035
    sbinv t4,s8,s1
    sw t4,0(a1)
    li a2, 0xffaace79
    li a6, 0x11e15d6b
    sbinv s5,a2,a6
    sw s5,4(a1)
    li a5, 0x04bc5eac
    li s6, 0x33397f4e
    sbinv a3,a5,s6
    sw a3,8(a1)
    li a0, 0x40ee4840
    li a5, 0x18331b85
    sbinv a7,a0,a5
    sw a7,12(a1)
    li a0, 0x5a0d8ae2
    li s11, 0xfaafb8a6
    sbinv s0,a0,s11
    sw s0,16(a1)
    li s7, 0xcccb9502
    li s10, 0xde163e74
    sbinv s4,s7,s10
    sw s4,20(a1)
    li s4, 0x00022c4a
    li a3, 0x5280c5d0
    sbinv s9,s4,a3
    sw s9,24(a1)
    li t5, 0x00040011
    li t6, 0xb4946212
    sbinv s1,t5,t6
    sw s1,28(a1)
    li s6, 0x00840094
    li s0, 0x080006c0
    sbinv s2,s6,s0
    sw s2,32(a1)
    li s10, 0x008a00b0
    li s5, 0x9c1d04b9
    sbinv s1,s10,s5
    sw s1,36(a1)
    li a7, 0x10000085
    li s5, 0x83262662
    sbinv s0,a7,s5
    sw s0,40(a1)
    li s7, 0x1340282b
    li a0, 0x0000061b
    sbinv s11,s7,a0
    sw s11,44(a1)
    li s8, 0x2afd97a8
    li s3, 0x3002c6d8
    sbinv a0,s8,s3
    sw a0,48(a1)
    li s11, 0x49484c00
    li t6, 0x4975d377
    sbinv s2,s11,t6
    sw s2,52(a1)
    li t6, 0x5f77971c
    li s11, 0x7601006a
    sbinv a3,t6,s11
    sw a3,56(a1)
    li a3, 0x6e136617
    li s0, 0x68356560
    sbinv t0,a3,s0
    sw t0,60(a1)
    li s0, 0x74108058
    li a4, 0x0adcd03a
    sbinv s2,s0,a4
    sw s2,64(a1)
    li s2, 0x7ffd8efc
    li s10, 0x7bb326df
    sbinv a7,s2,s10
    sw a7,68(a1)
    li s8, 0x822004fa
    li a3, 0x16d7df1c
    sbinv a7,s8,a3
    sw a7,72(a1)
    li t3, 0x85280b88
    li a3, 0x90c24215
    sbinv s2,t3,a3
    sw s2,76(a1)
    li s2, 0x980807fd
    li t5, 0x980a07d2
    sbinv t2,s2,t5
    sw t2,80(a1)
    li a3, 0x9d233768
    li s11, 0x0c00020d
    sbinv t0,a3,s11
    sw t0,84(a1)
    li a2, 0xb4110962
    li s1, 0x64552f5c
    sbinv t2,a2,s1
    sw t2,88(a1)
    li a2, 0xbf8b47cf
    li t2, 0xe98014eb
    sbinv s9,a2,t2
    sw s9,92(a1)
    li a5, 0xdff47340
    li s1, 0x00c505c1
    sbinv s3,a5,s1
    sw s3,96(a1)
    li a7, 0xe46d3d40
    li t3, 0x000806db
    sbinv a3,a7,t3
    sw a3,100(a1)
    li t1, 0xf044ff7a
    li t4, 0xb6c01b9a
    sbinv s4,t1,t4
    sw s4,104(a1)
    li t4, 0xfe4e45fd
    li s5, 0xcb4ef3f7
    sbinv s6,t4,s5
    sw s6,108(a1)
    li a4, 0xfffff31c
    li t6, 0xfffffbc6
    sbinv s10,a4,t6
    sw s10,112(a1)
    li s10, 0xfffffdfc
    li s5, 0x6d39aa61
    sbinv a7,s10,s5
    sw a7,116(a1)
    sw zero,120(a1)
    sw zero,124(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 32,4,-1
RV_COMPLIANCE_DATA_END
