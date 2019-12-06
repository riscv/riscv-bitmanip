#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s3, 0x778bd1db
    li a3, 0xdef3c035
    pack t2,s3,a3
    sw t2,0(a1)
    li s4, 0xffaace79
    li a2, 0x11e15d6b
    pack t6,s4,a2
    sw t6,4(a1)
    li a3, 0x04bc5eac
    li a2, 0x33397f4e
    pack t5,a3,a2
    sw t5,8(a1)
    li t6, 0x40ee4840
    li s5, 0x18331b85
    pack s11,t6,s5
    sw s11,12(a1)
    li t0, 0x5a0d8ae2
    li a3, 0xfaafb8a6
    pack s2,t0,a3
    sw s2,16(a1)
    li a7, 0xcccb9502
    li s7, 0xde163e74
    pack s11,a7,s7
    sw s11,20(a1)
    sw zero,24(a1)
    sw zero,28(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 8,4,-1
RV_COMPLIANCE_DATA_END
