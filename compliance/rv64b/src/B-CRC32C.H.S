#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a7, 0xeadf76b9d77b6ecd
    crc32c.h a6,a7
    sd a6,0(a1)
    li t4, 0x991e56a136a9a6d7
    crc32c.h s6,t4
    sd s6,8(a1)
    li s2, 0x75be118b219954ae
    crc32c.h a5,s2
    sd a5,16(a1)
    li s8, 0x201eccb891f3a75b
    crc32c.h t2,s8
    sd t2,24(a1)
    li s5, 0x5259a8e16723f89c
    crc32c.h t3,s5
    sd t3,32(a1)
    li t6, 0x80b445926042e65d
    crc32c.h s3,t6
    sd s3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
