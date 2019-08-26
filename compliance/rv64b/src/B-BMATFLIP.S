#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s3, 0xeadf76b9d77b6ecd
    bmatflip s11,s3
    sd s11,0(a1)
    li s3, 0x991e56a136a9a6d7
    bmatflip s4,s3
    sd s4,8(a1)
    li s0, 0x75be118b219954ae
    bmatflip t2,s0
    sd t2,16(a1)
    li a6, 0x201eccb891f3a75b
    bmatflip s0,a6
    sd s0,24(a1)
    li s1, 0x5259a8e16723f89c
    bmatflip t5,s1
    sd t5,32(a1)
    li s8, 0x80b445926042e65d
    bmatflip a6,s8
    sd a6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
