#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a0, 0x522a1063
    li s11, 0xd2d6b642
    ror s0,a0,s11
    sw s0,0(a1)
    li a0, 0x8a671b8c
    li s2, 0x5b4289cf
    ror a2,a0,s2
    sw a2,4(a1)
    li t0, 0x02eb0801
    li a0, 0x81920806
    ror t1,t0,a0
    sw t1,8(a1)
    li s4, 0x43737b61
    li s0, 0x57861f11
    ror t1,s4,s0
    sw t1,12(a1)
    li t1, 0xf20d8a82
    li a2, 0x1ceb0c11
    ror s5,t1,a2
    sw s5,16(a1)
    li s9, 0x9543c51a
    li s5, 0x9a48a02c
    ror s7,s9,s5
    sw s7,20(a1)
    li s11, 0x12ecc6b6
    li s1, 0x1750a9be
    ror a5,s11,s1
    sw a5,24(a1)
    li t5, 0x43f5e818
    li s8, 0x6486f805
    ror s3,t5,s8
    sw s3,28(a1)
    li a0, 0x44e417d0
    li t0, 0x4e13941f
    ror s0,a0,t0
    sw s0,32(a1)
    li s1, 0x4a48fd54
    li t5, 0x2000023e
    ror t3,s1,t5
    sw t3,36(a1)
    li s9, 0x7bf2539c
    li t4, 0xc7ef0f0e
    ror a6,s9,t4
    sw a6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 11,4,-1
RV_COMPLIANCE_DATA_END
