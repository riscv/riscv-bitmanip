#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a3, 0x522a1063
    unshfli s0,a3,0
    sw s0,0(a1)
    li s6, 0x8a671b8c
    unshfli t6,s6,1
    sw t6,4(a1)
    li s6, 0x02eb0801
    unshfli a2,s6,3
    sw a2,8(a1)
    li s2, 0x43737b61
    unshfli a6,s2,7
    sw a6,12(a1)
    li s9, 0xf20d8a82
    unshfli s3,s9,11
    sw s3,16(a1)
    li s7, 0x9543c51a
    unshfli t1,s7,13
    sw t1,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
