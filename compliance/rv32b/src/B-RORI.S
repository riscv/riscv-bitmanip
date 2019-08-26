#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t0, 0x522a1063
    rori t3,t0,3
    sw t3,0(a1)
    li s2, 0x8a671b8c
    rori t0,s2,5
    sw t0,4(a1)
    li a2, 0x02eb0801
    rori t0,a2,17
    sw t0,8(a1)
    li a7, 0x43737b61
    rori s3,a7,24
    sw s3,12(a1)
    li a5, 0xf20d8a82
    rori s11,a5,25
    sw s11,16(a1)
    li s5, 0x9543c51a
    rori t3,s5,31
    sw t3,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
