#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t1, 0x522a1063
    sloi t2,t1,3
    sw t2,0(a1)
    li a6, 0x8a671b8c
    sloi a0,a6,5
    sw a0,4(a1)
    li s11, 0x02eb0801
    sloi s3,s11,17
    sw s3,8(a1)
    li s7, 0x43737b61
    sloi s5,s7,24
    sw s5,12(a1)
    li s3, 0xf20d8a82
    sloi s7,s3,25
    sw s7,16(a1)
    li s6, 0x9543c51a
    sloi t0,s6,31
    sw t0,20(a1)
    li s9, 0xc8680132
    sloi s4,s9,29
    sw s4,24(a1)
    sw zero,28(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 8,4,-1
RV_COMPLIANCE_DATA_END
