#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t2, 0x522a1063
    li s1, 0xd2d6b642
    clmulr s2,t2,s1
    sw s2,0(a1)
    li a2, 0x8a671b8c
    li s5, 0x5b4289cf
    clmulr s6,a2,s5
    sw s6,4(a1)
    li s5, 0x02eb0801
    li s6, 0x81920806
    clmulr s1,s5,s6
    sw s1,8(a1)
    li s2, 0x43737b61
    li s7, 0x57861f11
    clmulr s11,s2,s7
    sw s11,12(a1)
    li a2, 0xf20d8a82
    li s10, 0x1ceb0c11
    clmulr s2,a2,s10
    sw s2,16(a1)
    li a5, 0x9543c51a
    li s7, 0x9a48a02c
    clmulr s11,a5,s7
    sw s11,20(a1)
    li t3, 0xfa829000
    li t5, 0xc0000040
    clmulr a0,t3,t5
    sw a0,24(a1)
    sw zero,28(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 8,4,-1
RV_COMPLIANCE_DATA_END
