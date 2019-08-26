#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t0, 0x5dd79cfa
    li a5, 0xc4ed4893
    li a2, 0x987a10dd
    cmix a4,t0,a5,a2
    sw a4,0(a1)
    li t1, 0x9c6f7aa2
    li s1, 0xfcae8655
    li a3, 0x02a2826c
    cmix s3,t1,s1,a3
    sw s3,4(a1)
    li t3, 0xa8a22391
    li a2, 0x1b4286dd
    li t4, 0x988c0022
    cmix t0,t3,a2,t4
    sw t0,8(a1)
    li s11, 0x430b3272
    li a3, 0x2b77485c
    li t6, 0x8b8e8f3e
    cmix s3,s11,a3,t6
    sw s3,12(a1)
    li a4, 0xadd85909
    li a7, 0x116023b7
    li s0, 0x29d882a1
    cmix t6,a4,a7,s0
    sw t6,16(a1)
    li s2, 0x00000000
    li s0, 0x2ba53005
    li t4, 0xb208965f
    cmix t5,s2,s0,t4
    sw t5,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
