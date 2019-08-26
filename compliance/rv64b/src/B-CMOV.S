#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t0, 0xf38e07165dd79cfa
    li s11, 0xf2f25a0bc4ed4893
    li t1, 0x72c8a75d987a10dd
    cmov s2,t0,s11,t1
    sd s2,0(a1)
    li a3, 0x25f269ba9c6f7aa2
    li s9, 0x11fe7c5ffcae8655
    li s3, 0x3ee8d76702a2826c
    cmov t3,a3,s9,s3
    sd t3,8(a1)
    li a0, 0xe6b16607a8a22391
    li s5, 0xb4ea93d41b4286dd
    li s0, 0x682ae2c6988c0022
    cmov a2,a0,s5,s0
    sd a2,16(a1)
    li a6, 0xb6213a3c430b3272
    li t1, 0xd1ced3e82b77485c
    li s11, 0xfde0bbd38b8e8f3e
    cmov s10,a6,t1,s11
    sd s10,24(a1)
    li t3, 0xf0190cecadd85909
    li a2, 0x38b5a7ff116023b7
    li s1, 0x0557f01f29d882a1
    cmov a3,t3,a2,s1
    sd a3,32(a1)
    li a5, 0x0000000000000000
    li s6, 0x6198b4fc2ba53005
    li t5, 0x33f7912ab208965f
    cmov s4,a5,s6,t5
    sd s4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
