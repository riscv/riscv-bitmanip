#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a7, 0x778bd1db
    li t4, 0xdef3c035
    orn t6,a7,t4
    sw t6,0(a1)
    li s6, 0xffaace79
    li a5, 0x11e15d6b
    orn a6,s6,a5
    sw a6,4(a1)
    li s1, 0x04bc5eac
    li t4, 0x33397f4e
    orn t3,s1,t4
    sw t3,8(a1)
    li s8, 0x40ee4840
    li a2, 0x18331b85
    orn t2,s8,a2
    sw t2,12(a1)
    li s6, 0x5a0d8ae2
    li t5, 0xfaafb8a6
    orn a4,s6,t5
    sw a4,16(a1)
    li s6, 0xcccb9502
    li s5, 0xde163e74
    orn t0,s6,s5
    sw t0,20(a1)
    li a5, 0x1b17cae5
    li s3, 0xf91bf443
    orn a4,a5,s3
    sw a4,24(a1)
    li t0, 0x9d11f46b
    li s1, 0x88a17c6f
    orn s3,t0,s1
    sw s3,28(a1)
    li t4, 0xd83d7fff
    li t3, 0x008800e2
    orn a5,t4,t3
    sw a5,32(a1)
    li t0, 0x22000412
    li s11, 0x07fffbdd
    orn t3,t0,s11
    sw t3,36(a1)
    li a3, 0xf7ef0b32
    li s6, 0xebffafa5
    orn t0,a3,s6
    sw t0,40(a1)
    li a3, 0xd3610008
    li s11, 0xd3ddcdef
    orn s3,a3,s11
    sw s3,44(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 12,4,-1
RV_COMPLIANCE_DATA_END
