#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s1, 0x778bd1db
    li s4, 0xdef3c035
    andn s3,s1,s4
    sw s3,0(a1)
    li a7, 0xffaace79
    li t4, 0x11e15d6b
    andn t6,a7,t4
    sw t6,4(a1)
    li a0, 0x04bc5eac
    li a3, 0x33397f4e
    andn a4,a0,a3
    sw a4,8(a1)
    li s7, 0x40ee4840
    li t3, 0x18331b85
    andn s6,s7,t3
    sw s6,12(a1)
    li s0, 0x5a0d8ae2
    li t4, 0xfaafb8a6
    andn s7,s0,t4
    sw s7,16(a1)
    li t5, 0xcccb9502
    li s10, 0xde163e74
    andn a0,t5,s10
    sw a0,20(a1)
    li t6, 0x1b17cae5
    li s6, 0xf91bf443
    andn s5,t6,s6
    sw s5,24(a1)
    li t2, 0x9d11f46b
    li t3, 0x88a17c6f
    andn s6,t2,t3
    sw s6,28(a1)
    li t0, 0xd83d7fff
    li s4, 0x008800e2
    andn a4,t0,s4
    sw a4,32(a1)
    li t3, 0x22000412
    li t5, 0x07fffbdd
    andn s2,t3,t5
    sw s2,36(a1)
    li t5, 0xf7ef0b32
    li a5, 0xebffafa5
    andn s11,t5,a5
    sw s11,40(a1)
    li s8, 0xd3610008
    li s5, 0xd3ddcdef
    andn s4,s8,s5
    sw s4,44(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 12,4,-1
RV_COMPLIANCE_DATA_END
