#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s7, 0xf38e07165dd79cfa
    li s11, 0xf2f25a0bc4ed4893
    li t0, 0x72c8a75d987a10dd
    fsrw a4,s7,s11,t0
    sd a4,0(a1)
    li s2, 0x25f269ba9c6f7aa2
    li a0, 0x11fe7c5ffcae8655
    li t5, 0x3ee8d76702a2826c
    fsrw s0,s2,a0,t5
    sd s0,8(a1)
    li s6, 0xe6b16607a8a22391
    li s8, 0xb4ea93d41b4286dd
    li a3, 0x682ae2c6988c0022
    fsrw a2,s6,s8,a3
    sd a2,16(a1)
    li s2, 0xb6213a3c430b3272
    li t0, 0xd1ced3e82b77485c
    li s3, 0xfde0bbd38b8e8f3e
    fsrw t6,s2,t0,s3
    sd t6,24(a1)
    li t5, 0xf0190cecadd85909
    li s7, 0x38b5a7ff116023b7
    li a0, 0x0557f01f29d882a1
    fsrw t0,t5,s7,a0
    sd t0,32(a1)
    li s0, 0x0000000000000000
    li t4, 0x6198b4fc2ba53005
    li s5, 0x33f7912ab208965f
    fsrw s9,s0,t4,s5
    sd s9,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
