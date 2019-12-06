#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t2, 0x522a1063
    li t1, 0xd2d6b642
    slo s2,t2,t1
    sw s2,0(a1)
    li s8, 0x8a671b8c
    li a3, 0x5b4289cf
    slo s11,s8,a3
    sw s11,4(a1)
    li s0, 0x02eb0801
    li t4, 0x81920806
    slo s10,s0,t4
    sw s10,8(a1)
    li t0, 0x43737b61
    li s1, 0x57861f11
    slo t3,t0,s1
    sw t3,12(a1)
    li a7, 0xf20d8a82
    li t2, 0x1ceb0c11
    slo a4,a7,t2
    sw a4,16(a1)
    li s11, 0x9543c51a
    li s3, 0x9a48a02c
    slo s6,s11,s3
    sw s6,20(a1)
    li a5, 0x12ecc6b6
    li a0, 0x1750a9be
    slo s1,a5,a0
    sw s1,24(a1)
    li a6, 0x43f5e818
    li a3, 0x6486f805
    slo a4,a6,a3
    sw a4,28(a1)
    li a6, 0x44e417d0
    li a3, 0x4e13941f
    slo s7,a6,a3
    sw s7,32(a1)
    li a0, 0x4a48fd54
    li s6, 0x2000023e
    slo t4,a0,s6
    sw t4,36(a1)
    li a4, 0x7bf2539c
    li s6, 0xc7ef0f0e
    slo t6,a4,s6
    sw t6,40(a1)
    sw zero,44(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 12,4,-1
RV_COMPLIANCE_DATA_END
