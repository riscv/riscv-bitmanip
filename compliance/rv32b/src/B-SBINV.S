#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a5, 0x778bd1db
    li t5, 0xdef3c035
    sbinv s11,a5,t5
    sw s11,0(a1)
    li a0, 0xffaace79
    li a3, 0x11e15d6b
    sbinv a4,a0,a3
    sw a4,4(a1)
    li t6, 0x04bc5eac
    li t2, 0x33397f4e
    sbinv a3,t6,t2
    sw a3,8(a1)
    li a2, 0x40ee4840
    li a6, 0x18331b85
    sbinv t0,a2,a6
    sw t0,12(a1)
    li a7, 0x5a0d8ae2
    li t0, 0xfaafb8a6
    sbinv a6,a7,t0
    sw a6,16(a1)
    li s10, 0xcccb9502
    li s2, 0xde163e74
    sbinv a4,s10,s2
    sw a4,20(a1)
    li s7, 0x00022c4a
    li a7, 0x5280c5d0
    sbinv a3,s7,a7
    sw a3,24(a1)
    li t3, 0x00040011
    li s4, 0xb4946212
    sbinv t0,t3,s4
    sw t0,28(a1)
    li a4, 0x00840094
    li a7, 0x080006c0
    sbinv s8,a4,a7
    sw s8,32(a1)
    li t0, 0x008a00b0
    li t5, 0x9c1d04b9
    sbinv s4,t0,t5
    sw s4,36(a1)
    li t1, 0x10000085
    li s2, 0x83262662
    sbinv a7,t1,s2
    sw a7,40(a1)
    li s10, 0x1340282b
    li s4, 0x0000061b
    sbinv s1,s10,s4
    sw s1,44(a1)
    li s5, 0x2afd97a8
    li t4, 0x3002c6d8
    sbinv a5,s5,t4
    sw a5,48(a1)
    li a5, 0x49484c00
    li t3, 0x4975d377
    sbinv s4,a5,t3
    sw s4,52(a1)
    li s7, 0x5f77971c
    li t6, 0x7601006a
    sbinv t5,s7,t6
    sw t5,56(a1)
    li a3, 0x6e136617
    li s2, 0x68356560
    sbinv s5,a3,s2
    sw s5,60(a1)
    li t1, 0x74108058
    li a6, 0x0adcd03a
    sbinv a4,t1,a6
    sw a4,64(a1)
    li t3, 0x7ffd8efc
    li s4, 0x7bb326df
    sbinv s2,t3,s4
    sw s2,68(a1)
    li t3, 0x822004fa
    li s6, 0x16d7df1c
    sbinv s10,t3,s6
    sw s10,72(a1)
    li t1, 0x85280b88
    li t6, 0x90c24215
    sbinv s8,t1,t6
    sw s8,76(a1)
    li s9, 0x980807fd
    li a2, 0x980a07d2
    sbinv a7,s9,a2
    sw a7,80(a1)
    li a6, 0x9d233768
    li s1, 0x0c00020d
    sbinv t6,a6,s1
    sw t6,84(a1)
    li s3, 0xb4110962
    li s0, 0x64552f5c
    sbinv s8,s3,s0
    sw s8,88(a1)
    li a0, 0xbf8b47cf
    li s10, 0xe98014eb
    sbinv s6,a0,s10
    sw s6,92(a1)
    li s9, 0xdff47340
    li s2, 0x00c505c1
    sbinv t2,s9,s2
    sw t2,96(a1)
    li s3, 0xe46d3d40
    li s4, 0x000806db
    sbinv a7,s3,s4
    sw a7,100(a1)
    li s2, 0xf044ff7a
    li s9, 0xb6c01b9a
    sbinv s0,s2,s9
    sw s0,104(a1)
    li t2, 0xfe4e45fd
    li t6, 0xcb4ef3f7
    sbinv t5,t2,t6
    sw t5,108(a1)
    li s2, 0xfffff31c
    li a2, 0xfffffbc6
    sbinv s1,s2,a2
    sw s1,112(a1)
    li t1, 0xfffffdfc
    li t3, 0x6d39aa61
    sbinv t5,t1,t3
    sw t5,116(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 30,4,-1
RV_COMPLIANCE_DATA_END
