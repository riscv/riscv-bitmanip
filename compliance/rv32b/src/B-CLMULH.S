#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s5, 0x522a1063
    li t5, 0xd2d6b642
    clmulh a2,s5,t5
    sw a2,0(a1)
    li s6, 0x8a671b8c
    li s5, 0x5b4289cf
    clmulh t0,s6,s5
    sw t0,4(a1)
    li s1, 0x02eb0801
    li s4, 0x81920806
    clmulh a0,s1,s4
    sw a0,8(a1)
    li s7, 0x43737b61
    li t4, 0x57861f11
    clmulh a6,s7,t4
    sw a6,12(a1)
    li t6, 0xf20d8a82
    li a4, 0x1ceb0c11
    clmulh t0,t6,a4
    sw t0,16(a1)
    li a6, 0x9543c51a
    li s6, 0x9a48a02c
    clmulh s9,a6,s6
    sw s9,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
