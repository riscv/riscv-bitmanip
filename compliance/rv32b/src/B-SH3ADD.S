#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t3, 0x522a1063
    li s10, 0xd2d6b642
    sh3add a3,t3,s10
    sw a3,0(a1)
    li a7, 0x8a671b8c
    li s11, 0x5b4289cf
    sh3add t6,a7,s11
    sw t6,4(a1)
    li s9, 0x02eb0801
    li t4, 0x81920806
    sh3add a6,s9,t4
    sw a6,8(a1)
    li s9, 0x43737b61
    li a6, 0x57861f11
    sh3add t5,s9,a6
    sw t5,12(a1)
    li t3, 0xf20d8a82
    li t5, 0x1ceb0c11
    sh3add s2,t3,t5
    sw s2,16(a1)
    li t5, 0x9543c51a
    li a5, 0x9a48a02c
    sh3add a2,t5,a5
    sw a2,20(a1)
    sw zero,24(a1)
    sw zero,28(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 8,4,-1
RV_COMPLIANCE_DATA_END
