#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s11, 0x522a1063
    sloi s0,s11,3
    sw s0,0(a1)
    li a0, 0x8a671b8c
    sloi s8,a0,5
    sw s8,4(a1)
    li s7, 0x02eb0801
    sloi a5,s7,17
    sw a5,8(a1)
    li s11, 0x43737b61
    sloi s6,s11,24
    sw s6,12(a1)
    li t5, 0xf20d8a82
    sloi t2,t5,25
    sw t2,16(a1)
    li a7, 0x9543c51a
    sloi t6,a7,31
    sw t6,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
