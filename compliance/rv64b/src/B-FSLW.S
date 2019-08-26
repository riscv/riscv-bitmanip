#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t5, 0xf38e07165dd79cfa
    li s11, 0xf2f25a0bc4ed4893
    li t0, 0x72c8a75d987a10dd
    fslw a3,t5,s11,t0
    sd a3,0(a1)
    li a3, 0x25f269ba9c6f7aa2
    li s0, 0x11fe7c5ffcae8655
    li t2, 0x3ee8d76702a2826c
    fslw t3,a3,s0,t2
    sd t3,8(a1)
    li s1, 0xe6b16607a8a22391
    li s2, 0xb4ea93d41b4286dd
    li a2, 0x682ae2c6988c0022
    fslw s8,s1,s2,a2
    sd s8,16(a1)
    li t0, 0xb6213a3c430b3272
    li t4, 0xd1ced3e82b77485c
    li s8, 0xfde0bbd38b8e8f3e
    fslw t1,t0,t4,s8
    sd t1,24(a1)
    li s9, 0xf0190cecadd85909
    li a2, 0x38b5a7ff116023b7
    li s8, 0x0557f01f29d882a1
    fslw a7,s9,a2,s8
    sd a7,32(a1)
    li s4, 0x0000000000000000
    li t1, 0x6198b4fc2ba53005
    li t2, 0x33f7912ab208965f
    fslw t4,s4,t1,t2
    sd t4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
