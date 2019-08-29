#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s3, 0x778bd1db
    li t6, 0xdef3c035
    pack s1,s3,t6
    sw s1,0(a1)
    li a4, 0xffaace79
    li t2, 0x11e15d6b
    pack a3,a4,t2
    sw a3,4(a1)
    li t5, 0x04bc5eac
    li t6, 0x33397f4e
    pack s1,t5,t6
    sw s1,8(a1)
    li s10, 0x40ee4840
    li s11, 0x18331b85
    pack s5,s10,s11
    sw s5,12(a1)
    li a7, 0x5a0d8ae2
    li a4, 0xfaafb8a6
    pack a5,a7,a4
    sw a5,16(a1)
    li t5, 0xcccb9502
    li s3, 0xde163e74
    pack a2,t5,s3
    sw a2,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
