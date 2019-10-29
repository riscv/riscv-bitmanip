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
    li s7, 0x1b17cae5
    li s4, 0xf91bf443
    andn s2,s7,s4
    sw s2,24(a1)
    li a0, 0x9d11f46b
    li t4, 0x88a17c6f
    andn t5,a0,t4
    sw t5,28(a1)
    li s5, 0xd83d7fff
    li s1, 0x008800e2
    andn s9,s5,s1
    sw s9,32(a1)
    li s2, 0x22000412
    li s6, 0x07fffbdd
    andn a0,s2,s6
    sw a0,36(a1)
    li t5, 0xf7ef0b32
    li t3, 0xebffafa5
    andn t2,t5,t3
    sw t2,40(a1)
    li s3, 0xd3610008
    li t1, 0xd3ddcdef
    andn s7,s3,t1
    sw s7,44(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 12,4,-1
RV_COMPLIANCE_DATA_END
