#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t0, 0x522a1063
    sbexti s1,t0,3
    sw s1,0(a1)
    li s3, 0x8a671b8c
    sbexti t2,s3,5
    sw t2,4(a1)
    li s10, 0x02eb0801
    sbexti a4,s10,17
    sw a4,8(a1)
    li a3, 0x43737b61
    sbexti t6,a3,24
    sw t6,12(a1)
    li a3, 0xf20d8a82
    sbexti t1,a3,25
    sw t1,16(a1)
    li s9, 0x9543c51a
    sbexti t5,s9,31
    sw t5,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
