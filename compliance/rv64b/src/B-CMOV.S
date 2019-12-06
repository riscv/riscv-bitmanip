#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s5, 0xf38e07165dd79cfa
    li t1, 0xf2f25a0bc4ed4893
    li s3, 0x72c8a75d987a10dd
    cmov a4,s5,t1,s3
    sd a4,0(a1)
    li s9, 0x25f269ba9c6f7aa2
    li a3, 0x11fe7c5ffcae8655
    li s11, 0x3ee8d76702a2826c
    cmov t3,s9,a3,s11
    sd t3,8(a1)
    li s5, 0xe6b16607a8a22391
    li s3, 0xb4ea93d41b4286dd
    li a6, 0x682ae2c6988c0022
    cmov s10,s5,s3,a6
    sd s10,16(a1)
    li s6, 0xb6213a3c430b3272
    li s11, 0xd1ced3e82b77485c
    li s1, 0xfde0bbd38b8e8f3e
    cmov s0,s6,s11,s1
    sd s0,24(a1)
    li a2, 0xf0190cecadd85909
    li a0, 0x38b5a7ff116023b7
    li s8, 0x0557f01f29d882a1
    cmov s4,a2,a0,s8
    sd s4,32(a1)
    li t2, 0x0000000000000000
    li a2, 0x6198b4fc2ba53005
    li s1, 0x33f7912ab208965f
    cmov s4,t2,a2,s1
    sd s4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
