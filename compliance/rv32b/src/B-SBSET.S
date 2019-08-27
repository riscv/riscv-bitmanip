#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s9, 0x778bd1db
    li t2, 0xdef3c035
    sbset s0,s9,t2
    sw s0,0(a1)
    li a7, 0xffaace79
    li s8, 0x11e15d6b
    sbset t3,a7,s8
    sw t3,4(a1)
    li t0, 0x04bc5eac
    li a6, 0x33397f4e
    sbset s11,t0,a6
    sw s11,8(a1)
    li s1, 0x40ee4840
    li t4, 0x18331b85
    sbset t3,s1,t4
    sw t3,12(a1)
    li t0, 0x5a0d8ae2
    li a2, 0xfaafb8a6
    sbset s8,t0,a2
    sw s8,16(a1)
    li t6, 0xcccb9502
    li a7, 0xde163e74
    sbset s2,t6,a7
    sw s2,20(a1)
    li s10, 0xf044ff7a
    li a2, 0xb6c01b9a
    sbset s7,s10,a2
    sw s7,24(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 7,4,-1
RV_COMPLIANCE_DATA_END
