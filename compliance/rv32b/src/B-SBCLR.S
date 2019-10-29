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
    li s6, 0x00022c4a
    li t4, 0x5280c5d0
    sbclr s11,s6,t4
    sw s11,24(a1)
    li s11, 0x00040011
    li s9, 0xb4946212
    sbclr s5,s11,s9
    sw s5,28(a1)
    li s11, 0x00840094
    li s8, 0x080006c0
    sbclr a3,s11,s8
    sw a3,32(a1)
    li s11, 0x008a00b0
    li t4, 0x9c1d04b9
    sbclr s5,s11,t4
    sw s5,36(a1)
    li s11, 0x10000085
    li a7, 0x83262662
    sbclr s7,s11,a7
    sw s7,40(a1)
    li s4, 0x1340282b
    li a3, 0x0000061b
    sbclr s9,s4,a3
    sw s9,44(a1)
    li t5, 0x2afd97a8
    li t6, 0x3002c6d8
    sbclr s1,t5,t6
    sw s1,48(a1)
    li s6, 0x49484c00
    li s0, 0x4975d377
    sbclr s2,s6,s0
    sw s2,52(a1)
    li s10, 0x5f77971c
    li s5, 0x7601006a
    sbclr s1,s10,s5
    sw s1,56(a1)
    li a7, 0x6e136617
    li s5, 0x68356560
    sbclr s0,a7,s5
    sw s0,60(a1)
    li s7, 0x74108058
    li a0, 0x0adcd03a
    sbclr s11,s7,a0
    sw s11,64(a1)
    li s8, 0x7ffd8efc
    li s3, 0x7bb326df
    sbclr a0,s8,s3
    sw a0,68(a1)
    li s11, 0x822004fa
    li t6, 0x16d7df1c
    sbclr s2,s11,t6
    sw s2,72(a1)
    li t6, 0x85280b88
    li s11, 0x90c24215
    sbclr a3,t6,s11
    sw a3,76(a1)
    li a3, 0x980807fd
    li s0, 0x980a07d2
    sbclr t0,a3,s0
    sw t0,80(a1)
    li s0, 0x9d233768
    li a4, 0x0c00020d
    sbclr s2,s0,a4
    sw s2,84(a1)
    li s2, 0xb4110962
    li s10, 0x64552f5c
    sbclr a7,s2,s10
    sw a7,88(a1)
    li s8, 0xbf8b47cf
    li a3, 0xe98014eb
    sbclr a7,s8,a3
    sw a7,92(a1)
    li t3, 0xdff47340
    li a3, 0x00c505c1
    sbclr s2,t3,a3
    sw s2,96(a1)
    li s2, 0xe46d3d40
    li t5, 0x000806db
    sbclr t2,s2,t5
    sw t2,100(a1)
    li a3, 0xf044ff7a
    li s11, 0xb6c01b9a
    sbclr t0,a3,s11
    sw t0,104(a1)
    li a2, 0xfe4e45fd
    li s1, 0xcb4ef3f7
    sbclr t2,a2,s1
    sw t2,108(a1)
    li a2, 0xfffff31c
    li t2, 0xfffffbc6
    sbclr s9,a2,t2
    sw s9,112(a1)
    li a5, 0xfffffdfc
    li s1, 0x6d39aa61
    sbclr s3,a5,s1
    sw s3,116(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 30,4,-1
RV_COMPLIANCE_DATA_END
