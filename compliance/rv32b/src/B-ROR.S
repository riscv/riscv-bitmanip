#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t6, 0x522a1063
    li a0, 0xd2d6b642
    ror a3,t6,a0
    sw a3,0(a1)
    li t0, 0x8a671b8c
    li s4, 0x5b4289cf
    ror s2,t0,s4
    sw s2,4(a1)
    li s10, 0x02eb0801
    li a0, 0x81920806
    ror t4,s10,a0
    sw t4,8(a1)
    li s11, 0x43737b61
    li a4, 0x57861f11
    ror s1,s11,a4
    sw s1,12(a1)
    li s7, 0xf20d8a82
    li t3, 0x1ceb0c11
    ror a5,s7,t3
    sw a5,16(a1)
    li a5, 0x9543c51a
    li a0, 0x9a48a02c
    ror t2,a5,a0
    sw t2,20(a1)
    li t5, 0x12ecc6b6
    li s4, 0x1750a9be
    ror t6,t5,s4
    sw t6,24(a1)
    li a7, 0x43f5e818
    li s7, 0x6486f805
    ror t4,a7,s7
    sw t4,28(a1)
    li a4, 0x44e417d0
    li t2, 0x4e13941f
    ror a7,a4,t2
    sw a7,32(a1)
    li a3, 0x4a48fd54
    li t0, 0x2000023e
    ror s0,a3,t0
    sw s0,36(a1)
    li s8, 0x7bf2539c
    li s3, 0xc7ef0f0e
    ror t0,s8,s3
    sw t0,40(a1)
    sw zero,44(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 12,4,-1
RV_COMPLIANCE_DATA_END
