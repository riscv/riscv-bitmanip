#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a7, 0xeadf76b9d77b6ecd
    crc32c.d t6,a7
    sd t6,0(a1)
    li a7, 0x991e56a136a9a6d7
    crc32c.d t3,a7
    sd t3,8(a1)
    li s10, 0x75be118b219954ae
    crc32c.d s4,s10
    sd s4,16(a1)
    li s5, 0x201eccb891f3a75b
    crc32c.d s1,s5
    sd s1,24(a1)
    li s10, 0x5259a8e16723f89c
    crc32c.d s3,s10
    sd s3,32(a1)
    li s9, 0x80b445926042e65d
    crc32c.d a6,s9
    sd a6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
