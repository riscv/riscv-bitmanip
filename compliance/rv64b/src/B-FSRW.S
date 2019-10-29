#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a3, 0xf38e07165dd79cfa
    li t2, 0xf2f25a0bc4ed4893
    li s7, 0x72c8a75d987a10dd
    fsrw a6,a3,t2,s7
    sd a6,0(a1)
    li s6, 0x25f269ba9c6f7aa2
    li s11, 0x11fe7c5ffcae8655
    li s1, 0x3ee8d76702a2826c
    fsrw s0,s6,s11,s1
    sd s0,8(a1)
    li t0, 0xe6b16607a8a22391
    li s8, 0xb4ea93d41b4286dd
    li s3, 0x682ae2c6988c0022
    fsrw a6,t0,s8,s3
    sd a6,16(a1)
    li a2, 0xb6213a3c430b3272
    li a0, 0xd1ced3e82b77485c
    li s8, 0xfde0bbd38b8e8f3e
    fsrw s4,a2,a0,s8
    sd s4,24(a1)
    li s10, 0xf0190cecadd85909
    li s3, 0x38b5a7ff116023b7
    li s6, 0x0557f01f29d882a1
    fsrw a7,s10,s3,s6
    sd a7,32(a1)
    li t2, 0x0000000000000000
    li a2, 0x6198b4fc2ba53005
    li s1, 0x33f7912ab208965f
    fsrw s4,t2,a2,s1
    sd s4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
