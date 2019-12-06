#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a0, 0x778bd1db
    li a3, 0xdef3c035
    sbext a4,a0,a3
    sw a4,0(a1)
    li a6, 0xffaace79
    li t2, 0x11e15d6b
    sbext t0,a6,t2
    sw t0,4(a1)
    li t0, 0x04bc5eac
    li a2, 0x33397f4e
    sbext s8,t0,a2
    sw s8,8(a1)
    li s2, 0x40ee4840
    li t6, 0x18331b85
    sbext s9,s2,t6
    sw s9,12(a1)
    li a5, 0x5a0d8ae2
    li s3, 0xfaafb8a6
    sbext a3,a5,s3
    sw a3,16(a1)
    li s1, 0xcccb9502
    li t1, 0xde163e74
    sbext s6,s1,t1
    sw s6,20(a1)
    li s10, 0x00022c4a
    li s1, 0x5280c5d0
    sbext t2,s10,s1
    sw t2,24(a1)
    li s5, 0x00040011
    li s3, 0xb4946212
    sbext a7,s5,s3
    sw a7,28(a1)
    li t1, 0x00840094
    li t2, 0x080006c0
    sbext a4,t1,t2
    sw a4,32(a1)
    li s9, 0x008a00b0
    li t0, 0x9c1d04b9
    sbext s4,s9,t0
    sw s4,36(a1)
    li a0, 0x10000085
    li s8, 0x83262662
    sbext t3,a0,s8
    sw t3,40(a1)
    li s4, 0x1340282b
    li s9, 0x0000061b
    sbext a3,s4,s9
    sw a3,44(a1)
    li t6, 0x2afd97a8
    li t5, 0x3002c6d8
    sbext s10,t6,t5
    sw s10,48(a1)
    li a7, 0x49484c00
    li s6, 0x4975d377
    sbext t0,a7,s6
    sw t0,52(a1)
    li s8, 0x5f77971c
    li s5, 0x7601006a
    sbext t0,s8,s5
    sw t0,56(a1)
    li a3, 0x6e136617
    li s11, 0x68356560
    sbext t6,a3,s11
    sw t6,60(a1)
    li s6, 0x74108058
    li t4, 0x0adcd03a
    sbext t1,s6,t4
    sw t1,64(a1)
    li a4, 0x7ffd8efc
    li s8, 0x7bb326df
    sbext a5,a4,s8
    sw a5,68(a1)
    li s3, 0x822004fa
    li a3, 0x16d7df1c
    sbext s2,s3,a3
    sw s2,72(a1)
    li s4, 0x85280b88
    li s1, 0x90c24215
    sbext t0,s4,s1
    sw t0,76(a1)
    li s9, 0x980807fd
    li a0, 0x980a07d2
    sbext s0,s9,a0
    sw s0,80(a1)
    li t5, 0x9d233768
    li s5, 0x0c00020d
    sbext s3,t5,s5
    sw s3,84(a1)
    li s3, 0xb4110962
    li t5, 0x64552f5c
    sbext s8,s3,t5
    sw s8,88(a1)
    li a5, 0xbf8b47cf
    li a4, 0xe98014eb
    sbext t3,a5,a4
    sw t3,92(a1)
    li t2, 0xdff47340
    li s9, 0x00c505c1
    sbext a4,t2,s9
    sw a4,96(a1)
    li s5, 0xe46d3d40
    li s1, 0x000806db
    sbext s3,s5,s1
    sw s3,100(a1)
    li s0, 0xf044ff7a
    li a0, 0xb6c01b9a
    sbext t1,s0,a0
    sw t1,104(a1)
    li a5, 0xfe4e45fd
    li s1, 0xcb4ef3f7
    sbext s11,a5,s1
    sw s11,108(a1)
    li s1, 0xfffff31c
    li a7, 0xfffffbc6
    sbext a3,s1,a7
    sw a3,112(a1)
    li s1, 0xfffffdfc
    li a6, 0x6d39aa61
    sbext s0,s1,a6
    sw s0,116(a1)
    sw zero,120(a1)
    sw zero,124(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 32,4,-1
RV_COMPLIANCE_DATA_END
