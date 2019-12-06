#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s3, 0x522a1063
    grevi a4,s3,3
    sw a4,0(a1)
    li s0, 0x8a671b8c
    grevi a3,s0,5
    sw a3,4(a1)
    li s2, 0x02eb0801
    grevi a6,s2,17
    sw a6,8(a1)
    li s2, 0x43737b61
    grevi t5,s2,24
    sw t5,12(a1)
    li a7, 0xf20d8a82
    grevi a3,a7,25
    sw a3,16(a1)
    li t4, 0x9543c51a
    grevi s6,t4,31
    sw s6,20(a1)
    li t1, 0x00000281
    grevi s7,t1,19
    sw s7,24(a1)
    li s4, 0xc0002800
    grevi a5,s4,28
    sw a5,28(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 8,4,-1
RV_COMPLIANCE_DATA_END
