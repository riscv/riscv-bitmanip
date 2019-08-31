#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t6, 0x778bd1db
    li a5, 0xdef3c035
    sbext s8,t6,a5
    sw s8,0(a1)
    li t2, 0xffaace79
    li s2, 0x11e15d6b
    sbext t0,t2,s2
    sw t0,4(a1)
    li a2, 0x04bc5eac
    li a6, 0x33397f4e
    sbext s5,a2,a6
    sw s5,8(a1)
    li s3, 0x40ee4840
    li t0, 0x18331b85
    sbext s9,s3,t0
    sw s9,12(a1)
    li a2, 0x5a0d8ae2
    li s9, 0xfaafb8a6
    sbext s8,a2,s9
    sw s8,16(a1)
    li s5, 0xcccb9502
    li t5, 0xde163e74
    sbext a2,s5,t5
    sw a2,20(a1)
    li s4, 0x00022c4a
    li t1, 0x5280c5d0
    sbext a6,s4,t1
    sw a6,24(a1)
    li t3, 0x00040011
    li s0, 0xb4946212
    sbext a2,t3,s0
    sw a2,28(a1)
    li t4, 0x00840094
    li t6, 0x080006c0
    sbext s5,t4,t6
    sw s5,32(a1)
    li a7, 0x008a00b0
    li t1, 0x9c1d04b9
    sbext s6,a7,t1
    sw s6,36(a1)
    li a3, 0x10000085
    li s11, 0x83262662
    sbext s10,a3,s11
    sw s10,40(a1)
    li a5, 0x1340282b
    li s6, 0x0000061b
    sbext a7,a5,s6
    sw a7,44(a1)
    li s10, 0x2afd97a8
    li s1, 0x3002c6d8
    sbext t2,s10,s1
    sw t2,48(a1)
    li s5, 0x49484c00
    li s3, 0x4975d377
    sbext a7,s5,s3
    sw a7,52(a1)
    li t1, 0x5f77971c
    li t2, 0x7601006a
    sbext a4,t1,t2
    sw a4,56(a1)
    li s9, 0x6e136617
    li t0, 0x68356560
    sbext s4,s9,t0
    sw s4,60(a1)
    li a0, 0x74108058
    li s8, 0x0adcd03a
    sbext t3,a0,s8
    sw t3,64(a1)
    li s4, 0x7ffd8efc
    li s9, 0x7bb326df
    sbext a3,s4,s9
    sw a3,68(a1)
    li t6, 0x822004fa
    li t5, 0x16d7df1c
    sbext s10,t6,t5
    sw s10,72(a1)
    li a7, 0x85280b88
    li s6, 0x90c24215
    sbext t0,a7,s6
    sw t0,76(a1)
    li s8, 0x980807fd
    li s5, 0x980a07d2
    sbext t0,s8,s5
    sw t0,80(a1)
    li a3, 0x9d233768
    li s11, 0x0c00020d
    sbext t6,a3,s11
    sw t6,84(a1)
    li s6, 0xb4110962
    li t4, 0x64552f5c
    sbext t1,s6,t4
    sw t1,88(a1)
    li a4, 0xbf8b47cf
    li s8, 0xe98014eb
    sbext a5,a4,s8
    sw a5,92(a1)
    li s3, 0xdff47340
    li a3, 0x00c505c1
    sbext s2,s3,a3
    sw s2,96(a1)
    li s4, 0xe46d3d40
    li s1, 0x000806db
    sbext t0,s4,s1
    sw t0,100(a1)
    li s9, 0xf044ff7a
    li a0, 0xb6c01b9a
    sbext s0,s9,a0
    sw s0,104(a1)
    li t5, 0xfe4e45fd
    li s5, 0xcb4ef3f7
    sbext s3,t5,s5
    sw s3,108(a1)
    li s3, 0xfffff31c
    li t5, 0xfffffbc6
    sbext s8,s3,t5
    sw s8,112(a1)
    li a5, 0xfffffdfc
    li a4, 0x6d39aa61
    sbext t3,a5,a4
    sw t3,116(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 30,4,-1
RV_COMPLIANCE_DATA_END
