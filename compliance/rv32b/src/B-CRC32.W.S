#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t0, 0xd77b6ecd
    crc32.w s6,t0
    sw s6,0(a1)
    li t5, 0x36a9a6d7
    crc32.w t6,t5
    sw t6,4(a1)
    li a6, 0x219954ae
    crc32.w t5,a6
    sw t5,8(a1)
    li s4, 0x91f3a75b
    crc32.w s3,s4
    sw s3,12(a1)
    li a6, 0x6723f89c
    crc32.w t4,a6
    sw t4,16(a1)
    li s3, 0x6042e65d
    crc32.w s10,s3
    sw s10,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
