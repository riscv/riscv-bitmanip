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
    li a6, 0x1b17cae5
    li t3, 0xf91bf443
    orn a3,a6,t3
    sw a3,24(a1)
    li s6, 0x9d11f46b
    li s3, 0x88a17c6f
    orn t3,s6,s3
    sw t3,28(a1)
    li s0, 0xd83d7fff
    li s6, 0x008800e2
    orn t1,s0,s6
    sw t1,32(a1)
    li a6, 0x22000412
    li t2, 0x07fffbdd
    orn a7,a6,t2
    sw a7,36(a1)
    li t2, 0xf7ef0b32
    li s9, 0xebffafa5
    orn s11,t2,s9
    sw s11,40(a1)
    li s0, 0xd3610008
    li t2, 0xd3ddcdef
    orn s6,s0,t2
    sw s6,44(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 12,4,-1
RV_COMPLIANCE_DATA_END
