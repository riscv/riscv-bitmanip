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
    li s3, 0x1b17cae5
    li s5, 0xf91bf443
    xnor s7,s3,s5
    sw s7,24(a1)
    li t6, 0x9d11f46b
    li s5, 0x88a17c6f
    xnor t2,t6,s5
    sw t2,28(a1)
    li s1, 0xd83d7fff
    li s3, 0x008800e2
    xnor t3,s1,s3
    sw t3,32(a1)
    li s6, 0x22000412
    li t2, 0x07fffbdd
    xnor t0,s6,t2
    sw t0,36(a1)
    li a6, 0xf7ef0b32
    li t5, 0xebffafa5
    xnor s4,a6,t5
    sw s4,40(a1)
    li s4, 0xd3610008
    li a3, 0xd3ddcdef
    xnor t0,s4,a3
    sw t0,44(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 12,4,-1
RV_COMPLIANCE_DATA_END
