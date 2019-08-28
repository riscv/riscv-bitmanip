#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a4, 0x522a1063
    li s0, 0xd2d6b642
    clmulr s9,a4,s0
    sw s9,0(a1)
    li s11, 0x8a671b8c
    li a6, 0x5b4289cf
    clmulr s4,s11,a6
    sw s4,4(a1)
    li s7, 0x02eb0801
    li s10, 0x81920806
    clmulr s4,s7,s10
    sw s4,8(a1)
    li s1, 0x43737b61
    li t4, 0x57861f11
    clmulr t0,s1,t4
    sw t0,12(a1)
    li a7, 0xf20d8a82
    li s0, 0x1ceb0c11
    clmulr a6,a7,s0
    sw a6,16(a1)
    li s4, 0x9543c51a
    li t6, 0x9a48a02c
    clmulr a0,s4,t6
    sw a0,20(a1)
    li a3, 0xfa829000
    li t3, 0xc0000040
    clmulr s11,a3,t3
    sw s11,24(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 7,4,-1
RV_COMPLIANCE_DATA_END
