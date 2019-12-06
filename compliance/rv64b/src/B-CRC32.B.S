#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t4, 0xeadf76b9d77b6ecd
    crc32.b s3,t4
    sd s3,0(a1)
    li s3, 0x991e56a136a9a6d7
    crc32.b t4,s3
    sd t4,8(a1)
    li s5, 0x75be118b219954ae
    crc32.b t3,s5
    sd t3,16(a1)
    li s6, 0x201eccb891f3a75b
    crc32.b a6,s6
    sd a6,24(a1)
    li a0, 0x5259a8e16723f89c
    crc32.b t2,a0
    sd t2,32(a1)
    li t2, 0x80b445926042e65d
    crc32.b t1,t2
    sd t1,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
