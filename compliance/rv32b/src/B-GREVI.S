#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a3, 0x522a1063
    grevi s5,a3,3
    sw s5,0(a1)
    li s3, 0x8a671b8c
    grevi s7,s3,5
    sw s7,4(a1)
    li s3, 0x02eb0801
    grevi a4,s3,17
    sw a4,8(a1)
    li s0, 0x43737b61
    grevi a3,s0,24
    sw a3,12(a1)
    li s2, 0xf20d8a82
    grevi a6,s2,25
    sw a6,16(a1)
    li s2, 0x9543c51a
    grevi t5,s2,31
    sw t5,20(a1)
    li s4, 0x00000281
    grevi s10,s4,19
    sw s10,24(a1)
    li t6, 0xc0002800
    grevi s0,t6,28
    sw s0,28(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 8,4,-1
RV_COMPLIANCE_DATA_END
