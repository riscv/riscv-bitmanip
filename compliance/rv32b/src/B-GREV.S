#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s3, 0x778bd1db
    li a4, 0xdef3c035
    grev t4,s3,a4
    sw t4,0(a1)
    li s10, 0xffaace79
    li a2, 0x11e15d6b
    grev s4,s10,a2
    sw s4,4(a1)
    li t1, 0x04bc5eac
    li s6, 0x33397f4e
    grev s7,t1,s6
    sw s7,8(a1)
    li a5, 0x40ee4840
    li s6, 0x18331b85
    grev a3,a5,s6
    sw a3,12(a1)
    li s11, 0x5a0d8ae2
    li t0, 0xfaafb8a6
    grev a7,s11,t0
    sw a7,16(a1)
    li t0, 0xcccb9502
    li s3, 0xde163e74
    grev s0,t0,s3
    sw s0,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
