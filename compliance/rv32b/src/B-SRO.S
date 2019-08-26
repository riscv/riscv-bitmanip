#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s0, 0x522a1063
    li a5, 0xd2d6b642
    sro s11,s0,a5
    sw s11,0(a1)
    li t1, 0x8a671b8c
    li a5, 0x5b4289cf
    sro t5,t1,a5
    sw t5,4(a1)
    li t2, 0x02eb0801
    li t5, 0x81920806
    sro s3,t2,t5
    sw s3,8(a1)
    li t3, 0x43737b61
    li s9, 0x57861f11
    sro s4,t3,s9
    sw s4,12(a1)
    li s7, 0xf20d8a82
    li a3, 0x1ceb0c11
    sro t6,s7,a3
    sw t6,16(a1)
    li s3, 0x9543c51a
    li s9, 0x9a48a02c
    sro s7,s3,s9
    sw s7,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
