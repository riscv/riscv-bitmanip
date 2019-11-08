#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s3, 0xeadf76b9d77b6ecd
    sext.b s11,s3
    sd s11,0(a1)
    li s10, 0x991e56a136a9a6d7
    sext.b t0,s10
    sd t0,8(a1)
    li a6, 0x75be118b219954ae
    sext.b s0,a6
    sd s0,16(a1)
    li s7, 0x201eccb891f3a75b
    sext.b s0,s7
    sd s0,24(a1)
    li a7, 0x5259a8e16723f89c
    sext.b s5,a7
    sd s5,32(a1)
    li a3, 0x80b445926042e65d
    sext.b s10,a3
    sd s10,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
