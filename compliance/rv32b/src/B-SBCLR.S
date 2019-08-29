#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s2, 0x778bd1db
    li s5, 0xdef3c035
    sbclr a5,s2,s5
    sw a5,0(a1)
    li s8, 0xffaace79
    li s1, 0x11e15d6b
    sbclr t4,s8,s1
    sw t4,4(a1)
    li a7, 0x04bc5eac
    li a3, 0x33397f4e
    sbclr a6,a7,a3
    sw a6,8(a1)
    li a5, 0x40ee4840
    li a6, 0x18331b85
    sbclr a4,a5,a6
    sw a4,12(a1)
    li s10, 0x5a0d8ae2
    li t6, 0xfaafb8a6
    sbclr s5,s10,t6
    sw s5,16(a1)
    li a4, 0xcccb9502
    li s9, 0xde163e74
    sbclr t0,a4,s9
    sw t0,20(a1)
    li s8, 0x00840094
    li s4, 0x080006c0
    sbclr s7,s8,s4
    sw s7,24(a1)
    li s9, 0x6e136617
    li t2, 0x68356560
    sbclr s3,s9,t2
    sw s3,28(a1)
    li a6, 0x00040011
    li a4, 0xb4946212
    sbclr s6,a6,a4
    sw s6,32(a1)
    li t6, 0x10000085
    li s11, 0x83262662
    sbclr t3,t6,s11
    sw t3,36(a1)
    li a0, 0x1340282b
    li t4, 0x0000061b
    sbclr s4,a0,t4
    sw s4,40(a1)
    li s9, 0x980807fd
    li a0, 0x980a07d2
    sbclr a5,s9,a0
    sw a5,44(a1)
    li a7, 0xdff47340
    li s5, 0x00c505c1
    sbclr a3,a7,s5
    sw a3,48(a1)
    li s9, 0xe46d3d40
    li t6, 0x000806db
    sbclr s6,s9,t6
    sw s6,52(a1)
    li s3, 0x00022c4a
    li s6, 0x5280c5d0
    sbclr s1,s3,s6
    sw s1,56(a1)
    li s0, 0x5f77971c
    li a4, 0x7601006a
    sbclr t2,s0,a4
    sw t2,60(a1)
    li s1, 0x7ffd8efc
    li t6, 0x7bb326df
    sbclr t4,s1,t6
    sw t4,64(a1)
    li s8, 0xf044ff7a
    li s1, 0xb6c01b9a
    sbclr t0,s8,s1
    sw t0,68(a1)
    li a0, 0xfffff31c
    li a4, 0xfffffbc6
    sbclr t4,a0,a4
    sw t4,72(a1)
    li t3, 0xfffffdfc
    li s4, 0x6d39aa61
    sbclr a6,t3,s4
    sw a6,76(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 20,4,-1
RV_COMPLIANCE_DATA_END
