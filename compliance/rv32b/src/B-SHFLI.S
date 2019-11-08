#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t6, 0x522a1063
    shfli s5,t6,0
    sw s5,0(a1)
    li s3, 0x8a671b8c
    shfli s7,s3,1
    sw s7,4(a1)
    li s11, 0x02eb0801
    shfli s5,s11,3
    sw s5,8(a1)
    li t0, 0x43737b61
    shfli a4,t0,7
    sw a4,12(a1)
    li s1, 0xf20d8a82
    shfli t3,s1,11
    sw t3,16(a1)
    li t4, 0x9543c51a
    shfli s6,t4,13
    sw s6,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
