#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s11, 0x522a1063
    shfli t4,s11,0
    sw t4,0(a1)
    li t3, 0x8a671b8c
    shfli s2,t3,1
    sw s2,4(a1)
    li a5, 0x02eb0801
    shfli s4,a5,3
    sw s4,8(a1)
    li s8, 0x43737b61
    shfli s11,s8,7
    sw s11,12(a1)
    li t1, 0xf20d8a82
    shfli t2,t1,11
    sw t2,16(a1)
    li t5, 0x9543c51a
    shfli s4,t5,13
    sw s4,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
