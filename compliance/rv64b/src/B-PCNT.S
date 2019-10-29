#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a6, 0x0000000000000000
    pcnt t1,a6
    sd t1,0(a1)
    li a3, 0xffffffffffffffff
    pcnt s8,a3
    sd s8,8(a1)
    li s10, 0xeadf76b9d77b6ecd
    pcnt t3,s10
    sd t3,16(a1)
    li a4, 0x991e56a136a9a6d7
    pcnt s5,a4
    sd s5,24(a1)
    li t0, 0x75be118b219954ae
    pcnt s6,t0
    sd s6,32(a1)
    li t5, 0x201eccb891f3a75b
    pcnt t6,t5
    sd t6,40(a1)
    li a6, 0x5259a8e16723f89c
    pcnt t5,a6
    sd t5,48(a1)
    li s4, 0x80b445926042e65d
    pcnt s3,s4
    sd s3,56(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 8,8,-1
RV_COMPLIANCE_DATA_END
