#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s11, 0x522a1063
    sbinvi s1,s11,3
    sw s1,0(a1)
    li a7, 0x8a671b8c
    sbinvi a4,a7,5
    sw a4,4(a1)
    li a7, 0x02eb0801
    sbinvi a4,a7,17
    sw a4,8(a1)
    li t0, 0x43737b61
    sbinvi a3,t0,24
    sw a3,12(a1)
    li t3, 0xf20d8a82
    sbinvi a3,t3,25
    sw a3,16(a1)
    li s3, 0x9543c51a
    sbinvi s7,s3,31
    sw s7,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
