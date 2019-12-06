#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s8, 0x522a1063
    sroi a6,s8,3
    sw a6,0(a1)
    li t1, 0x8a671b8c
    sroi s3,t1,5
    sw s3,4(a1)
    li s9, 0x02eb0801
    sroi s3,s9,17
    sw s3,8(a1)
    li s10, 0x43737b61
    sroi s11,s10,24
    sw s11,12(a1)
    li t2, 0xf20d8a82
    sroi s6,t2,25
    sw s6,16(a1)
    li t5, 0x9543c51a
    sroi s11,t5,31
    sw s11,20(a1)
    li s11, 0xc8680132
    sroi s7,s11,29
    sw s7,24(a1)
    sw zero,28(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 8,4,-1
RV_COMPLIANCE_DATA_END
