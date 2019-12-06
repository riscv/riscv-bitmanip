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
    li s8, 0x12ecc6b6
    li s3, 0x1750a9be
    sro t0,s8,s3
    sw t0,24(a1)
    li s6, 0x43f5e818
    li t4, 0x6486f805
    sro s11,s6,t4
    sw s11,28(a1)
    li s11, 0x44e417d0
    li s9, 0x4e13941f
    sro s5,s11,s9
    sw s5,32(a1)
    li s11, 0x4a48fd54
    li s8, 0x2000023e
    sro a3,s11,s8
    sw a3,36(a1)
    li s11, 0x7bf2539c
    li t4, 0xc7ef0f0e
    sro s5,s11,t4
    sw s5,40(a1)
    sw zero,44(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 12,4,-1
RV_COMPLIANCE_DATA_END
