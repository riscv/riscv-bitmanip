#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s2, 0x778bd1db
    li s5, 0xdef3c035
    sbinv a5,s2,s5
    sw a5,0(a1)
    li t5, 0xffaace79
    li s9, 0x11e15d6b
    sbinv a7,t5,s9
    sw a7,4(a1)
    li s6, 0x04bc5eac
    li s7, 0x33397f4e
    sbinv t3,s6,s7
    sw t3,8(a1)
    li a3, 0x40ee4840
    li a2, 0x18331b85
    sbinv t5,a3,a2
    sw t5,12(a1)
    li a4, 0x5a0d8ae2
    li t6, 0xfaafb8a6
    sbinv s4,a4,t6
    sw s4,16(a1)
    li t0, 0xcccb9502
    li a0, 0xde163e74
    sbinv a4,t0,a0
    sw a4,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
