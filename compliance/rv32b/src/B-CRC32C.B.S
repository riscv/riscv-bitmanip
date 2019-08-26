#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a6, 0xd77b6ecd
    crc32c.b s0,a6
    sw s0,0(a1)
    li s7, 0x36a9a6d7
    crc32c.b s0,s7
    sw s0,4(a1)
    li a7, 0x219954ae
    crc32c.b s5,a7
    sw s5,8(a1)
    li a3, 0x91f3a75b
    crc32c.b s10,a3
    sw s10,12(a1)
    li s5, 0x6723f89c
    crc32c.b s2,s5
    sw s2,16(a1)
    li a7, 0x6042e65d
    crc32c.b s2,a7
    sw s2,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
