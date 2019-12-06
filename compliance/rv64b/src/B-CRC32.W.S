#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s9, 0xeadf76b9d77b6ecd
    crc32.w s0,s9
    sd s0,0(a1)
    li s8, 0x991e56a136a9a6d7
    crc32.w t2,s8
    sd t2,8(a1)
    li a4, 0x75be118b219954ae
    crc32.w t2,a4
    sd t2,16(a1)
    li s4, 0x201eccb891f3a75b
    crc32.w t6,s4
    sd t6,24(a1)
    li a7, 0x5259a8e16723f89c
    crc32.w a6,a7
    sd a6,32(a1)
    li s10, 0x80b445926042e65d
    crc32.w s5,s10
    sd s5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
