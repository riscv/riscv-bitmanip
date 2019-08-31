#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s3, 0x522a1063
    sroi t2,s3,3
    sw t2,0(a1)
    li a2, 0x8a671b8c
    sroi s2,a2,5
    sw s2,4(a1)
    li t5, 0x02eb0801
    sroi t2,t5,17
    sw t2,8(a1)
    li t1, 0x43737b61
    sroi a5,t1,24
    sw a5,12(a1)
    li s4, 0xf20d8a82
    sroi t5,s4,25
    sw t5,16(a1)
    li s9, 0x9543c51a
    sroi t1,s9,31
    sw t1,20(a1)
    li s0, 0xc8680132
    sroi s5,s0,29
    sw s5,24(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 7,4,-1
RV_COMPLIANCE_DATA_END
