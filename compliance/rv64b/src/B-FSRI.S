#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t5, 0xf38e07165dd79cfa
    li a6, 0xf2f25a0bc4ed4893
    fsri s9,t5,a6,3
    sd s9,0(a1)
    li s10, 0x25f269ba9c6f7aa2
    li s5, 0x11fe7c5ffcae8655
    fsri s0,s10,s5,15
    sd s0,8(a1)
    li t6, 0xe6b16607a8a22391
    li a7, 0xb4ea93d41b4286dd
    fsri s3,t6,a7,27
    sd s3,16(a1)
    li s1, 0xb6213a3c430b3272
    li s0, 0xd1ced3e82b77485c
    fsri s10,s1,s0,42
    sd s10,24(a1)
    li s5, 0xf0190cecadd85909
    li t6, 0x38b5a7ff116023b7
    fsri a0,s5,t6,59
    sd a0,32(a1)
    li s9, 0x66f7d0bc81c0d967
    li a2, 0x6198b4fc2ba53005
    fsri t5,s9,a2,62
    sd t5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
