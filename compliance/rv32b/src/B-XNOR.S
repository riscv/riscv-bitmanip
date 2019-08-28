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
    li s3, 0xffaace79
    li a3, 0x11e15d6b
    xnor t2,s3,a3
    sw t2,4(a1)
    li t6, 0x04bc5eac
    li s1, 0x33397f4e
    xnor s3,t6,s1
    sw s3,8(a1)
    li t6, 0x40ee4840
    li t2, 0x18331b85
    xnor a3,t6,t2
    sw a3,12(a1)
    li a6, 0x5a0d8ae2
    li t1, 0xfaafb8a6
    xnor a5,a6,t1
    sw a5,16(a1)
    li a6, 0xcccb9502
    li t6, 0xde163e74
    xnor t3,a6,t6
    sw t3,20(a1)
    li s9, 0x1b17cae5
    li a2, 0xf91bf443
    xnor a7,s9,a2
    sw a7,24(a1)
    li s0, 0x9d11f46b
    li t4, 0x88a17c6f
    xnor s9,s0,t4
    sw s9,28(a1)
    li s8, 0xd83d7fff
    li a0, 0x008800e2
    xnor s10,s8,a0
    sw s10,32(a1)
    li a5, 0x22000412
    li t3, 0x07fffbdd
    xnor s5,a5,t3
    sw s5,36(a1)
    li t2, 0xf7ef0b32
    li a4, 0xebffafa5
    xnor s5,t2,a4
    sw s5,40(a1)
    li s9, 0xd3610008
    li a3, 0xd3ddcdef
    xnor s11,s9,a3
    sw s11,44(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 12,4,-1
RV_COMPLIANCE_DATA_END
