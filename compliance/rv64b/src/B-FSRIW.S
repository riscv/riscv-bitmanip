#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s4, 0xf38e07165dd79cfa
    li t3, 0xf2f25a0bc4ed4893
    fsriw t1,s4,t3,3
    sd t1,0(a1)
    li a6, 0x25f269ba9c6f7aa2
    li t6, 0x11fe7c5ffcae8655
    fsriw a0,a6,t6,5
    sd a0,8(a1)
    li t4, 0xe6b16607a8a22391
    li s5, 0xb4ea93d41b4286dd
    fsriw a6,t4,s5,17
    sd a6,16(a1)
    li t0, 0xb6213a3c430b3272
    li t6, 0xd1ced3e82b77485c
    fsriw s5,t0,t6,24
    sd s5,24(a1)
    li s0, 0xf0190cecadd85909
    li a2, 0x38b5a7ff116023b7
    fsriw s8,s0,a2,25
    sd s8,32(a1)
    li s4, 0x66f7d0bc81c0d967
    li t4, 0x6198b4fc2ba53005
    fsriw a4,s4,t4,31
    sd a4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
