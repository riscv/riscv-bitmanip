#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t5, 0x522a1063
    li s3, 0xd2d6b642
    slo a2,t5,s3
    sw a2,0(a1)
    li t0, 0x8a671b8c
    li s3, 0x5b4289cf
    slo s0,t0,s3
    sw s0,4(a1)
    li a7, 0x02eb0801
    li s7, 0x81920806
    slo s11,a7,s7
    sw s11,8(a1)
    li s1, 0x43737b61
    li t1, 0x57861f11
    slo s6,s1,t1
    sw s6,12(a1)
    li s8, 0xf20d8a82
    li s1, 0x1ceb0c11
    slo s5,s8,s1
    sw s5,16(a1)
    li s10, 0x9543c51a
    li a2, 0x9a48a02c
    slo a0,s10,a2
    sw a0,20(a1)
    li a3, 0x12ecc6b6
    li t3, 0x1750a9be
    slo a7,a3,t3
    sw a7,24(a1)
    li t1, 0x44e417d0
    li t4, 0x4e13941f
    slo a7,t1,t4
    sw a7,28(a1)
    li a0, 0x7bf2539c
    li a7, 0xc7ef0f0e
    slo t1,a0,a7
    sw t1,32(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 9,4,-1
RV_COMPLIANCE_DATA_END
