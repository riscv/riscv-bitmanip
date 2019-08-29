#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t3, 0xf38e07165dd79cfa
    li t0, 0xf2f25a0bc4ed4893
    li t4, 0x72c8a75d987a10dd
    fsr s10,t3,t0,t4
    sd s10,0(a1)
    li a5, 0x25f269ba9c6f7aa2
    li t3, 0x11fe7c5ffcae8655
    li s11, 0x3ee8d76702a2826c
    fsr s5,a5,t3,s11
    sd s5,8(a1)
    li t2, 0xe6b16607a8a22391
    li a5, 0xb4ea93d41b4286dd
    li s11, 0x682ae2c6988c0022
    fsr s4,t2,a5,s11
    sd s4,16(a1)
    li t4, 0xb6213a3c430b3272
    li t5, 0xd1ced3e82b77485c
    li a3, 0xfde0bbd38b8e8f3e
    fsr s9,t4,t5,a3
    sd s9,24(a1)
    li t6, 0xf0190cecadd85909
    li t2, 0x38b5a7ff116023b7
    li s1, 0x0557f01f29d882a1
    fsr a6,t6,t2,s1
    sd a6,32(a1)
    li s5, 0x0000000000000000
    li s0, 0x6198b4fc2ba53005
    li t1, 0x33f7912ab208965f
    fsr a6,s5,s0,t1
    sd a6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
