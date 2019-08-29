#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a7, 0x522a1063
    li s7, 0xd2d6b642
    clmulr s11,a7,s7
    sw s11,0(a1)
    li s1, 0x8a671b8c
    li t1, 0x5b4289cf
    clmulr s6,s1,t1
    sw s6,4(a1)
    li s8, 0x02eb0801
    li s1, 0x81920806
    clmulr s5,s8,s1
    sw s5,8(a1)
    li s10, 0x43737b61
    li a2, 0x57861f11
    clmulr a0,s10,a2
    sw a0,12(a1)
    li s8, 0xf20d8a82
    li a2, 0x1ceb0c11
    clmulr a3,s8,a2
    sw a3,16(a1)
    li s2, 0x9543c51a
    li s0, 0x9a48a02c
    clmulr t0,s2,s0
    sw t0,20(a1)
    li s1, 0xfa829000
    li s8, 0xc0000040
    clmulr s2,s1,s8
    sw s2,24(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 7,4,-1
RV_COMPLIANCE_DATA_END
