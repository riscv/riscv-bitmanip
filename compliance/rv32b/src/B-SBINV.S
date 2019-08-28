#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s2, 0x778bd1db
    li s5, 0xdef3c035
    sbinv a5,s2,s5
    sw a5,0(a1)
    li t5, 0xffaace79
    li s9, 0x11e15d6b
    sbinv a7,t5,s9
    sw a7,4(a1)
    li s6, 0x04bc5eac
    li s7, 0x33397f4e
    sbinv t3,s6,s7
    sw t3,8(a1)
    li a3, 0x40ee4840
    li a2, 0x18331b85
    sbinv t5,a3,a2
    sw t5,12(a1)
    li a4, 0x5a0d8ae2
    li t6, 0xfaafb8a6
    sbinv s4,a4,t6
    sw s4,16(a1)
    li t0, 0xcccb9502
    li a0, 0xde163e74
    sbinv a4,t0,a0
    sw a4,20(a1)
    li t0, 0x00840094
    li t2, 0x080006c0
    sbinv a7,t0,t2
    sw a7,24(a1)
    li t3, 0x6e136617
    li a7, 0x68356560
    sbinv s0,t3,a7
    sw s0,28(a1)
    li s4, 0x00040011
    li s9, 0xb4946212
    sbinv s7,s4,s9
    sw s7,32(a1)
    li t5, 0x10000085
    li s1, 0x83262662
    sbinv a2,t5,s1
    sw a2,36(a1)
    li s8, 0x1340282b
    li s4, 0x0000061b
    sbinv s7,s8,s4
    sw s7,40(a1)
    li s9, 0x980807fd
    li t2, 0x980a07d2
    sbinv s3,s9,t2
    sw s3,44(a1)
    li a6, 0xdff47340
    li a4, 0x00c505c1
    sbinv s6,a6,a4
    sw s6,48(a1)
    li t6, 0xe46d3d40
    li s11, 0x000806db
    sbinv t3,t6,s11
    sw t3,52(a1)
    li a0, 0x00022c4a
    li t4, 0x5280c5d0
    sbinv s4,a0,t4
    sw s4,56(a1)
    li s9, 0x5f77971c
    li a0, 0x7601006a
    sbinv a5,s9,a0
    sw a5,60(a1)
    li a7, 0x7ffd8efc
    li s5, 0x7bb326df
    sbinv a3,a7,s5
    sw a3,64(a1)
    li s9, 0xf044ff7a
    li t6, 0xb6c01b9a
    sbinv s6,s9,t6
    sw s6,68(a1)
    li s3, 0xfffff31c
    li s6, 0xfffffbc6
    sbinv s1,s3,s6
    sw s1,72(a1)
    li s0, 0xfffffdfc
    li a4, 0x6d39aa61
    sbinv t2,s0,a4
    sw t2,76(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 20,4,-1
RV_COMPLIANCE_DATA_END
