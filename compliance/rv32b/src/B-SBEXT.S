#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a5, 0x778bd1db
    li t5, 0xdef3c035
    sbext s11,a5,t5
    sw s11,0(a1)
    li a4, 0xffaace79
    li a5, 0x11e15d6b
    sbext t2,a4,a5
    sw t2,4(a1)
    li s5, 0x04bc5eac
    li s0, 0x33397f4e
    sbext s1,s5,s0
    sw s1,8(a1)
    li a5, 0x40ee4840
    li a7, 0x18331b85
    sbext t5,a5,a7
    sw t5,12(a1)
    li a7, 0x5a0d8ae2
    li a4, 0xfaafb8a6
    sbext a5,a7,a4
    sw a5,16(a1)
    li a0, 0xcccb9502
    li a5, 0xde163e74
    sbext a7,a0,a5
    sw a7,20(a1)
    li s9, 0x00840094
    li t4, 0x080006c0
    sbext a0,s9,t4
    sw a0,24(a1)
    li a6, 0x6e136617
    li s7, 0x68356560
    sbext s5,a6,s7
    sw s5,28(a1)
    li s2, 0x00040011
    li t2, 0xb4946212
    sbext s3,s2,t2
    sw s3,32(a1)
    li a5, 0x10000085
    li s4, 0x83262662
    sbext s8,a5,s4
    sw s8,36(a1)
    li s4, 0x1340282b
    li s3, 0x0000061b
    sbext s10,s4,s3
    sw s10,40(a1)
    li s10, 0x980807fd
    li s9, 0x980a07d2
    sbext t5,s10,s9
    sw t5,44(a1)
    li t6, 0xdff47340
    li a3, 0x00c505c1
    sbext s8,t6,a3
    sw s8,48(a1)
    li s2, 0xe46d3d40
    li s10, 0x000806db
    sbext a0,s2,s10
    sw a0,52(a1)
    li s5, 0x00022c4a
    li s11, 0x5280c5d0
    sbext s9,s5,s11
    sw s9,56(a1)
    li s4, 0x5f77971c
    li s7, 0x7601006a
    sbext a5,s4,s7
    sw a5,60(a1)
    li s7, 0x7ffd8efc
    li s0, 0x7bb326df
    sbext s2,s7,s0
    sw s2,64(a1)
    li s8, 0xf044ff7a
    li a0, 0xb6c01b9a
    sbext t3,s8,a0
    sw t3,68(a1)
    li t2, 0xfffff31c
    li s8, 0xfffffbc6
    sbext s3,t2,s8
    sw s3,72(a1)
    li t0, 0xfffffdfc
    li a4, 0x6d39aa61
    sbext a0,t0,a4
    sw a0,76(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 20,4,-1
RV_COMPLIANCE_DATA_END
