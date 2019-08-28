#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s6, 0x522a1063
    li t5, 0xd2d6b642
    ror a4,s6,t5
    sw a4,0(a1)
    li a7, 0x8a671b8c
    li s2, 0x5b4289cf
    ror s4,a7,s2
    sw s4,4(a1)
    li t1, 0x02eb0801
    li a7, 0x81920806
    ror s10,t1,a7
    sw s10,8(a1)
    li t2, 0x43737b61
    li t1, 0x57861f11
    ror s2,t2,t1
    sw s2,12(a1)
    li s8, 0xf20d8a82
    li a3, 0x1ceb0c11
    ror s11,s8,a3
    sw s11,16(a1)
    li s0, 0x9543c51a
    li t4, 0x9a48a02c
    ror s10,s0,t4
    sw s10,20(a1)
    li a3, 0x12ecc6b6
    li s3, 0x1750a9be
    ror s4,a3,s3
    sw s4,24(a1)
    li a6, 0x44e417d0
    li s3, 0x4e13941f
    ror a4,a6,s3
    sw a4,28(a1)
    li a7, 0x7bf2539c
    li t6, 0xc7ef0f0e
    ror a0,a7,t6
    sw a0,32(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 9,4,-1
RV_COMPLIANCE_DATA_END
