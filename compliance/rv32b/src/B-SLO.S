#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t1, 0x522a1063
    li a5, 0xd2d6b642
    slo t5,t1,a5
    sw t5,0(a1)
    li t2, 0x8a671b8c
    li t5, 0x5b4289cf
    slo s3,t2,t5
    sw s3,4(a1)
    li t3, 0x02eb0801
    li s9, 0x81920806
    slo s4,t3,s9
    sw s4,8(a1)
    li s7, 0x43737b61
    li a3, 0x57861f11
    slo t6,s7,a3
    sw t6,12(a1)
    li s3, 0xf20d8a82
    li s9, 0x1ceb0c11
    slo s7,s3,s9
    sw s7,16(a1)
    li s11, 0x9543c51a
    li s3, 0x9a48a02c
    slo s0,s11,s3
    sw s0,20(a1)
    li t3, 0x12ecc6b6
    li a7, 0x1750a9be
    slo s0,t3,a7
    sw s0,24(a1)
    li s4, 0x44e417d0
    li s9, 0x4e13941f
    slo s7,s4,s9
    sw s7,28(a1)
    li t5, 0x7bf2539c
    li s1, 0xc7ef0f0e
    slo a2,t5,s1
    sw a2,32(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 9,4,-1
RV_COMPLIANCE_DATA_END
