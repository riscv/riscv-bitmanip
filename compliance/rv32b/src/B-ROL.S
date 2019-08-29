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
    li t5, 0x12ecc6b6
    li s4, 0x1750a9be
    rol a5,t5,s4
    sw a5,24(a1)
    li a4, 0x44e417d0
    li s9, 0x4e13941f
    rol s8,a4,s9
    sw s8,28(a1)
    li s8, 0x7bf2539c
    li a4, 0xc7ef0f0e
    rol t1,s8,a4
    sw t1,32(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 9,4,-1
RV_COMPLIANCE_DATA_END
