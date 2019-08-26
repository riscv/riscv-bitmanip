#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a5, 0x778bd1db
    li t5, 0xdef3c035
    sbext s11,a5,t5
    sw s11,0(a1)
    li a4, 0xffaace79
    li a5, 0x11e15d6b
    sbext t2,a4,a5
    sw t2,4(a1)
    li s5, 0x04bc5eac
    li s0, 0x33397f4e
    sbext s1,s5,s0
    sw s1,8(a1)
    li a5, 0x40ee4840
    li a7, 0x18331b85
    sbext t5,a5,a7
    sw t5,12(a1)
    li a7, 0x5a0d8ae2
    li a4, 0xfaafb8a6
    sbext a5,a7,a4
    sw a5,16(a1)
    li a0, 0xcccb9502
    li a5, 0xde163e74
    sbext a7,a0,a5
    sw a7,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
