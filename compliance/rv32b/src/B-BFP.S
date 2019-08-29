#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t4, 0x778bd1db
    li s10, 0xdef3c035
    bfp s6,t4,s10
    sw s6,0(a1)
    li s6, 0xffaace79
    li a0, 0x11e15d6b
    bfp s5,s6,a0
    sw s5,4(a1)
    li t0, 0x04bc5eac
    li a6, 0x33397f4e
    bfp s11,t0,a6
    sw s11,8(a1)
    li a3, 0x40ee4840
    li a2, 0x18331b85
    bfp t5,a3,a2
    sw t5,12(a1)
    li s8, 0x5a0d8ae2
    li a2, 0xfaafb8a6
    bfp t2,s8,a2
    sw t2,16(a1)
    li s0, 0xcccb9502
    li a5, 0xde163e74
    bfp s11,s0,a5
    sw s11,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
