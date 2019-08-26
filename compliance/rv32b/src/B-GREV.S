#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t6, 0x778bd1db
    li a5, 0xdef3c035
    grev s8,t6,a5
    sw s8,0(a1)
    li s8, 0xffaace79
    li s1, 0x11e15d6b
    grev t4,s8,s1
    sw t4,4(a1)
    li a0, 0x04bc5eac
    li s7, 0x33397f4e
    grev t2,a0,s7
    sw t2,8(a1)
    li a7, 0x40ee4840
    li a5, 0x18331b85
    grev t2,a7,a5
    sw t2,12(a1)
    li s8, 0x5a0d8ae2
    li a2, 0xfaafb8a6
    grev t2,s8,a2
    sw t2,16(a1)
    li s2, 0xcccb9502
    li t6, 0xde163e74
    grev s9,s2,t6
    sw s9,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
