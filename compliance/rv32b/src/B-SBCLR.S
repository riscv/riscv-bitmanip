#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a4, 0x778bd1db
    li a5, 0xdef3c035
    sbclr t2,a4,a5
    sw t2,0(a1)
    li t6, 0xffaace79
    li t2, 0x11e15d6b
    sbclr a3,t6,t2
    sw a3,4(a1)
    li a4, 0x04bc5eac
    li s8, 0x33397f4e
    sbclr t4,a4,s8
    sw t4,8(a1)
    li t0, 0x40ee4840
    li a0, 0x18331b85
    sbclr a4,t0,a0
    sw a4,12(a1)
    li a7, 0x5a0d8ae2
    li s2, 0xfaafb8a6
    sbclr s4,a7,s2
    sw s4,16(a1)
    li s1, 0xcccb9502
    li s4, 0xde163e74
    sbclr a0,s1,s4
    sw a0,20(a1)
    li t1, 0x00022c4a
    li a6, 0x5280c5d0
    sbclr a4,t1,a6
    sw a4,24(a1)
    li t3, 0x00040011
    li s4, 0xb4946212
    sbclr s2,t3,s4
    sw s2,28(a1)
    li t3, 0x00840094
    li s6, 0x080006c0
    sbclr s10,t3,s6
    sw s10,32(a1)
    li t1, 0x008a00b0
    li t6, 0x9c1d04b9
    sbclr s8,t1,t6
    sw s8,36(a1)
    li s9, 0x10000085
    li a2, 0x83262662
    sbclr a7,s9,a2
    sw a7,40(a1)
    li a6, 0x1340282b
    li s1, 0x0000061b
    sbclr t6,a6,s1
    sw t6,44(a1)
    li s3, 0x2afd97a8
    li s0, 0x3002c6d8
    sbclr s8,s3,s0
    sw s8,48(a1)
    li a0, 0x49484c00
    li s10, 0x4975d377
    sbclr s6,a0,s10
    sw s6,52(a1)
    li s9, 0x5f77971c
    li s2, 0x7601006a
    sbclr t2,s9,s2
    sw t2,56(a1)
    li s3, 0x6e136617
    li s4, 0x68356560
    sbclr a7,s3,s4
    sw a7,60(a1)
    li s2, 0x74108058
    li s9, 0x0adcd03a
    sbclr s0,s2,s9
    sw s0,64(a1)
    li t2, 0x7ffd8efc
    li t6, 0x7bb326df
    sbclr t5,t2,t6
    sw t5,68(a1)
    li s2, 0x822004fa
    li a2, 0x16d7df1c
    sbclr s1,s2,a2
    sw s1,72(a1)
    li t1, 0x85280b88
    li t3, 0x90c24215
    sbclr t5,t1,t3
    sw t5,76(a1)
    li t0, 0x980807fd
    li s6, 0x980a07d2
    sbclr s3,t0,s6
    sw s3,80(a1)
    li s8, 0x9d233768
    li s6, 0x0c00020d
    sbclr t6,s8,s6
    sw t6,84(a1)
    li s0, 0xb4110962
    li a7, 0x64552f5c
    sbclr a6,s0,a7
    sw a6,88(a1)
    li a7, 0xbf8b47cf
    li a5, 0xe98014eb
    sbclr s4,a7,a5
    sw s4,92(a1)
    li a4, 0xdff47340
    li s8, 0x00c505c1
    sbclr t1,a4,s8
    sw t1,96(a1)
    li s2, 0xe46d3d40
    li s5, 0x000806db
    sbclr t6,s2,s5
    sw t6,100(a1)
    li s8, 0xf044ff7a
    li s5, 0xb6c01b9a
    sbclr t3,s8,s5
    sw t3,104(a1)
    li s2, 0xfe4e45fd
    li a6, 0xcb4ef3f7
    sbclr t3,s2,a6
    sw t3,108(a1)
    li s6, 0xfffff31c
    li s9, 0xfffffbc6
    sbclr a0,s6,s9
    sw a0,112(a1)
    li s0, 0xfffffdfc
    li t3, 0x6d39aa61
    sbclr s1,s0,t3
    sw s1,116(a1)
    sw zero,120(a1)
    sw zero,124(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 32,4,-1
RV_COMPLIANCE_DATA_END
