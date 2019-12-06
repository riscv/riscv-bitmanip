#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s10, 0xf38e07165dd79cfa
    li s5, 0xf2f25a0bc4ed4893
    li s1, 0x72c8a75d987a10dd
    fsrw s0,s10,s5,s1
    sd s0,0(a1)
    li s1, 0x25f269ba9c6f7aa2
    li s0, 0x11fe7c5ffcae8655
    li t4, 0x3ee8d76702a2826c
    fsrw s10,s1,s0,t4
    sd s10,8(a1)
    li s9, 0xe6b16607a8a22391
    li a2, 0xb4ea93d41b4286dd
    li s2, 0x682ae2c6988c0022
    fsrw t5,s9,a2,s2
    sd t5,16(a1)
    li a4, 0xb6213a3c430b3272
    li a2, 0xd1ced3e82b77485c
    li t0, 0xfde0bbd38b8e8f3e
    fsrw s11,a4,a2,t0
    sd s11,24(a1)
    li s0, 0xf0190cecadd85909
    li s4, 0x38b5a7ff116023b7
    li s8, 0x0557f01f29d882a1
    fsrw s11,s0,s4,s8
    sd s11,32(a1)
    li a6, 0x0000000000000000
    li a3, 0x6198b4fc2ba53005
    li t6, 0x33f7912ab208965f
    fsrw s6,a6,a3,t6
    sd s6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
