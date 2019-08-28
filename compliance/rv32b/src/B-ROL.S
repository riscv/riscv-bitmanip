#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a0, 0x522a1063
    li t2, 0xd2d6b642
    rol s5,a0,t2
    sw s5,0(a1)
    li s1, 0x8a671b8c
    li s9, 0x5b4289cf
    rol s5,s1,s9
    sw s5,4(a1)
    li s0, 0x02eb0801
    li a6, 0x81920806
    rol a4,s0,a6
    sw a4,8(a1)
    li s5, 0x43737b61
    li s1, 0x57861f11
    rol s9,s5,s1
    sw s9,12(a1)
    li t2, 0xf20d8a82
    li s1, 0x1ceb0c11
    rol s2,t2,s1
    sw s2,16(a1)
    li a2, 0x9543c51a
    li s5, 0x9a48a02c
    rol s6,a2,s5
    sw s6,20(a1)
    li s10, 0x12ecc6b6
    li t0, 0x1750a9be
    rol a0,s10,t0
    sw a0,24(a1)
    li a2, 0x44e417d0
    li s7, 0x4e13941f
    rol a5,a2,s7
    sw a5,28(a1)
    li t3, 0x7bf2539c
    li a7, 0xc7ef0f0e
    rol s11,t3,a7
    sw s11,32(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 9,4,-1
RV_COMPLIANCE_DATA_END
