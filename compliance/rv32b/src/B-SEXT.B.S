#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s11, 0xd77b6ecd
    sext.b a4,s11
    sw a4,0(a1)
    li s10, 0x36a9a6d7
    sext.b t3,s10
    sw t3,4(a1)
    li s3, 0x219954ae
    sext.b s4,s3
    sw s4,8(a1)
    li t0, 0x91f3a75b
    sext.b t3,t0
    sw t3,12(a1)
    li s4, 0x6723f89c
    sext.b s9,s4
    sw s9,16(a1)
    li s3, 0x6042e65d
    sext.b t5,s3
    sw t5,20(a1)
    sw zero,24(a1)
    sw zero,28(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 8,4,-1
RV_COMPLIANCE_DATA_END
