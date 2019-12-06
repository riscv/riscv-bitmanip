#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t5, 0xf38e07165dd79cfa
    li a6, 0xf2f25a0bc4ed4893
    li s5, 0x72c8a75d987a10dd
    fslw s9,t5,a6,s5
    sd s9,0(a1)
    li t6, 0x25f269ba9c6f7aa2
    li a7, 0x11fe7c5ffcae8655
    li s0, 0x3ee8d76702a2826c
    fslw s3,t6,a7,s0
    sd s3,8(a1)
    li s5, 0xe6b16607a8a22391
    li t6, 0xb4ea93d41b4286dd
    li t0, 0x682ae2c6988c0022
    fslw a0,s5,t6,t0
    sd a0,16(a1)
    li t4, 0xb6213a3c430b3272
    li a7, 0xd1ced3e82b77485c
    li t2, 0xfde0bbd38b8e8f3e
    fslw s2,t4,a7,t2
    sd s2,24(a1)
    li s4, 0xf0190cecadd85909
    li s1, 0x38b5a7ff116023b7
    li a7, 0x0557f01f29d882a1
    fslw s8,s4,s1,a7
    sd s8,32(a1)
    li a3, 0x0000000000000000
    li s9, 0x6198b4fc2ba53005
    li t0, 0x33f7912ab208965f
    fslw s3,a3,s9,t0
    sd s3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
