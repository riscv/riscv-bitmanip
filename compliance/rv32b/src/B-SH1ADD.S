#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t1, 0x522a1063
    li s2, 0xd2d6b642
    sh1add t3,t1,s2
    sw t3,0(a1)
    li a3, 0x8a671b8c
    li s1, 0x5b4289cf
    sh1add t1,a3,s1
    sw t1,4(a1)
    li t1, 0x02eb0801
    li s5, 0x81920806
    sh1add a5,t1,s5
    sw a5,8(a1)
    li t2, 0x43737b61
    li a7, 0x57861f11
    sh1add t3,t2,a7
    sw t3,12(a1)
    li s11, 0xf20d8a82
    li a6, 0x1ceb0c11
    sh1add t4,s11,a6
    sw t4,16(a1)
    li s4, 0x9543c51a
    li s1, 0x9a48a02c
    sh1add t5,s4,s1
    sw t5,20(a1)
    sw zero,24(a1)
    sw zero,28(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 8,4,-1
RV_COMPLIANCE_DATA_END
