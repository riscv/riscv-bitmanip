#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s10, 0x522a1063
    unshfli t4,s10,0
    sw t4,0(a1)
    li s4, 0x8a671b8c
    unshfli t5,s4,1
    sw t5,4(a1)
    li t5, 0x02eb0801
    unshfli a2,t5,3
    sw a2,8(a1)
    li s3, 0x43737b61
    unshfli a4,s3,7
    sw a4,12(a1)
    li s8, 0xf20d8a82
    unshfli a6,s8,11
    sw a6,16(a1)
    li t2, 0x9543c51a
    unshfli t5,t2,13
    sw t5,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
