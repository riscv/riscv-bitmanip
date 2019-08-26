#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s10, 0x522a1063
    li s2, 0xd2d6b642
    clmul a4,s10,s2
    sw a4,0(a1)
    li s1, 0x8a671b8c
    li t2, 0x5b4289cf
    clmul s0,s1,t2
    sw s0,4(a1)
    li s2, 0x02eb0801
    li a2, 0x81920806
    clmul s7,s2,a2
    sw s7,8(a1)
    li a0, 0x43737b61
    li s5, 0x57861f11
    clmul s6,a0,s5
    sw s6,12(a1)
    li s3, 0xf20d8a82
    li s1, 0x1ceb0c11
    clmul a2,s3,s1
    sw a2,16(a1)
    li a0, 0x9543c51a
    li a6, 0x9a48a02c
    clmul a5,a0,a6
    sw a5,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
