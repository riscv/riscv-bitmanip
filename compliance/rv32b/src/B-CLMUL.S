#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s6, 0x522a1063
    li s5, 0xd2d6b642
    clmul t0,s6,s5
    sw t0,0(a1)
    li s1, 0x8a671b8c
    li s4, 0x5b4289cf
    clmul a0,s1,s4
    sw a0,4(a1)
    li s7, 0x02eb0801
    li t4, 0x81920806
    clmul a6,s7,t4
    sw a6,8(a1)
    li t6, 0x43737b61
    li a4, 0x57861f11
    clmul t0,t6,a4
    sw t0,12(a1)
    li a6, 0xf20d8a82
    li s6, 0x1ceb0c11
    clmul s9,a6,s6
    sw s9,16(a1)
    li a0, 0x9543c51a
    li s9, 0x9a48a02c
    clmul s8,a0,s9
    sw s8,20(a1)
    li s0, 0xfa829000
    li t2, 0xc0000040
    clmul s6,s0,t2
    sw s6,24(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 7,4,-1
RV_COMPLIANCE_DATA_END
