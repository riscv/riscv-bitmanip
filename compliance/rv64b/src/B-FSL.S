#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s4, 0xf38e07165dd79cfa
    li a0, 0xf2f25a0bc4ed4893
    li s1, 0x72c8a75d987a10dd
    fsl s2,s4,a0,s1
    sd s2,0(a1)
    li t2, 0x25f269ba9c6f7aa2
    li s7, 0x11fe7c5ffcae8655
    li a3, 0x3ee8d76702a2826c
    fsl a2,t2,s7,a3
    sd a2,8(a1)
    li t0, 0xe6b16607a8a22391
    li a3, 0xb4ea93d41b4286dd
    li s11, 0x682ae2c6988c0022
    fsl s5,t0,a3,s11
    sd s5,16(a1)
    li s5, 0xb6213a3c430b3272
    li s4, 0xd1ced3e82b77485c
    li s1, 0xfde0bbd38b8e8f3e
    fsl s10,s5,s4,s1
    sd s10,24(a1)
    li t3, 0xf0190cecadd85909
    li a0, 0x38b5a7ff116023b7
    li a2, 0x0557f01f29d882a1
    fsl a4,t3,a0,a2
    sd a4,32(a1)
    li s5, 0x0000000000000000
    li s2, 0x6198b4fc2ba53005
    li t1, 0x33f7912ab208965f
    fsl a7,s5,s2,t1
    sd a7,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
