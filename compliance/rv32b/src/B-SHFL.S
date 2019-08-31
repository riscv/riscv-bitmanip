#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a5, 0x522a1063
    li s3, 0xd2d6b642
    shfl a3,a5,s3
    sw a3,0(a1)
    li s4, 0x8a671b8c
    li t3, 0x5b4289cf
    shfl a0,s4,t3
    sw a0,4(a1)
    li a7, 0x02eb0801
    li s10, 0x81920806
    shfl s4,a7,s10
    sw s4,8(a1)
    li s2, 0x43737b61
    li t3, 0x57861f11
    shfl s8,s2,t3
    sw s8,12(a1)
    li t6, 0xf20d8a82
    li s7, 0x1ceb0c11
    shfl s5,t6,s7
    sw s5,16(a1)
    li s7, 0x9543c51a
    li s8, 0x9a48a02c
    shfl t1,s7,s8
    sw t1,20(a1)
    li a2, 0x00d321db
    li t2, 0x4ae7185c
    shfl s9,a2,t2
    sw s9,24(a1)
    li a4, 0x0f3ff336
    li s8, 0x4b10a48e
    shfl t1,a4,s8
    sw t1,28(a1)
    li a5, 0xf807f882
    li s1, 0xa200000e
    shfl s3,a5,s1
    sw s3,32(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 9,4,-1
RV_COMPLIANCE_DATA_END
