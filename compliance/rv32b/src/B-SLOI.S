#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a7, 0x522a1063
    sloi a4,a7,3
    sw a4,0(a1)
    li s10, 0x8a671b8c
    sloi a4,s10,5
    sw a4,4(a1)
    li s3, 0x02eb0801
    sloi s5,s3,17
    sw s5,8(a1)
    li a7, 0x43737b61
    sloi t6,a7,24
    sw t6,12(a1)
    li t3, 0xf20d8a82
    sloi s2,t3,25
    sw s2,16(a1)
    li t2, 0x9543c51a
    sloi t5,t2,31
    sw t5,20(a1)
    li t2, 0xc8680132
    sloi s8,t2,29
    sw s8,24(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 7,4,-1
RV_COMPLIANCE_DATA_END
