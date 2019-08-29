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
    li s8, 0xffaace79
    li t5, 0x11e15d6b
    orn t2,s8,t5
    sw t2,4(a1)
    li a5, 0x04bc5eac
    li s0, 0x33397f4e
    orn t3,a5,s0
    sw t3,8(a1)
    li t2, 0x40ee4840
    li s1, 0x18331b85
    orn t1,t2,s1
    sw t1,12(a1)
    li a7, 0x5a0d8ae2
    li a0, 0xfaafb8a6
    orn s7,a7,a0
    sw s7,16(a1)
    li a0, 0xcccb9502
    li a5, 0xde163e74
    orn a7,a0,a5
    sw a7,20(a1)
    li t0, 0x1b17cae5
    li s8, 0xf91bf443
    orn a5,t0,s8
    sw a5,24(a1)
    li s11, 0x9d11f46b
    li s10, 0x88a17c6f
    orn a3,s11,s10
    sw a3,28(a1)
    li a7, 0xd83d7fff
    li a2, 0x008800e2
    orn t4,a7,a2
    sw t4,32(a1)
    li s2, 0x22000412
    li a7, 0x07fffbdd
    orn s8,s2,a7
    sw s8,36(a1)
    li s2, 0xf7ef0b32
    li t4, 0xebffafa5
    orn a2,s2,t4
    sw a2,40(a1)
    li a0, 0xd3610008
    li t1, 0xd3ddcdef
    orn a6,a0,t1
    sw a6,44(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 12,4,-1
RV_COMPLIANCE_DATA_END
