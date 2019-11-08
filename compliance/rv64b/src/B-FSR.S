#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s11, 0xf38e07165dd79cfa
    li s1, 0xf2f25a0bc4ed4893
    li s3, 0x72c8a75d987a10dd
    fsr s10,s11,s1,s3
    sd s10,0(a1)
    li s4, 0x25f269ba9c6f7aa2
    li s1, 0x11fe7c5ffcae8655
    li s0, 0x3ee8d76702a2826c
    fsr t4,s4,s1,s0
    sd t4,8(a1)
    li t0, 0xe6b16607a8a22391
    li t6, 0xb4ea93d41b4286dd
    li s3, 0x682ae2c6988c0022
    fsr s0,t0,t6,s3
    sd s0,16(a1)
    li t2, 0xb6213a3c430b3272
    li a6, 0xd1ced3e82b77485c
    li s3, 0xfde0bbd38b8e8f3e
    fsr t1,t2,a6,s3
    sd t1,24(a1)
    li a2, 0xf0190cecadd85909
    li a7, 0x38b5a7ff116023b7
    li s1, 0x0557f01f29d882a1
    fsr s4,a2,a7,s1
    sd s4,32(a1)
    li t0, 0x0000000000000000
    li s6, 0x6198b4fc2ba53005
    li s7, 0x33f7912ab208965f
    fsr a3,t0,s6,s7
    sd a3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
