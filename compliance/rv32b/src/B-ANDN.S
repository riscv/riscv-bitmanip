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
    li t0, 0x1b17cae5
    li t4, 0xf91bf443
    andn t1,t0,t4
    sw t1,24(a1)
    li t5, 0x9d11f46b
    li s7, 0x88a17c6f
    andn t0,t5,s7
    sw t0,28(a1)
    li a3, 0xd83d7fff
    li t6, 0x008800e2
    andn t4,a3,t6
    sw t4,32(a1)
    li s0, 0x22000412
    li s2, 0x07fffbdd
    andn s4,s0,s2
    sw s4,36(a1)
    li s11, 0xf7ef0b32
    li a4, 0xebffafa5
    andn s1,s11,a4
    sw s1,40(a1)
    li t2, 0xd3610008
    li a5, 0xd3ddcdef
    andn s4,t2,a5
    sw s4,44(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 12,4,-1
RV_COMPLIANCE_DATA_END
