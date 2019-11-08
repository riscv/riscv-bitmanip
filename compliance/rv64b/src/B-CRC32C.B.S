#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s4, 0xeadf76b9d77b6ecd
    crc32c.b t4,s4
    sd t4,0(a1)
    li s3, 0x991e56a136a9a6d7
    crc32c.b t2,s3
    sd t2,8(a1)
    li a7, 0x75be118b219954ae
    crc32c.b t3,a7
    sd t3,16(a1)
    li t2, 0x201eccb891f3a75b
    crc32c.b t0,t2
    sd t0,24(a1)
    li t5, 0x5259a8e16723f89c
    crc32c.b s1,t5
    sd s1,32(a1)
    li s7, 0x80b445926042e65d
    crc32c.b s6,s7
    sd s6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
