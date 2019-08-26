#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s8, 0x522a1063
    grevi a3,s8,3
    sw a3,0(a1)
    li a0, 0x8a671b8c
    grevi s7,a0,5
    sw s7,4(a1)
    li t1, 0x02eb0801
    grevi a0,t1,17
    sw a0,8(a1)
    li a2, 0x43737b61
    grevi s2,a2,24
    sw s2,12(a1)
    li s3, 0xf20d8a82
    grevi s5,s3,25
    sw s5,16(a1)
    li a7, 0x9543c51a
    grevi a0,a7,31
    sw a0,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
