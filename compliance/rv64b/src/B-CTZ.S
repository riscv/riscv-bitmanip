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
    li t2, 0x991e56a136a9a6d7
    ctz s6,t2
    sd s6,24(a1)
    li s10, 0x75be118b219954ae
    ctz t0,s10
    sd t0,32(a1)
    li s4, 0x201eccb891f3a75b
    ctz s6,s4
    sd s6,40(a1)
    li s4, 0x5259a8e16723f89c
    ctz s9,s4
    sd s9,48(a1)
    li s7, 0x80b445926042e65d
    ctz s0,s7
    sd s0,56(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 8,8,-1
RV_COMPLIANCE_DATA_END
