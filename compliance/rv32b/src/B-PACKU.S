#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a3, 0x778bd1db
    li a5, 0xdef3c035
    packu a2,a3,a5
    sw a2,0(a1)
    li t0, 0xffaace79
    li a6, 0x11e15d6b
    packu s11,t0,a6
    sw s11,4(a1)
    li a7, 0x04bc5eac
    li a5, 0x33397f4e
    packu t2,a7,a5
    sw t2,8(a1)
    li a5, 0x40ee4840
    li a4, 0x18331b85
    packu t4,a5,a4
    sw t4,12(a1)
    li a4, 0x5a0d8ae2
    li s9, 0xfaafb8a6
    packu t0,a4,s9
    sw t0,16(a1)
    li s0, 0xcccb9502
    li a6, 0xde163e74
    packu a4,s0,a6
    sw a4,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
