#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a7, 0xf38e07165dd79cfa
    li a6, 0xf2f25a0bc4ed4893
    fsri s1,a7,a6,3
    sd s1,0(a1)
    li a0, 0x25f269ba9c6f7aa2
    li s9, 0x11fe7c5ffcae8655
    fsri a7,a0,s9,15
    sd a7,8(a1)
    li s9, 0xe6b16607a8a22391
    li s3, 0xb4ea93d41b4286dd
    fsri a4,s9,s3,27
    sd a4,16(a1)
    li t0, 0xb6213a3c430b3272
    li t6, 0xd1ced3e82b77485c
    fsri s0,t0,t6,42
    sd s0,24(a1)
    li a5, 0xf0190cecadd85909
    li t1, 0x38b5a7ff116023b7
    fsri a7,a5,t1,59
    sd a7,32(a1)
    li a6, 0x66f7d0bc81c0d967
    li s11, 0x6198b4fc2ba53005
    fsri a3,a6,s11,62
    sd a3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
