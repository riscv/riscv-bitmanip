#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t4, 0xf38e07165dd79cfa
    li s2, 0xf2f25a0bc4ed4893
    li a6, 0x72c8a75d987a10dd
    fsr s10,t4,s2,a6
    sd s10,0(a1)
    li s3, 0x25f269ba9c6f7aa2
    li s4, 0x11fe7c5ffcae8655
    li a5, 0x3ee8d76702a2826c
    fsr s6,s3,s4,a5
    sd s6,8(a1)
    li s9, 0xe6b16607a8a22391
    li s11, 0xb4ea93d41b4286dd
    li t2, 0x682ae2c6988c0022
    fsr a7,s9,s11,t2
    sd a7,16(a1)
    li a4, 0xb6213a3c430b3272
    li t1, 0xd1ced3e82b77485c
    li a2, 0xfde0bbd38b8e8f3e
    fsr s3,a4,t1,a2
    sd s3,24(a1)
    li a4, 0xf0190cecadd85909
    li s4, 0x38b5a7ff116023b7
    li t1, 0x0557f01f29d882a1
    fsr s9,a4,s4,t1
    sd s9,32(a1)
    li a3, 0x0000000000000000
    li s7, 0x6198b4fc2ba53005
    li a5, 0x33f7912ab208965f
    fsr t4,a3,s7,a5
    sd t4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
