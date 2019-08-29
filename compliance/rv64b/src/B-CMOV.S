#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s0, 0xf38e07165dd79cfa
    li s2, 0xf2f25a0bc4ed4893
    li t0, 0x72c8a75d987a10dd
    cmov s4,s0,s2,t0
    sd s4,0(a1)
    li a7, 0x25f269ba9c6f7aa2
    li t2, 0x11fe7c5ffcae8655
    li s2, 0x3ee8d76702a2826c
    cmov s10,a7,t2,s2
    sd s10,8(a1)
    li s9, 0xe6b16607a8a22391
    li a3, 0xb4ea93d41b4286dd
    li s5, 0x682ae2c6988c0022
    cmov s11,s9,a3,s5
    sd s11,16(a1)
    li t3, 0xb6213a3c430b3272
    li t4, 0xd1ced3e82b77485c
    li a3, 0xfde0bbd38b8e8f3e
    cmov s11,t3,t4,a3
    sd s11,24(a1)
    li s6, 0xf0190cecadd85909
    li s10, 0x38b5a7ff116023b7
    li a2, 0x0557f01f29d882a1
    cmov s0,s6,s10,a2
    sd s0,32(a1)
    li a0, 0x0000000000000000
    li s1, 0x6198b4fc2ba53005
    li s7, 0x33f7912ab208965f
    cmov s6,a0,s1,s7
    sd s6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
