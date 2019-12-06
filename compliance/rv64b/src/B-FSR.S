#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s9, 0xf38e07165dd79cfa
    li s6, 0xf2f25a0bc4ed4893
    li s8, 0x72c8a75d987a10dd
    fsr a2,s9,s6,s8
    sd a2,0(a1)
    li a3, 0x25f269ba9c6f7aa2
    li t6, 0x11fe7c5ffcae8655
    li s11, 0x3ee8d76702a2826c
    fsr s9,a3,t6,s11
    sd s9,8(a1)
    li t0, 0xe6b16607a8a22391
    li t6, 0xb4ea93d41b4286dd
    li t2, 0x682ae2c6988c0022
    fsr s5,t0,t6,t2
    sd s5,16(a1)
    li t5, 0xb6213a3c430b3272
    li a2, 0xd1ced3e82b77485c
    li t6, 0xfde0bbd38b8e8f3e
    fsr s0,t5,a2,t6
    sd s0,24(a1)
    li s2, 0xf0190cecadd85909
    li t4, 0x38b5a7ff116023b7
    li t2, 0x0557f01f29d882a1
    fsr s3,s2,t4,t2
    sd s3,32(a1)
    li s8, 0x0000000000000000
    li a3, 0x6198b4fc2ba53005
    li s3, 0x33f7912ab208965f
    fsr t2,s8,a3,s3
    sd t2,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
