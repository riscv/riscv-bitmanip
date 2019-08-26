#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a6, 0x00000000
    pcnt t1,a6
    sw t1,0(a1)
    li a3, 0xffffffff
    pcnt s8,a3
    sw s8,4(a1)
    li s4, 0xd77b6ecd
    pcnt t3,s4
    sw t3,8(a1)
    li s7, 0x36a9a6d7
    pcnt s8,s7
    sw s8,12(a1)
    li s10, 0x219954ae
    pcnt t3,s10
    sw t3,16(a1)
    li t2, 0x91f3a75b
    pcnt s6,t2
    sw s6,20(a1)
    li a4, 0x6723f89c
    pcnt s5,a4
    sw s5,24(a1)
    li s0, 0x6042e65d
    pcnt t2,s0
    sw t2,28(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 8,4,-1
RV_COMPLIANCE_DATA_END
