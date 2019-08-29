#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t5, 0xf38e07165dd79cfa
    li t4, 0xf2f25a0bc4ed4893
    li a5, 0x72c8a75d987a10dd
    fslw s6,t5,t4,a5
    sd s6,0(a1)
    li s8, 0x25f269ba9c6f7aa2
    li s3, 0x11fe7c5ffcae8655
    li a3, 0x3ee8d76702a2826c
    fslw t5,s8,s3,a3
    sd t5,8(a1)
    li s0, 0xe6b16607a8a22391
    li s8, 0xb4ea93d41b4286dd
    li t0, 0x682ae2c6988c0022
    fslw t3,s0,s8,t0
    sd t3,16(a1)
    li s4, 0xb6213a3c430b3272
    li a2, 0xd1ced3e82b77485c
    li t5, 0xfde0bbd38b8e8f3e
    fslw t3,s4,a2,t5
    sd t3,24(a1)
    li t4, 0xf0190cecadd85909
    li a5, 0x38b5a7ff116023b7
    li s2, 0x0557f01f29d882a1
    fslw t6,t4,a5,s2
    sd t6,32(a1)
    li a2, 0x0000000000000000
    li s5, 0x6198b4fc2ba53005
    li s8, 0x33f7912ab208965f
    fslw t0,a2,s5,s8
    sd t0,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
