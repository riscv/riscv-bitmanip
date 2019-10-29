#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s4, 0x0000000000000000
    ctzw t6,s4
    sd t6,0(a1)
    li t4, 0xffffffffffffffff
    ctzw s0,t4
    sd s0,8(a1)
    li s5, 0xeadf76b9d77b6ecd
    ctzw t5,s5
    sd t5,16(a1)
    li t0, 0x991e56a136a9a6d7
    ctzw a0,t0
    sd a0,24(a1)
    li s4, 0x75be118b219954ae
    ctzw a2,s4
    sd a2,32(a1)
    li a7, 0x201eccb891f3a75b
    ctzw a6,a7
    sd a6,40(a1)
    li s5, 0x5259a8e16723f89c
    ctzw s7,s5
    sd s7,48(a1)
    li t4, 0x80b445926042e65d
    ctzw s6,t4
    sd s6,56(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 8,8,-1
RV_COMPLIANCE_DATA_END
