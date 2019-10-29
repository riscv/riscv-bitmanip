#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t3, 0x522a1063
    sloi a3,t3,3
    sw a3,0(a1)
    li s9, 0x8a671b8c
    sloi t5,s9,5
    sw t5,4(a1)
    li t1, 0x02eb0801
    sloi t2,t1,17
    sw t2,8(a1)
    li a6, 0x43737b61
    sloi a0,a6,24
    sw a0,12(a1)
    li s11, 0xf20d8a82
    sloi s3,s11,25
    sw s3,16(a1)
    li s7, 0x9543c51a
    sloi s5,s7,31
    sw s5,20(a1)
    li s9, 0xc8680132
    sloi t6,s9,29
    sw t6,24(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 7,4,-1
RV_COMPLIANCE_DATA_END
