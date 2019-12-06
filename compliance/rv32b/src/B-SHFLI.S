#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t4, 0x522a1063
    shfli a0,t4,0
    sw a0,0(a1)
    li t6, 0x8a671b8c
    shfli a5,t6,1
    sw a5,4(a1)
    li s11, 0x02eb0801
    shfli a3,s11,3
    sw a3,8(a1)
    li a5, 0x43737b61
    shfli a0,a5,7
    sw a0,12(a1)
    li s10, 0xf20d8a82
    shfli s7,s10,11
    sw s7,16(a1)
    li s2, 0x9543c51a
    shfli s8,s2,13
    sw s8,20(a1)
    sw zero,24(a1)
    sw zero,28(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 8,4,-1
RV_COMPLIANCE_DATA_END
