#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s4, 0x778bd1db
    li s2, 0xdef3c035
    sbclr t4,s4,s2
    sw t4,0(a1)
    li s5, 0xffaace79
    li s8, 0x11e15d6b
    sbclr t3,s5,s8
    sw t3,4(a1)
    li s6, 0x04bc5eac
    li t0, 0x33397f4e
    sbclr t6,s6,t0
    sw t6,8(a1)
    li s10, 0x40ee4840
    li s11, 0x18331b85
    sbclr s5,s10,s11
    sw s5,12(a1)
    li a7, 0x5a0d8ae2
    li a0, 0xfaafb8a6
    sbclr s7,a7,a0
    sw s7,16(a1)
    li s11, 0xcccb9502
    li t0, 0xde163e74
    sbclr a7,s11,t0
    sw a7,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
