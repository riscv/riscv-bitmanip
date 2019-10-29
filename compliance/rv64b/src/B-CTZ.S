#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a7, 0x0000000000000000
    ctz s11,a7
    sd s11,0(a1)
    li s6, 0xffffffffffffffff
    ctz t5,s6
    sd t5,8(a1)
    li s1, 0xeadf76b9d77b6ecd
    ctz t2,s1
    sd t2,16(a1)
    li s3, 0x991e56a136a9a6d7
    ctz s4,s3
    sd s4,24(a1)
    li s4, 0x75be118b219954ae
    ctz s6,s4
    sd s6,32(a1)
    li s1, 0x201eccb891f3a75b
    ctz t5,s1
    sd t5,40(a1)
    li s11, 0x5259a8e16723f89c
    ctz a3,s11
    sd a3,48(a1)
    li t2, 0x80b445926042e65d
    ctz a6,t2
    sd a6,56(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 8,8,-1
RV_COMPLIANCE_DATA_END
