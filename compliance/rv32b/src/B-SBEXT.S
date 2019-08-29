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
    li t6, 0x00840094
    li s11, 0x080006c0
    sbext s0,t6,s11
    sw s0,24(a1)
    li t0, 0x6e136617
    li t5, 0x68356560
    sbext s4,t0,t5
    sw s4,28(a1)
    li a6, 0x00040011
    li a0, 0xb4946212
    sbext t3,a6,a0
    sw t3,32(a1)
    li a3, 0x10000085
    li s8, 0x83262662
    sbext t4,a3,s8
    sw t4,36(a1)
    li t1, 0x1340282b
    li s4, 0x0000061b
    sbext s7,t1,s4
    sw s7,40(a1)
    li s2, 0x980807fd
    li t3, 0x980a07d2
    sbext s5,s2,t3
    sw s5,44(a1)
    li t1, 0xdff47340
    li s6, 0x00c505c1
    sbext t6,t1,s6
    sw t6,48(a1)
    li a2, 0xe46d3d40
    li t0, 0x000806db
    sbext s3,a2,t0
    sw s3,52(a1)
    li a6, 0x00022c4a
    li a0, 0x5280c5d0
    sbext s8,a6,a0
    sw s8,56(a1)
    li s4, 0x5f77971c
    li a7, 0x7601006a
    sbext a4,s4,a7
    sw a4,60(a1)
    li s9, 0x7ffd8efc
    li s5, 0x7bb326df
    sbext s6,s9,s5
    sw s6,64(a1)
    li a3, 0xf044ff7a
    li a6, 0xb6c01b9a
    sbext a0,a3,a6
    sw a0,68(a1)
    li s5, 0xfffff31c
    li s10, 0xfffffbc6
    sbext s6,s5,s10
    sw s6,72(a1)
    li t1, 0xfffffdfc
    li s10, 0x6d39aa61
    sbext a3,t1,s10
    sw a3,76(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 20,4,-1
RV_COMPLIANCE_DATA_END
