#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s11, 0x522a1063
    li s0, 0xd2d6b642
    shfl a3,s11,s0
    sw a3,0(a1)
    li a0, 0x8a671b8c
    li s11, 0x5b4289cf
    shfl s0,a0,s11
    sw s0,4(a1)
    li a0, 0x02eb0801
    li s2, 0x81920806
    shfl a2,a0,s2
    sw a2,8(a1)
    li t0, 0x43737b61
    li a0, 0x57861f11
    shfl t1,t0,a0
    sw t1,12(a1)
    li s4, 0xf20d8a82
    li s0, 0x1ceb0c11
    shfl t1,s4,s0
    sw t1,16(a1)
    li t1, 0x9543c51a
    li a2, 0x9a48a02c
    shfl s5,t1,a2
    sw s5,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
