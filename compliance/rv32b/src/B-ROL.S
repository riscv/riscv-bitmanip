#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a7, 0x522a1063
    li s10, 0xd2d6b642
    rol s4,a7,s10
    sw s4,0(a1)
    li s2, 0x8a671b8c
    li t3, 0x5b4289cf
    rol s8,s2,t3
    sw s8,4(a1)
    li t6, 0x02eb0801
    li s7, 0x81920806
    rol s5,t6,s7
    sw s5,8(a1)
    li s7, 0x43737b61
    li s8, 0x57861f11
    rol t1,s7,s8
    sw t1,12(a1)
    li t1, 0xf20d8a82
    li t3, 0x1ceb0c11
    rol a0,t1,t3
    sw a0,16(a1)
    li a7, 0x9543c51a
    li s11, 0x9a48a02c
    rol s3,a7,s11
    sw s3,20(a1)
    li s4, 0x12ecc6b6
    li t1, 0x1750a9be
    rol a6,s4,t1
    sw a6,24(a1)
    li t3, 0x43f5e818
    li s0, 0x6486f805
    rol a2,t3,s0
    sw a2,28(a1)
    li t4, 0x44e417d0
    li t6, 0x4e13941f
    rol s5,t4,t6
    sw s5,32(a1)
    li a7, 0x4a48fd54
    li t1, 0x2000023e
    rol s6,a7,t1
    sw s6,36(a1)
    li a3, 0x7bf2539c
    li s11, 0xc7ef0f0e
    rol s10,a3,s11
    sw s10,40(a1)
    sw zero,44(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 12,4,-1
RV_COMPLIANCE_DATA_END
