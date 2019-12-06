#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t6, 0xf38e07165dd79cfa
    li s4, 0xf2f25a0bc4ed4893
    fsri s9,t6,s4,3
    sd s9,0(a1)
    li s9, 0x25f269ba9c6f7aa2
    li s6, 0x11fe7c5ffcae8655
    fsri a2,s9,s6,15
    sd a2,8(a1)
    li t1, 0xe6b16607a8a22391
    li a4, 0xb4ea93d41b4286dd
    fsri t5,t1,a4,27
    sd t5,16(a1)
    li s2, 0xb6213a3c430b3272
    li s4, 0xd1ced3e82b77485c
    fsri t4,s2,s4,42
    sd t4,24(a1)
    li s4, 0xf0190cecadd85909
    li a5, 0x38b5a7ff116023b7
    fsri t5,s4,a5,59
    sd t5,32(a1)
    li a3, 0x66f7d0bc81c0d967
    li t6, 0x6198b4fc2ba53005
    fsri s9,a3,t6,62
    sd s9,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
