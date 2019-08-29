#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t1, 0x522a1063
    shfli s3,t1,0
    sw s3,0(a1)
    li s4, 0x8a671b8c
    shfli s3,s4,1
    sw s3,4(a1)
    li t3, 0x02eb0801
    shfli t0,t3,3
    sw t0,8(a1)
    li a4, 0x43737b61
    shfli a3,a4,7
    sw a3,12(a1)
    li s11, 0xf20d8a82
    shfli s3,s11,11
    sw s3,16(a1)
    li s6, 0x9543c51a
    shfli s9,s6,13
    sw s9,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
