#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t1, 0x522a1063
    rori a0,t1,3
    sw a0,0(a1)
    li s11, 0x8a671b8c
    rori s6,s11,5
    sw s6,4(a1)
    li a6, 0x02eb0801
    rori s6,a6,17
    sw s6,8(a1)
    li s5, 0x43737b61
    rori t3,s5,24
    sw t3,12(a1)
    li a5, 0xf20d8a82
    rori s4,a5,25
    sw s4,16(a1)
    li s0, 0x9543c51a
    rori t5,s0,31
    sw t5,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
