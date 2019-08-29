#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s8, 0xf38e07165dd79cfa
    li a0, 0xf2f25a0bc4ed4893
    li s9, 0x72c8a75d987a10dd
    cmix s10,s8,a0,s9
    sd s10,0(a1)
    li s11, 0x25f269ba9c6f7aa2
    li a4, 0x11fe7c5ffcae8655
    li s0, 0x3ee8d76702a2826c
    cmix s1,s11,a4,s0
    sd s1,8(a1)
    li s1, 0xe6b16607a8a22391
    li t6, 0xb4ea93d41b4286dd
    li t0, 0x682ae2c6988c0022
    cmix t2,s1,t6,t0
    sd t2,16(a1)
    li s3, 0xb6213a3c430b3272
    li s7, 0xd1ced3e82b77485c
    li t0, 0xfde0bbd38b8e8f3e
    cmix a5,s3,s7,t0
    sd a5,24(a1)
    li s0, 0xf0190cecadd85909
    li t3, 0x38b5a7ff116023b7
    li a5, 0x0557f01f29d882a1
    cmix s3,s0,t3,a5
    sd s3,32(a1)
    li s7, 0x0000000000000000
    li a2, 0x6198b4fc2ba53005
    li a3, 0x33f7912ab208965f
    cmix t5,s7,a2,a3
    sd t5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
