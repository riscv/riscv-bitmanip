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
    li s8, 0xffaace79
    li t5, 0x11e15d6b
    pack t2,s8,t5
    sw t2,4(a1)
    li s10, 0x04bc5eac
    li a2, 0x33397f4e
    pack s4,s10,a2
    sw s4,8(a1)
    li a2, 0x40ee4840
    li a6, 0x18331b85
    pack s5,a2,a6
    sw s5,12(a1)
    li a5, 0x5a0d8ae2
    li a6, 0xfaafb8a6
    pack a4,a5,a6
    sw a4,16(a1)
    li a5, 0xcccb9502
    li a4, 0xde163e74
    pack t4,a5,a4
    sw t4,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
