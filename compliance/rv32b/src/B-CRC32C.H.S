#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a3, 0xd77b6ecd
    crc32c.h a7,a3
    sw a7,0(a1)
    li s3, 0x36a9a6d7
    crc32c.h t5,s3
    sw t5,4(a1)
    li a5, 0x219954ae
    crc32c.h s10,a5
    sw s10,8(a1)
    li a7, 0x91f3a75b
    crc32c.h s0,a7
    sw s0,12(a1)
    li t0, 0x6723f89c
    crc32c.h a0,t0
    sw a0,16(a1)
    li a7, 0x6042e65d
    crc32c.h a6,a7
    sw a6,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
