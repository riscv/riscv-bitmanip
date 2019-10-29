#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s2, 0x0000000000000000
    clz s7,s2
    sd s7,0(a1)
    li s3, 0xffffffffffffffff
    clz s0,s3
    sd s0,8(a1)
    li s3, 0xeadf76b9d77b6ecd
    clz t3,s3
    sd t3,16(a1)
    li s4, 0x991e56a136a9a6d7
    clz s10,s4
    sd s10,24(a1)
    li t0, 0x75be118b219954ae
    clz t3,t0
    sd t3,32(a1)
    li s6, 0x201eccb891f3a75b
    clz t1,s6
    sd t1,40(a1)
    li s10, 0x5259a8e16723f89c
    clz a4,s10
    sd a4,48(a1)
    li a0, 0x80b445926042e65d
    clz t3,a0
    sd t3,56(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 8,8,-1
RV_COMPLIANCE_DATA_END
