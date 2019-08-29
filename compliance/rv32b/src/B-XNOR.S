#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s2, 0x778bd1db
    li t0, 0xdef3c035
    xnor t4,s2,t0
    sw t4,0(a1)
    li a3, 0xffaace79
    li a5, 0x11e15d6b
    xnor a2,a3,a5
    sw a2,4(a1)
    li s4, 0x04bc5eac
    li a2, 0x33397f4e
    xnor t6,s4,a2
    sw t6,8(a1)
    li s1, 0x40ee4840
    li t4, 0x18331b85
    xnor t3,s1,t4
    sw t3,12(a1)
    li a4, 0x5a0d8ae2
    li t6, 0xfaafb8a6
    xnor s4,a4,t6
    sw s4,16(a1)
    li s2, 0xcccb9502
    li t6, 0xde163e74
    xnor s9,s2,t6
    sw s9,20(a1)
    li t6, 0x1b17cae5
    li s11, 0xf91bf443
    xnor a5,t6,s11
    sw a5,24(a1)
    li s10, 0x9d11f46b
    li s5, 0x88a17c6f
    xnor a5,s10,s5
    sw a5,28(a1)
    li s10, 0xd83d7fff
    li a2, 0x008800e2
    xnor s7,s10,a2
    sw s7,32(a1)
    li a6, 0x22000412
    li t1, 0x07fffbdd
    xnor s9,a6,t1
    sw s9,36(a1)
    li s9, 0xf7ef0b32
    li t4, 0xebffafa5
    xnor s7,s9,t4
    sw s7,40(a1)
    li t4, 0xd3610008
    li t5, 0xd3ddcdef
    xnor t3,t4,t5
    sw t3,44(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 12,4,-1
RV_COMPLIANCE_DATA_END
