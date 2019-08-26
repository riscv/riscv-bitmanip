#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s9, 0x5dd79cfa
    li a4, 0xc4ed4893
    li a2, 0x987a10dd
    fsl t1,s9,a4,a2
    sw t1,0(a1)
    li s0, 0x9c6f7aa2
    li a0, 0xfcae8655
    li t5, 0x02a2826c
    fsl a3,s0,a0,t5
    sw a3,4(a1)
    li s4, 0xa8a22391
    li a5, 0x1b4286dd
    li t2, 0x988c0022
    fsl s3,s4,a5,t2
    sw s3,8(a1)
    li a4, 0x430b3272
    li s2, 0x2b77485c
    li t0, 0x8b8e8f3e
    fsl a3,a4,s2,t0
    sw a3,12(a1)
    li s6, 0xadd85909
    li t1, 0x116023b7
    li a5, 0x29d882a1
    fsl s9,s6,t1,a5
    sw s9,16(a1)
    li s5, 0x00000000
    li a2, 0x2ba53005
    li s7, 0xb208965f
    fsl a5,s5,a2,s7
    sw a5,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
