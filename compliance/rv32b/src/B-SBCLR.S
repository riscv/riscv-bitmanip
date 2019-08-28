#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s4, 0x778bd1db
    li s2, 0xdef3c035
    sbclr t4,s4,s2
    sw t4,0(a1)
    li s5, 0xffaace79
    li s8, 0x11e15d6b
    sbclr t3,s5,s8
    sw t3,4(a1)
    li s6, 0x04bc5eac
    li t0, 0x33397f4e
    sbclr t6,s6,t0
    sw t6,8(a1)
    li s10, 0x40ee4840
    li s11, 0x18331b85
    sbclr s5,s10,s11
    sw s5,12(a1)
    li a7, 0x5a0d8ae2
    li a0, 0xfaafb8a6
    sbclr s7,a7,a0
    sw s7,16(a1)
    li s11, 0xcccb9502
    li t0, 0xde163e74
    sbclr a7,s11,t0
    sw a7,20(a1)
    li s5, 0x00840094
    li t2, 0x080006c0
    sbclr a3,s5,t2
    sw a3,24(a1)
    li s5, 0x6e136617
    li a3, 0x68356560
    sbclr t5,s5,a3
    sw t5,28(a1)
    li t5, 0x00040011
    li s4, 0xb4946212
    sbclr a5,t5,s4
    sw a5,32(a1)
    li a4, 0x10000085
    li s9, 0x83262662
    sbclr s8,a4,s9
    sw s8,36(a1)
    li s8, 0x1340282b
    li a4, 0x0000061b
    sbclr t1,s8,a4
    sw t1,40(a1)
    li t1, 0x980807fd
    li t4, 0x980a07d2
    sbclr s10,t1,t4
    sw s10,44(a1)
    li t2, 0xdff47340
    li t0, 0x00c505c1
    sbclr t6,t2,t0
    sw t6,48(a1)
    li s2, 0xe46d3d40
    li s5, 0x000806db
    sbclr a6,s2,s5
    sw a6,52(a1)
    li t5, 0x00022c4a
    li s8, 0x5280c5d0
    sbclr t0,t5,s8
    sw t0,56(a1)
    li s10, 0x5f77971c
    li t3, 0x7601006a
    sbclr a0,s10,t3
    sw a0,60(a1)
    li a6, 0x7ffd8efc
    li a0, 0x7bb326df
    sbclr a7,a6,a0
    sw a7,64(a1)
    li a3, 0xf044ff7a
    li s0, 0xb6c01b9a
    sbclr s7,a3,s0
    sw s7,68(a1)
    li s8, 0xfffff31c
    li a4, 0xfffffbc6
    sbclr s9,s8,a4
    sw s9,72(a1)
    li s5, 0xfffffdfc
    li s1, 0x6d39aa61
    sbclr a0,s5,s1
    sw a0,76(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 20,4,-1
RV_COMPLIANCE_DATA_END
