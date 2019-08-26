#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s4, 0xeadf76b9d77b6ecd
    crc32c.w a5,s4
    sd a5,0(a1)
    li a3, 0x991e56a136a9a6d7
    crc32c.w a6,a3
    sd a6,8(a1)
    li a5, 0x75be118b219954ae
    crc32c.w s11,a5
    sd s11,16(a1)
    li a3, 0x201eccb891f3a75b
    crc32c.w a2,a3
    sd a2,24(a1)
    li t5, 0x5259a8e16723f89c
    crc32c.w a7,t5
    sd a7,32(a1)
    li s10, 0x80b445926042e65d
    crc32c.w s4,s10
    sd s4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
