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
    li s5, 0x00022c4a
    li t4, 0x5280c5d0
    sbinv a5,s5,t4
    sw a5,24(a1)
    li a5, 0x00040011
    li t3, 0xb4946212
    sbinv s4,a5,t3
    sw s4,28(a1)
    li s7, 0x00840094
    li t6, 0x080006c0
    sbinv t5,s7,t6
    sw t5,32(a1)
    li a3, 0x008a00b0
    li s2, 0x9c1d04b9
    sbinv s5,a3,s2
    sw s5,36(a1)
    li t1, 0x10000085
    li a6, 0x83262662
    sbinv a4,t1,a6
    sw a4,40(a1)
    li t3, 0x1340282b
    li s4, 0x0000061b
    sbinv s2,t3,s4
    sw s2,44(a1)
    li t3, 0x2afd97a8
    li s6, 0x3002c6d8
    sbinv s10,t3,s6
    sw s10,48(a1)
    li t1, 0x49484c00
    li t6, 0x4975d377
    sbinv s8,t1,t6
    sw s8,52(a1)
    li s9, 0x5f77971c
    li a2, 0x7601006a
    sbinv a7,s9,a2
    sw a7,56(a1)
    li a6, 0x6e136617
    li s1, 0x68356560
    sbinv t6,a6,s1
    sw t6,60(a1)
    li s3, 0x74108058
    li s0, 0x0adcd03a
    sbinv s8,s3,s0
    sw s8,64(a1)
    li a0, 0x7ffd8efc
    li s10, 0x7bb326df
    sbinv s6,a0,s10
    sw s6,68(a1)
    li s9, 0x822004fa
    li s2, 0x16d7df1c
    sbinv t2,s9,s2
    sw t2,72(a1)
    li s3, 0x85280b88
    li s4, 0x90c24215
    sbinv a7,s3,s4
    sw a7,76(a1)
    li s2, 0x980807fd
    li s9, 0x980a07d2
    sbinv s0,s2,s9
    sw s0,80(a1)
    li t2, 0x9d233768
    li t6, 0x0c00020d
    sbinv t5,t2,t6
    sw t5,84(a1)
    li s2, 0xb4110962
    li a2, 0x64552f5c
    sbinv s1,s2,a2
    sw s1,88(a1)
    li t1, 0xbf8b47cf
    li t3, 0xe98014eb
    sbinv t5,t1,t3
    sw t5,92(a1)
    li t0, 0xdff47340
    li s6, 0x00c505c1
    sbinv s3,t0,s6
    sw s3,96(a1)
    li s8, 0xe46d3d40
    li s6, 0x000806db
    sbinv t6,s8,s6
    sw t6,100(a1)
    li s0, 0xf044ff7a
    li a7, 0xb6c01b9a
    sbinv a6,s0,a7
    sw a6,104(a1)
    li a7, 0xfe4e45fd
    li a5, 0xcb4ef3f7
    sbinv s4,a7,a5
    sw s4,108(a1)
    li a4, 0xfffff31c
    li s8, 0xfffffbc6
    sbinv t1,a4,s8
    sw t1,112(a1)
    li s2, 0xfffffdfc
    li s5, 0x6d39aa61
    sbinv t6,s2,s5
    sw t6,116(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 30,4,-1
RV_COMPLIANCE_DATA_END
