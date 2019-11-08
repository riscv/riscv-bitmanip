#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s2, 0xf38e07165dd79cfa
    li s3, 0xf2f25a0bc4ed4893
    li a0, 0x72c8a75d987a10dd
    cmov t4,s2,s3,a0
    sd t4,0(a1)
    li a0, 0x25f269ba9c6f7aa2
    li s9, 0x11fe7c5ffcae8655
    li s4, 0x3ee8d76702a2826c
    cmov a7,a0,s9,s4
    sd a7,8(a1)
    li a6, 0xe6b16607a8a22391
    li s11, 0xb4ea93d41b4286dd
    li t2, 0x682ae2c6988c0022
    cmov a3,a6,s11,t2
    sd a3,16(a1)
    li s5, 0xb6213a3c430b3272
    li t1, 0xd1ced3e82b77485c
    li s3, 0xfde0bbd38b8e8f3e
    cmov a4,s5,t1,s3
    sd a4,24(a1)
    li s9, 0xf0190cecadd85909
    li a3, 0x38b5a7ff116023b7
    li s11, 0x0557f01f29d882a1
    cmov t3,s9,a3,s11
    sd t3,32(a1)
    li s5, 0x0000000000000000
    li s3, 0x6198b4fc2ba53005
    li a6, 0x33f7912ab208965f
    cmov s10,s5,s3,a6
    sd s10,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
