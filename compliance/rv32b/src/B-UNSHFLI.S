#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t0, 0x522a1063
    unshfli a5,t0,0
    sw a5,0(a1)
    li a6, 0x8a671b8c
    unshfli t1,a6,1
    sw t1,4(a1)
    li s10, 0x02eb0801
    unshfli a5,s10,3
    sw a5,8(a1)
    li a7, 0x43737b61
    unshfli t4,a7,7
    sw t4,12(a1)
    li a7, 0xf20d8a82
    unshfli t5,a7,11
    sw t5,16(a1)
    li a6, 0x9543c51a
    unshfli s9,a6,13
    sw s9,20(a1)
    sw zero,24(a1)
    sw zero,28(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 8,4,-1
RV_COMPLIANCE_DATA_END
