#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s5, 0x778bd1db
    li a7, 0xdef3c035
    orn s7,s5,a7
    sw s7,0(a1)
    li s3, 0xffaace79
    li a4, 0x11e15d6b
    orn t4,s3,a4
    sw t4,4(a1)
    li t2, 0x04bc5eac
    li s2, 0x33397f4e
    orn t0,t2,s2
    sw t0,8(a1)
    li a7, 0x40ee4840
    li a3, 0x18331b85
    orn a6,a7,a3
    sw a6,12(a1)
    li s9, 0x5a0d8ae2
    li s10, 0xfaafb8a6
    orn a6,s9,s10
    sw a6,16(a1)
    li t6, 0xcccb9502
    li s5, 0xde163e74
    orn s11,t6,s5
    sw s11,20(a1)
    li s2, 0x1b17cae5
    li t0, 0xf91bf443
    orn t6,s2,t0
    sw t6,24(a1)
    li s4, 0x9d11f46b
    li t1, 0x88a17c6f
    orn t4,s4,t1
    sw t4,28(a1)
    li t3, 0xd83d7fff
    li t0, 0x008800e2
    orn s10,t3,t0
    sw s10,32(a1)
    li s7, 0x22000412
    li a4, 0x07fffbdd
    orn t0,s7,a4
    sw t0,36(a1)
    li a7, 0xf7ef0b32
    li t2, 0xebffafa5
    orn s10,a7,t2
    sw s10,40(a1)
    li s1, 0xd3610008
    li t6, 0xd3ddcdef
    orn t2,s1,t6
    sw t2,44(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 12,4,-1
RV_COMPLIANCE_DATA_END
