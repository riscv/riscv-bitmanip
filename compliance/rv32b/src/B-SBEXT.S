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
    li s3, 0x00022c4a
    li t3, 0x5280c5d0
    sbext a6,s3,t3
    sw a6,24(a1)
    li a5, 0x00040011
    li t2, 0xb4946212
    sbext t0,a5,t2
    sw t0,28(a1)
    li s7, 0x00840094
    li s3, 0x080006c0
    sbext s6,s7,s3
    sw s6,32(a1)
    li s7, 0x008a00b0
    li t5, 0x9c1d04b9
    sbext t1,s7,t5
    sw t1,36(a1)
    li s10, 0x10000085
    li a2, 0x83262662
    sbext t6,s10,a2
    sw t6,40(a1)
    li a3, 0x1340282b
    li s9, 0x0000061b
    sbext s7,a3,s9
    sw s7,44(a1)
    li t6, 0x2afd97a8
    li a0, 0x3002c6d8
    sbext s11,t6,a0
    sw s11,48(a1)
    li s6, 0x49484c00
    li s2, 0x4975d377
    sbext s11,s6,s2
    sw s11,52(a1)
    li s4, 0x5f77971c
    li a0, 0x7601006a
    sbext t6,s4,a0
    sw t6,56(a1)
    li s6, 0x6e136617
    li s4, 0x68356560
    sbext s8,s6,s4
    sw s8,60(a1)
    li s5, 0x74108058
    li t6, 0x0adcd03a
    sbext s6,s5,t6
    sw s6,64(a1)
    li s7, 0x7ffd8efc
    li t1, 0x7bb326df
    sbext a6,s7,t1
    sw a6,68(a1)
    li t2, 0x822004fa
    li s9, 0x16d7df1c
    sbext s6,t2,s9
    sw s6,72(a1)
    li s2, 0x85280b88
    li a5, 0x90c24215
    sbext t3,s2,a5
    sw t3,76(a1)
    li t1, 0x980807fd
    li s2, 0x980a07d2
    sbext s7,t1,s2
    sw s7,80(a1)
    li s2, 0x9d233768
    li t6, 0x0c00020d
    sbext s0,s2,t6
    sw s0,84(a1)
    li t2, 0xb4110962
    li t3, 0x64552f5c
    sbext t1,t2,t3
    sw t1,88(a1)
    li s7, 0xbf8b47cf
    li a2, 0xe98014eb
    sbext a7,s7,a2
    sw a7,92(a1)
    li s3, 0xdff47340
    li t0, 0x00c505c1
    sbext a5,s3,t0
    sw a5,96(a1)
    li s4, 0xe46d3d40
    li t3, 0x000806db
    sbext s1,s4,t3
    sw s1,100(a1)
    li t3, 0xf044ff7a
    li s9, 0xb6c01b9a
    sbext s5,t3,s9
    sw s5,104(a1)
    li a5, 0xfe4e45fd
    li t6, 0xcb4ef3f7
    sbext t4,a5,t6
    sw t4,108(a1)
    li a0, 0xfffff31c
    li s3, 0xfffffbc6
    sbext t0,a0,s3
    sw t0,112(a1)
    li s3, 0xfffffdfc
    li s7, 0x6d39aa61
    sbext t3,s3,s7
    sw t3,116(a1)
    sw zero,120(a1)
    sw zero,124(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 32,4,-1
RV_COMPLIANCE_DATA_END
