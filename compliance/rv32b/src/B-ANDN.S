#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t6, 0x778bd1db
    li a5, 0xdef3c035
    andn s8,t6,a5
    sw s8,0(a1)
    li s10, 0xffaace79
    li a2, 0x11e15d6b
    andn s4,s10,a2
    sw s4,4(a1)
    li t2, 0x04bc5eac
    li s1, 0x33397f4e
    andn t1,t2,s1
    sw t1,8(a1)
    li a7, 0x40ee4840
    li a4, 0x18331b85
    andn a5,a7,a4
    sw a5,12(a1)
    li a0, 0x5a0d8ae2
    li t2, 0xfaafb8a6
    andn s5,a0,t2
    sw s5,16(a1)
    li s1, 0xcccb9502
    li t2, 0xde163e74
    andn s0,s1,t2
    sw s0,20(a1)
    li a0, 0x1b17cae5
    li s11, 0xf91bf443
    andn s9,a0,s11
    sw s9,24(a1)
    li a7, 0x9d11f46b
    li s10, 0x88a17c6f
    andn t5,a7,s10
    sw t5,28(a1)
    li t5, 0xd83d7fff
    li s3, 0x008800e2
    andn a0,t5,s3
    sw a0,32(a1)
    li a6, 0x22000412
    li s11, 0x07fffbdd
    andn s6,a6,s11
    sw s6,36(a1)
    li s11, 0xf7ef0b32
    li s2, 0xebffafa5
    andn s5,s11,s2
    sw s5,40(a1)
    li a3, 0xd3610008
    li a7, 0xd3ddcdef
    andn s10,a3,a7
    sw s10,44(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 12,4,-1
RV_COMPLIANCE_DATA_END
