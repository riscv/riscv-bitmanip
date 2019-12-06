#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s8, 0x522a1063
    li s1, 0xd2d6b642
    clmul s5,s8,s1
    sw s5,0(a1)
    li s10, 0x8a671b8c
    li a2, 0x5b4289cf
    clmul a0,s10,a2
    sw a0,4(a1)
    li s8, 0x02eb0801
    li a2, 0x81920806
    clmul a3,s8,a2
    sw a3,8(a1)
    li s2, 0x43737b61
    li s0, 0x57861f11
    clmul t0,s2,s0
    sw t0,12(a1)
    li a7, 0xf20d8a82
    li s4, 0x1ceb0c11
    clmul a4,a7,s4
    sw a4,16(a1)
    li t5, 0x9543c51a
    li s5, 0x9a48a02c
    clmul t2,t5,s5
    sw t2,20(a1)
    li s4, 0xfa829000
    li t0, 0xc0000040
    clmul a7,s4,t0
    sw a7,24(a1)
    sw zero,28(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 8,4,-1
RV_COMPLIANCE_DATA_END
