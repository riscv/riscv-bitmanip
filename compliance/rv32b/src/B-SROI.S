#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s5, 0x522a1063
    sroi s1,s5,3
    sw s1,0(a1)
    li a3, 0x8a671b8c
    sroi s9,a3,5
    sw s9,4(a1)
    li s1, 0x02eb0801
    sroi t2,s1,17
    sw t2,8(a1)
    li s3, 0x43737b61
    sroi t6,s3,24
    sw t6,12(a1)
    li a6, 0xf20d8a82
    sroi s6,a6,25
    sw s6,16(a1)
    li t1, 0x9543c51a
    sroi a5,t1,31
    sw a5,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
