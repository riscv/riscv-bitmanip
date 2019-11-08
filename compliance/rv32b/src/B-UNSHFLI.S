#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a7, 0x522a1063
    unshfli a3,a7,0
    sw a3,0(a1)
    li t2, 0x8a671b8c
    unshfli s6,t2,1
    sw s6,4(a1)
    li t6, 0x02eb0801
    unshfli t2,t6,3
    sw t2,8(a1)
    li s2, 0x43737b61
    unshfli t1,s2,7
    sw t1,12(a1)
    li t3, 0xf20d8a82
    unshfli s2,t3,11
    sw s2,16(a1)
    li s6, 0x9543c51a
    unshfli t0,s6,13
    sw t0,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
