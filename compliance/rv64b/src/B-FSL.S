#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t6, 0xf38e07165dd79cfa
    li s4, 0xf2f25a0bc4ed4893
    li s11, 0x72c8a75d987a10dd
    fsl s9,t6,s4,s11
    sd s9,0(a1)
    li s4, 0x25f269ba9c6f7aa2
    li a5, 0x11fe7c5ffcae8655
    li t6, 0x3ee8d76702a2826c
    fsl t5,s4,a5,t6
    sd t5,8(a1)
    li t4, 0xe6b16607a8a22391
    li s5, 0xb4ea93d41b4286dd
    li a7, 0x682ae2c6988c0022
    fsl a6,t4,s5,a7
    sd a6,16(a1)
    li a4, 0xb6213a3c430b3272
    li t5, 0xd1ced3e82b77485c
    li s1, 0xfde0bbd38b8e8f3e
    fsl t4,a4,t5,s1
    sd t4,24(a1)
    li s10, 0xf0190cecadd85909
    li s9, 0x38b5a7ff116023b7
    li t6, 0x0557f01f29d882a1
    fsl s0,s10,s9,t6
    sd s0,32(a1)
    li s8, 0x0000000000000000
    li s10, 0x6198b4fc2ba53005
    li s7, 0x33f7912ab208965f
    fsl s11,s8,s10,s7
    sd s11,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
