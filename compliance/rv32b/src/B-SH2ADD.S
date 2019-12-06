#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a3, 0x522a1063
    li a6, 0xd2d6b642
    sh2add s5,a3,a6
    sw s5,0(a1)
    li a7, 0x8a671b8c
    li s4, 0x5b4289cf
    sh2add a0,a7,s4
    sw a0,4(a1)
    li s5, 0x02eb0801
    li s11, 0x81920806
    sh2add t3,s5,s11
    sw t3,8(a1)
    li s3, 0x43737b61
    li s10, 0x57861f11
    sh2add s7,s3,s10
    sw s7,12(a1)
    li s10, 0xf20d8a82
    li t3, 0x1ceb0c11
    sh2add t4,s10,t3
    sw t4,16(a1)
    li a5, 0x9543c51a
    li t2, 0x9a48a02c
    sh2add s4,a5,t2
    sw s4,20(a1)
    sw zero,24(a1)
    sw zero,28(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 8,4,-1
RV_COMPLIANCE_DATA_END
