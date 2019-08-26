#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t0, 0x522a1063
    li a3, 0xd2d6b642
    unshfl s2,t0,a3
    sw s2,0(a1)
    li a5, 0x8a671b8c
    li s3, 0x5b4289cf
    unshfl a3,a5,s3
    sw a3,4(a1)
    li s4, 0x02eb0801
    li t3, 0x81920806
    unshfl a0,s4,t3
    sw a0,8(a1)
    li a7, 0x43737b61
    li s10, 0x57861f11
    unshfl s4,a7,s10
    sw s4,12(a1)
    li s2, 0xf20d8a82
    li t3, 0x1ceb0c11
    unshfl s8,s2,t3
    sw s8,16(a1)
    li t6, 0x9543c51a
    li s7, 0x9a48a02c
    unshfl s5,t6,s7
    sw s5,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
