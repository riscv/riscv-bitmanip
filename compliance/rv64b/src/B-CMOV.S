#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s2, 0xf38e07165dd79cfa
    li s4, 0xf2f25a0bc4ed4893
    li a2, 0x72c8a75d987a10dd
    cmov t4,s2,s4,a2
    sd t4,0(a1)
    li a6, 0x25f269ba9c6f7aa2
    li t6, 0x11fe7c5ffcae8655
    li s10, 0x3ee8d76702a2826c
    cmov a0,a6,t6,s10
    sd a0,8(a1)
    li s4, 0xe6b16607a8a22391
    li t4, 0xb4ea93d41b4286dd
    li t1, 0x682ae2c6988c0022
    cmov a4,s4,t4,t1
    sd a4,16(a1)
    li s3, 0xb6213a3c430b3272
    li s11, 0xd1ced3e82b77485c
    li s2, 0xfde0bbd38b8e8f3e
    cmov s7,s3,s11,s2
    sd s7,24(a1)
    li s7, 0xf0190cecadd85909
    li s3, 0x38b5a7ff116023b7
    li s6, 0x0557f01f29d882a1
    cmov s0,s7,s3,s6
    sd s0,32(a1)
    li a0, 0x0000000000000000
    li s10, 0x6198b4fc2ba53005
    li s0, 0x33f7912ab208965f
    cmov s9,a0,s10,s0
    sd s9,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
