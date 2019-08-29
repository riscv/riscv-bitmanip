#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s1, 0x522a1063
    li s9, 0xd2d6b642
    sro s5,s1,s9
    sw s5,0(a1)
    li s0, 0x8a671b8c
    li a6, 0x5b4289cf
    sro a4,s0,a6
    sw a4,4(a1)
    li s5, 0x02eb0801
    li s1, 0x81920806
    sro s9,s5,s1
    sw s9,8(a1)
    li t2, 0x43737b61
    li s1, 0x57861f11
    sro s2,t2,s1
    sw s2,12(a1)
    li a2, 0xf20d8a82
    li s5, 0x1ceb0c11
    sro s6,a2,s5
    sw s6,16(a1)
    li s5, 0x9543c51a
    li s6, 0x9a48a02c
    sro s1,s5,s6
    sw s1,20(a1)
    li a6, 0x12ecc6b6
    li s7, 0x1750a9be
    sro s5,a6,s7
    sw s5,24(a1)
    li s2, 0x44e417d0
    li t2, 0x4e13941f
    sro s3,s2,t2
    sw s3,28(a1)
    li a5, 0x7bf2539c
    li s4, 0xc7ef0f0e
    sro s8,a5,s4
    sw s8,32(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 9,4,-1
RV_COMPLIANCE_DATA_END
