#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s4, 0xd77b6ecd
    crc32c.w s9,s4
    sw s9,0(a1)
    li s8, 0x36a9a6d7
    crc32c.w a6,s8
    sw a6,4(a1)
    li s8, 0x219954ae
    crc32c.w s4,s8
    sw s4,8(a1)
    li a7, 0x91f3a75b
    crc32c.w t2,a7
    sw t2,12(a1)
    li t0, 0x6723f89c
    crc32c.w s0,t0
    sw s0,16(a1)
    li s4, 0x6042e65d
    crc32c.w a5,s4
    sw a5,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
