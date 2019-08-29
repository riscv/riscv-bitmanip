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
    li s3, 0xffaace79
    li a3, 0x11e15d6b
    andn t2,s3,a3
    sw t2,4(a1)
    li s6, 0x04bc5eac
    li a5, 0x33397f4e
    andn a6,s6,a5
    sw a6,8(a1)
    li s10, 0x40ee4840
    li t6, 0x18331b85
    andn s3,s10,t6
    sw s3,12(a1)
    li t0, 0x5a0d8ae2
    li a2, 0xfaafb8a6
    andn s8,t0,a2
    sw s8,16(a1)
    li t0, 0xcccb9502
    li a0, 0xde163e74
    andn a4,t0,a0
    sw a4,20(a1)
    li t4, 0x1b17cae5
    li s7, 0xf91bf443
    andn a0,t4,s7
    sw a0,24(a1)
    li a6, 0x9d11f46b
    li s4, 0x88a17c6f
    andn t1,a6,s4
    sw t1,28(a1)
    li a5, 0xd83d7fff
    li s11, 0x008800e2
    andn a0,a5,s11
    sw a0,32(a1)
    li a7, 0x22000412
    li a4, 0x07fffbdd
    andn t5,a7,a4
    sw t5,36(a1)
    li t2, 0xf7ef0b32
    li t6, 0xebffafa5
    andn s1,t2,t6
    sw s1,40(a1)
    li t2, 0xd3610008
    li a0, 0xd3ddcdef
    andn s10,t2,a0
    sw s10,44(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 12,4,-1
RV_COMPLIANCE_DATA_END
