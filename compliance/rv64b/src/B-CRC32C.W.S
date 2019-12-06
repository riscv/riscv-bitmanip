#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t6, 0xeadf76b9d77b6ecd
    crc32c.w s8,t6
    sd s8,0(a1)
    li t1, 0x991e56a136a9a6d7
    crc32c.w a0,t1
    sd a0,8(a1)
    li t6, 0x75be118b219954ae
    crc32c.w s3,t6
    sd s3,16(a1)
    li s6, 0x201eccb891f3a75b
    crc32c.w t3,s6
    sd t3,24(a1)
    li t1, 0x5259a8e16723f89c
    crc32c.w s7,t1
    sd s7,32(a1)
    li s0, 0x80b445926042e65d
    crc32c.w s7,s0
    sd s7,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
