#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s8, 0x778bd1db
    li t5, 0xdef3c035
    packh t2,s8,t5
    sw t2,0(a1)
    li t5, 0xffaace79
    li t6, 0x11e15d6b
    packh s1,t5,t6
    sw s1,4(a1)
    li a5, 0x04bc5eac
    li a7, 0x33397f4e
    packh t5,a5,a7
    sw t5,8(a1)
    li a6, 0x40ee4840
    li t6, 0x18331b85
    packh t3,a6,t6
    sw t3,12(a1)
    li t6, 0x5a0d8ae2
    li s4, 0xfaafb8a6
    packh a2,t6,s4
    sw a2,16(a1)
    li t2, 0xcccb9502
    li t5, 0xde163e74
    packh s3,t2,t5
    sw s3,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
