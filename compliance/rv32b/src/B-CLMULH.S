#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s7, 0x522a1063
    li a3, 0xd2d6b642
    clmulh t6,s7,a3
    sw t6,0(a1)
    li s3, 0x8a671b8c
    li s9, 0x5b4289cf
    clmulh s7,s3,s9
    sw s7,4(a1)
    li s11, 0x02eb0801
    li s3, 0x81920806
    clmulh s0,s11,s3
    sw s0,8(a1)
    li t3, 0x43737b61
    li t5, 0x57861f11
    clmulh s11,t3,t5
    sw s11,12(a1)
    li s10, 0xf20d8a82
    li t5, 0x1ceb0c11
    clmulh a4,s10,t5
    sw a4,16(a1)
    li a6, 0x9543c51a
    li s3, 0x9a48a02c
    clmulh s6,a6,s3
    sw s6,20(a1)
    li t2, 0xfa829000
    li t5, 0xc0000040
    clmulh t1,t2,t5
    sw t1,24(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 7,4,-1
RV_COMPLIANCE_DATA_END
