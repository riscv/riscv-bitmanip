#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s0, 0x5dd79cfa
    li a4, 0xc4ed4893
    li a7, 0x987a10dd
    fsr t5,s0,a4,a7
    sw t5,0(a1)
    li a6, 0x9c6f7aa2
    li t0, 0xfcae8655
    li t4, 0x02a2826c
    fsr a0,a6,t0,t4
    sw a0,4(a1)
    li s6, 0xa8a22391
    li s4, 0x1b4286dd
    li s8, 0x988c0022
    fsr t6,s6,s4,s8
    sw t6,8(a1)
    li s2, 0x430b3272
    li s7, 0x2b77485c
    li s0, 0x8b8e8f3e
    fsr a6,s2,s7,s0
    sw a6,12(a1)
    li s7, 0xadd85909
    li s6, 0x116023b7
    li s0, 0x29d882a1
    fsr t1,s7,s6,s0
    sw t1,16(a1)
    li t6, 0x00000000
    li s11, 0x2ba53005
    li a7, 0xb208965f
    fsr a3,t6,s11,a7
    sw a3,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
