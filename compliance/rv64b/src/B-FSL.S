#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s10, 0xf38e07165dd79cfa
    li s11, 0xf2f25a0bc4ed4893
    li s2, 0x72c8a75d987a10dd
    fsl s4,s10,s11,s2
    sd s4,0(a1)
    li s7, 0x25f269ba9c6f7aa2
    li s9, 0x11fe7c5ffcae8655
    li a4, 0x3ee8d76702a2826c
    fsl s5,s7,s9,a4
    sd s5,8(a1)
    li t2, 0xe6b16607a8a22391
    li a7, 0xb4ea93d41b4286dd
    li a0, 0x682ae2c6988c0022
    fsl s1,t2,a7,a0
    sd s1,16(a1)
    li a3, 0xb6213a3c430b3272
    li t3, 0xd1ced3e82b77485c
    li a5, 0xfde0bbd38b8e8f3e
    fsl s11,a3,t3,a5
    sd s11,24(a1)
    li a3, 0xf0190cecadd85909
    li s7, 0x38b5a7ff116023b7
    li a6, 0x0557f01f29d882a1
    fsl s5,a3,s7,a6
    sd s5,32(a1)
    li s4, 0x0000000000000000
    li t2, 0x6198b4fc2ba53005
    li a3, 0x33f7912ab208965f
    fsl s6,s4,t2,a3
    sd s6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
