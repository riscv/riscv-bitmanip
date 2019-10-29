#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s4, 0x0000000000000000
    pcntw t3,s4
    sd t3,0(a1)
    li s7, 0xffffffffffffffff
    pcntw s8,s7
    sd s8,8(a1)
    li a6, 0xeadf76b9d77b6ecd
    pcntw t4,a6
    sd t4,16(a1)
    li t0, 0x991e56a136a9a6d7
    pcntw s0,t0
    sd s0,24(a1)
    li s3, 0x75be118b219954ae
    pcntw s10,s3
    sd s10,32(a1)
    li s4, 0x201eccb891f3a75b
    pcntw a5,s4
    sd a5,40(a1)
    li s2, 0x5259a8e16723f89c
    pcntw t4,s2
    sd t4,48(a1)
    li a3, 0x80b445926042e65d
    pcntw a6,a3
    sd a6,56(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 8,8,-1
RV_COMPLIANCE_DATA_END
