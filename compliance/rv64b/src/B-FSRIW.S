#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t4, 0xf38e07165dd79cfa
    li a7, 0xf2f25a0bc4ed4893
    fsriw s2,t4,a7,3
    sd s2,0(a1)
    li a4, 0x25f269ba9c6f7aa2
    li a2, 0x11fe7c5ffcae8655
    fsriw s11,a4,a2,5
    sd s11,8(a1)
    li s4, 0xe6b16607a8a22391
    li s1, 0xb4ea93d41b4286dd
    fsriw s8,s4,s1,17
    sd s8,16(a1)
    li s0, 0xb6213a3c430b3272
    li s4, 0xd1ced3e82b77485c
    fsriw s11,s0,s4,24
    sd s11,24(a1)
    li a3, 0xf0190cecadd85909
    li s9, 0x38b5a7ff116023b7
    fsriw s3,a3,s9,25
    sd s3,32(a1)
    li a6, 0x66f7d0bc81c0d967
    li a3, 0x6198b4fc2ba53005
    fsriw s6,a6,a3,31
    sd s6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
