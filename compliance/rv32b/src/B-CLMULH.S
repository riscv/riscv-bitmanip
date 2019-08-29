#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s11, 0x522a1063
    li a6, 0xd2d6b642
    clmulh s4,s11,a6
    sw s4,0(a1)
    li s7, 0x8a671b8c
    li s10, 0x5b4289cf
    clmulh s4,s7,s10
    sw s4,4(a1)
    li s1, 0x02eb0801
    li t4, 0x81920806
    clmulh t0,s1,t4
    sw t0,8(a1)
    li a7, 0x43737b61
    li s0, 0x57861f11
    clmulh a6,a7,s0
    sw a6,12(a1)
    li s4, 0xf20d8a82
    li t6, 0x1ceb0c11
    clmulh a0,s4,t6
    sw a0,16(a1)
    li a3, 0x9543c51a
    li s11, 0x9a48a02c
    clmulh s9,a3,s11
    sw s9,20(a1)
    li t1, 0xfa829000
    li t5, 0xc0000040
    clmulh t6,t1,t5
    sw t6,24(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 7,4,-1
RV_COMPLIANCE_DATA_END
