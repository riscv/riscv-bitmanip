#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a7, 0x522a1063
    rori a0,a7,3
    sw a0,0(a1)
    li s10, 0x8a671b8c
    rori t4,s10,5
    sw t4,4(a1)
    li t5, 0x02eb0801
    rori s4,t5,17
    sw s4,8(a1)
    li a3, 0x43737b61
    rori s0,a3,24
    sw s0,12(a1)
    li s6, 0xf20d8a82
    rori s9,s6,25
    sw s9,16(a1)
    li a2, 0x9543c51a
    rori s1,a2,31
    sw s1,20(a1)
    li a5, 0xc8680132
    rori a7,a5,29
    sw a7,24(a1)
    sw zero,28(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 8,4,-1
RV_COMPLIANCE_DATA_END
