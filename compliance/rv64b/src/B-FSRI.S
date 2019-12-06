#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t5, 0xf38e07165dd79cfa
    li s5, 0xf2f25a0bc4ed4893
    fsri a6,t5,s5,3
    sd a6,0(a1)
    li s7, 0x25f269ba9c6f7aa2
    li s0, 0x11fe7c5ffcae8655
    fsri a4,s7,s0,15
    sd a4,8(a1)
    li t2, 0xe6b16607a8a22391
    li s8, 0xb4ea93d41b4286dd
    fsri s3,t2,s8,27
    sd s3,16(a1)
    li a5, 0xb6213a3c430b3272
    li s0, 0xd1ced3e82b77485c
    fsri a7,a5,s0,42
    sd a7,24(a1)
    li s6, 0xf0190cecadd85909
    li s0, 0x38b5a7ff116023b7
    fsri a6,s6,s0,59
    sd a6,32(a1)
    li s7, 0x66f7d0bc81c0d967
    li s2, 0x6198b4fc2ba53005
    fsri a2,s7,s2,62
    sd a2,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
