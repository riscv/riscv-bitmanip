#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a7, 0x522a1063
    li s2, 0xd2d6b642
    rol s4,a7,s2
    sw s4,0(a1)
    li t1, 0x8a671b8c
    li a7, 0x5b4289cf
    rol s10,t1,a7
    sw s10,4(a1)
    li t2, 0x02eb0801
    li t1, 0x81920806
    rol s2,t2,t1
    sw s2,8(a1)
    li s8, 0x43737b61
    li a3, 0x57861f11
    rol s11,s8,a3
    sw s11,12(a1)
    li s0, 0xf20d8a82
    li t4, 0x1ceb0c11
    rol s10,s0,t4
    sw s10,16(a1)
    li t0, 0x9543c51a
    li s1, 0x9a48a02c
    rol t3,t0,s1
    sw t3,20(a1)
    li t2, 0x12ecc6b6
    li s0, 0x1750a9be
    rol a4,t2,s0
    sw a4,24(a1)
    li s3, 0x43f5e818
    li s10, 0x6486f805
    rol s5,s3,s10
    sw s5,28(a1)
    li s9, 0x44e417d0
    li t0, 0x4e13941f
    rol s0,s9,t0
    sw s0,32(a1)
    li s6, 0x4a48fd54
    li s11, 0x2000023e
    rol t2,s6,s11
    sw t2,36(a1)
    li a5, 0x7bf2539c
    li a2, 0xc7ef0f0e
    rol t4,a5,a2
    sw t4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 11,4,-1
RV_COMPLIANCE_DATA_END
