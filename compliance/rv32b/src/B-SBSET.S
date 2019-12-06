#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t5, 0x778bd1db
    li s9, 0xdef3c035
    sbset a7,t5,s9
    sw a7,0(a1)
    li a7, 0xffaace79
    li a3, 0x11e15d6b
    sbset a6,a7,a3
    sw a6,4(a1)
    li s3, 0x04bc5eac
    li t0, 0x33397f4e
    sbset s9,s3,t0
    sw s9,8(a1)
    li s11, 0x40ee4840
    li t0, 0x18331b85
    sbset a7,s11,t0
    sw a7,12(a1)
    li s1, 0x5a0d8ae2
    li s9, 0xfaafb8a6
    sbset s5,s1,s9
    sw s5,16(a1)
    li s2, 0xcccb9502
    li a2, 0xde163e74
    sbset s7,s2,a2
    sw s7,20(a1)
    li a0, 0x00022c4a
    li s8, 0x5280c5d0
    sbset t3,a0,s8
    sw t3,24(a1)
    li s4, 0x00040011
    li s9, 0xb4946212
    sbset a3,s4,s9
    sw a3,28(a1)
    li t6, 0x00840094
    li t5, 0x080006c0
    sbset s10,t6,t5
    sw s10,32(a1)
    li a7, 0x008a00b0
    li s6, 0x9c1d04b9
    sbset t0,a7,s6
    sw t0,36(a1)
    li s8, 0x10000085
    li s5, 0x83262662
    sbset t0,s8,s5
    sw t0,40(a1)
    li a3, 0x1340282b
    li s11, 0x0000061b
    sbset t6,a3,s11
    sw t6,44(a1)
    li s6, 0x2afd97a8
    li t4, 0x3002c6d8
    sbset t1,s6,t4
    sw t1,48(a1)
    li a4, 0x49484c00
    li s8, 0x4975d377
    sbset a5,a4,s8
    sw a5,52(a1)
    li s3, 0x5f77971c
    li a3, 0x7601006a
    sbset s2,s3,a3
    sw s2,56(a1)
    li s4, 0x6e136617
    li s1, 0x68356560
    sbset t0,s4,s1
    sw t0,60(a1)
    li s9, 0x74108058
    li a0, 0x0adcd03a
    sbset s0,s9,a0
    sw s0,64(a1)
    li t5, 0x7ffd8efc
    li s5, 0x7bb326df
    sbset s3,t5,s5
    sw s3,68(a1)
    li s3, 0x822004fa
    li t5, 0x16d7df1c
    sbset s8,s3,t5
    sw s8,72(a1)
    li a5, 0x85280b88
    li a4, 0x90c24215
    sbset t3,a5,a4
    sw t3,76(a1)
    li t2, 0x980807fd
    li s9, 0x980a07d2
    sbset a4,t2,s9
    sw a4,80(a1)
    li s5, 0x9d233768
    li s1, 0x0c00020d
    sbset s3,s5,s1
    sw s3,84(a1)
    li s0, 0xb4110962
    li a0, 0x64552f5c
    sbset t1,s0,a0
    sw t1,88(a1)
    li a5, 0xbf8b47cf
    li s1, 0xe98014eb
    sbset s11,a5,s1
    sw s11,92(a1)
    li s1, 0xdff47340
    li a7, 0x00c505c1
    sbset a3,s1,a7
    sw a3,96(a1)
    li s1, 0xe46d3d40
    li a6, 0x000806db
    sbset s0,s1,a6
    sw s0,100(a1)
    li a2, 0xf044ff7a
    li s8, 0xb6c01b9a
    sbset s11,a2,s8
    sw s11,104(a1)
    li t6, 0xfe4e45fd
    li a4, 0xcb4ef3f7
    sbset s2,t6,a4
    sw s2,108(a1)
    li s10, 0xfffff31c
    li s0, 0xfffffbc6
    sbset s2,s10,s0
    sw s2,112(a1)
    li t6, 0xfffffdfc
    li a4, 0x6d39aa61
    sbset s0,t6,a4
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
