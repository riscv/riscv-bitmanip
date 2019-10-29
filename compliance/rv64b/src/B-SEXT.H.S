#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s4, 0xeadf76b9d77b6ecd
    sext.h s8,s4
    sd s8,0(a1)
    li s2, 0x991e56a136a9a6d7
    sext.h s3,s2
    sd s3,8(a1)
    li a3, 0x75be118b219954ae
    sext.h a7,a3
    sd a7,16(a1)
    li s3, 0x201eccb891f3a75b
    sext.h t5,s3
    sd t5,24(a1)
    li a5, 0x5259a8e16723f89c
    sext.h s10,a5
    sd s10,32(a1)
    li a7, 0x80b445926042e65d
    sext.h s0,a7
    sd s0,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
