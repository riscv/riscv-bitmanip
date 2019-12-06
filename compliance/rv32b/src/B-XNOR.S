#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s3, 0x778bd1db
    li a4, 0xdef3c035
    xnor t4,s3,a4
    sw t4,0(a1)
    li a5, 0xffaace79
    li s0, 0x11e15d6b
    xnor t3,a5,s0
    sw t3,4(a1)
    li s10, 0x04bc5eac
    li s11, 0x33397f4e
    xnor s5,s10,s11
    sw s5,8(a1)
    li t5, 0x40ee4840
    li s10, 0x18331b85
    xnor a0,t5,s10
    sw a0,12(a1)
    li s11, 0x5a0d8ae2
    li s0, 0xfaafb8a6
    xnor a3,s11,s0
    sw a3,16(a1)
    li s11, 0xcccb9502
    li a6, 0xde163e74
    xnor s4,s11,a6
    sw s4,20(a1)
    li t3, 0x1b17cae5
    li s8, 0xf91bf443
    xnor a6,t3,s8
    sw a6,24(a1)
    li a3, 0x9d11f46b
    li t3, 0x88a17c6f
    xnor s6,a3,t3
    sw s6,28(a1)
    li s0, 0xd83d7fff
    li a4, 0x008800e2
    xnor a2,s0,a4
    sw a2,32(a1)
    li a6, 0x22000412
    li t4, 0x07fffbdd
    xnor s1,a6,t4
    sw s1,36(a1)
    li t1, 0xf7ef0b32
    li s10, 0xebffafa5
    xnor a3,t1,s10
    sw a3,40(a1)
    li t1, 0xd3610008
    li t5, 0xd3ddcdef
    xnor t6,t1,t5
    sw t6,44(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 12,4,-1
RV_COMPLIANCE_DATA_END
