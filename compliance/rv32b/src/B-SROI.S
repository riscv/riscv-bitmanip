#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a3, 0x522a1063
    sroi t1,a3,3
    sw t1,0(a1)
    li s11, 0x8a671b8c
    sroi t4,s11,5
    sw t4,4(a1)
    li s8, 0x02eb0801
    sroi a6,s8,17
    sw a6,8(a1)
    li t1, 0x43737b61
    sroi s3,t1,24
    sw s3,12(a1)
    li s9, 0xf20d8a82
    sroi s3,s9,25
    sw s3,16(a1)
    li s10, 0x9543c51a
    sroi s11,s10,31
    sw s11,20(a1)
    li s10, 0xc8680132
    sroi s1,s10,29
    sw s1,24(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 7,4,-1
RV_COMPLIANCE_DATA_END
