#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t5, 0x522a1063
    rori s4,t5,3
    sw s4,0(a1)
    li a3, 0x8a671b8c
    rori s0,a3,5
    sw s0,4(a1)
    li s6, 0x02eb0801
    rori s9,s6,17
    sw s9,8(a1)
    li a2, 0x43737b61
    rori s1,a2,24
    sw s1,12(a1)
    li s11, 0xf20d8a82
    rori s5,s11,25
    sw s5,16(a1)
    li s10, 0x9543c51a
    rori t1,s10,31
    sw t1,20(a1)
    li a3, 0xc8680132
    rori a0,a3,29
    sw a0,24(a1)
    sw zero,28(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 8,4,-1
RV_COMPLIANCE_DATA_END
