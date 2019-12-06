#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s4, 0x522a1063
    li s5, 0xd2d6b642
    shfl s11,s4,s5
    sw s11,0(a1)
    li s2, 0x8a671b8c
    li a0, 0x5b4289cf
    shfl s7,s2,a0
    sw s7,4(a1)
    li t2, 0x02eb0801
    li s6, 0x81920806
    shfl s0,t2,s6
    sw s0,8(a1)
    li t0, 0x43737b61
    li s7, 0x57861f11
    shfl s1,t0,s7
    sw s1,12(a1)
    li s1, 0xf20d8a82
    li a0, 0x1ceb0c11
    shfl t2,s1,a0
    sw t2,16(a1)
    li a6, 0x9543c51a
    li t5, 0x9a48a02c
    shfl s10,a6,t5
    sw s10,20(a1)
    li s10, 0x00d321db
    li s5, 0x4ae7185c
    shfl a7,s10,s5
    sw a7,24(a1)
    li s7, 0x0f3ff336
    li t6, 0x4b10a48e
    shfl s9,s7,t6
    sw s9,28(a1)
    li s11, 0xf807f882
    li a5, 0xa200000e
    shfl s4,s11,a5
    sw s4,32(a1)
    sw zero,36(a1)
    sw zero,40(a1)
    sw zero,44(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 12,4,-1
RV_COMPLIANCE_DATA_END
