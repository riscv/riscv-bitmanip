#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s1, 0xf38e07165dd79cfa
    li s3, 0xf2f25a0bc4ed4893
    li a3, 0x72c8a75d987a10dd
    fsrw t1,s1,s3,a3
    sd t1,0(a1)
    li t3, 0x25f269ba9c6f7aa2
    li a4, 0x11fe7c5ffcae8655
    li s7, 0x3ee8d76702a2826c
    fsrw s3,t3,a4,s7
    sd s3,8(a1)
    li t0, 0xe6b16607a8a22391
    li a2, 0xb4ea93d41b4286dd
    li s6, 0x682ae2c6988c0022
    fsrw a3,t0,a2,s6
    sd a3,16(a1)
    li t1, 0xb6213a3c430b3272
    li s11, 0xd1ced3e82b77485c
    li s2, 0xfde0bbd38b8e8f3e
    fsrw s9,t1,s11,s2
    sd s9,24(a1)
    li s9, 0xf0190cecadd85909
    li a7, 0x38b5a7ff116023b7
    li t0, 0x0557f01f29d882a1
    fsrw s6,s9,a7,t0
    sd s6,32(a1)
    li a3, 0x0000000000000000
    li s3, 0x6198b4fc2ba53005
    li t1, 0x33f7912ab208965f
    fsrw a7,a3,s3,t1
    sd a7,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
