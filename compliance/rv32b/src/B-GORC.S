#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a7, 0x778bd1db
    li t4, 0xdef3c035
    gorc t6,a7,t4
    sw t6,0(a1)
    li t6, 0xffaace79
    li s1, 0x11e15d6b
    gorc s3,t6,s1
    sw s3,4(a1)
    li a6, 0x04bc5eac
    li t2, 0x33397f4e
    gorc t0,a6,t2
    sw t0,8(a1)
    li a4, 0x40ee4840
    li s8, 0x18331b85
    gorc t4,a4,s8
    sw t4,12(a1)
    li t6, 0x5a0d8ae2
    li a7, 0xfaafb8a6
    gorc s2,t6,a7
    sw s2,16(a1)
    li a4, 0xcccb9502
    li s0, 0xde163e74
    gorc s9,a4,s0
    sw s9,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
