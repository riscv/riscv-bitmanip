#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t2, 0xeadf76b9d77b6ecd
    bmatflip s6,t2
    sd s6,0(a1)
    li s0, 0x991e56a136a9a6d7
    bmatflip t2,s0
    sd t2,8(a1)
    li s4, 0x75be118b219954ae
    bmatflip s9,s4
    sd s9,16(a1)
    li s8, 0x201eccb891f3a75b
    bmatflip a6,s8
    sd a6,24(a1)
    li s8, 0x5259a8e16723f89c
    bmatflip s4,s8
    sd s4,32(a1)
    li a7, 0x80b445926042e65d
    bmatflip t2,a7
    sd t2,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
