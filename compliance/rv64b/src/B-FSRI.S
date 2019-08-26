#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a3, 0xf38e07165dd79cfa
    li t6, 0xf2f25a0bc4ed4893
    fsri t4,a3,t6,3
    sd t4,0(a1)
    li t3, 0x25f269ba9c6f7aa2
    li t0, 0x11fe7c5ffcae8655
    fsri s10,t3,t0,15
    sd s10,8(a1)
    li s8, 0xe6b16607a8a22391
    li a0, 0xb4ea93d41b4286dd
    fsri s10,s8,a0,27
    sd s10,16(a1)
    li s0, 0xb6213a3c430b3272
    li s2, 0xd1ced3e82b77485c
    fsri s4,s0,s2,42
    sd s4,24(a1)
    li s7, 0xf0190cecadd85909
    li a4, 0x38b5a7ff116023b7
    fsri t0,s7,a4,59
    sd t0,32(a1)
    li a5, 0x66f7d0bc81c0d967
    li t3, 0x6198b4fc2ba53005
    fsri s5,a5,t3,62
    sd s5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
