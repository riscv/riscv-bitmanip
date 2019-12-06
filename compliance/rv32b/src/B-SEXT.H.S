#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t4, 0xd77b6ecd
    sext.h s0,t4
    sw s0,0(a1)
    li s3, 0x36a9a6d7
    sext.h s11,s3
    sw s11,4(a1)
    li a4, 0x219954ae
    sext.h s5,a4
    sw s5,8(a1)
    li s4, 0x91f3a75b
    sext.h s6,s4
    sw s6,12(a1)
    li s6, 0x6723f89c
    sext.h t1,s6
    sw t1,16(a1)
    li s8, 0x6042e65d
    sext.h a6,s8
    sw a6,20(a1)
    sw zero,24(a1)
    sw zero,28(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 8,4,-1
RV_COMPLIANCE_DATA_END
