#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t0, 0x522a1063
    li a0, 0xd2d6b642
    sro t1,t0,a0
    sw t1,0(a1)
    li s4, 0x8a671b8c
    li s0, 0x5b4289cf
    sro t1,s4,s0
    sw t1,4(a1)
    li t1, 0x02eb0801
    li a2, 0x81920806
    sro s5,t1,a2
    sw s5,8(a1)
    li s9, 0x43737b61
    li s5, 0x57861f11
    sro s7,s9,s5
    sw s7,12(a1)
    li s3, 0xf20d8a82
    li t6, 0x1ceb0c11
    sro t2,s3,t6
    sw t2,16(a1)
    li s3, 0x9543c51a
    li s8, 0x9a48a02c
    sro t6,s3,s8
    sw t6,20(a1)
    li s7, 0x12ecc6b6
    li a7, 0x1750a9be
    sro a3,s7,a7
    sw a3,24(a1)
    li t3, 0x43f5e818
    li s4, 0x6486f805
    sro t0,t3,s4
    sw t0,28(a1)
    li a4, 0x44e417d0
    li a7, 0x4e13941f
    sro s8,a4,a7
    sw s8,32(a1)
    li t0, 0x4a48fd54
    li t5, 0x2000023e
    sro s4,t0,t5
    sw s4,36(a1)
    li t1, 0x7bf2539c
    li s2, 0xc7ef0f0e
    sro a7,t1,s2
    sw a7,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 11,4,-1
RV_COMPLIANCE_DATA_END
