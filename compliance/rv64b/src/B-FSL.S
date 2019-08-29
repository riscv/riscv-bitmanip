#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a3, 0xf38e07165dd79cfa
    li t6, 0xf2f25a0bc4ed4893
    li t1, 0x72c8a75d987a10dd
    fsl t4,a3,t6,t1
    sd t4,0(a1)
    li s7, 0x25f269ba9c6f7aa2
    li a4, 0x11fe7c5ffcae8655
    li t3, 0x3ee8d76702a2826c
    fsl t0,s7,a4,t3
    sd t0,8(a1)
    li t2, 0xe6b16607a8a22391
    li a4, 0xb4ea93d41b4286dd
    li a5, 0x682ae2c6988c0022
    fsl s5,t2,a4,a5
    sd s5,16(a1)
    li t2, 0xb6213a3c430b3272
    li t4, 0xd1ced3e82b77485c
    li s7, 0xfde0bbd38b8e8f3e
    fsl s6,t2,t4,s7
    sd s6,24(a1)
    li a0, 0xf0190cecadd85909
    li a5, 0x38b5a7ff116023b7
    li a4, 0x0557f01f29d882a1
    fsl s4,a0,a5,a4
    sd s4,32(a1)
    li t1, 0x0000000000000000
    li s8, 0x6198b4fc2ba53005
    li t4, 0x33f7912ab208965f
    fsl s9,t1,s8,t4
    sd s9,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
