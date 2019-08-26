#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t5, 0x778bd1db
    li a3, 0xdef3c035
    maxu t1,t5,a3
    sw t1,0(a1)
    li t1, 0xffaace79
    li t0, 0x11e15d6b
    maxu a0,t1,t0
    sw a0,4(a1)
    li t5, 0x04bc5eac
    li t6, 0x33397f4e
    maxu s1,t5,t6
    sw s1,8(a1)
    li t2, 0x40ee4840
    li s1, 0x18331b85
    maxu t1,t2,s1
    sw t1,12(a1)
    li a5, 0x5a0d8ae2
    li s6, 0xfaafb8a6
    maxu a3,a5,s6
    sw a3,16(a1)
    li a2, 0xcccb9502
    li s9, 0xde163e74
    maxu s8,a2,s9
    sw s8,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
