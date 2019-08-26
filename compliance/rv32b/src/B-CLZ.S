#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s2, 0x00000000
    clz s7,s2
    sw s7,0(a1)
    li s3, 0xffffffff
    clz s0,s3
    sw s0,4(a1)
    li t6, 0xd77b6ecd
    clz s5,t6
    sw s5,8(a1)
    li s11, 0x36a9a6d7
    clz a4,s11
    sw a4,12(a1)
    li s3, 0x219954ae
    clz t3,s3
    sw t3,16(a1)
    li s3, 0x91f3a75b
    clz s11,s3
    sw s11,20(a1)
    li s4, 0x6723f89c
    clz s10,s4
    sw s10,24(a1)
    li s10, 0x6042e65d
    clz t0,s10
    sw t0,28(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 8,4,-1
RV_COMPLIANCE_DATA_END
