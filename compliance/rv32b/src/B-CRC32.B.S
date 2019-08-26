#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t0, 0xd77b6ecd
    crc32.b t3,t0
    sw t3,0(a1)
    li s6, 0x36a9a6d7
    crc32.b t1,s6
    sw t1,4(a1)
    li s10, 0x219954ae
    crc32.b a4,s10
    sw a4,8(a1)
    li a0, 0x91f3a75b
    crc32.b t3,a0
    sw t3,12(a1)
    li a7, 0x6723f89c
    crc32.b t0,a7
    sw t0,16(a1)
    li a2, 0x6042e65d
    crc32.b s3,a2
    sw s3,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
