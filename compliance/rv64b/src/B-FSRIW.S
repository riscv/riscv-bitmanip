#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t5, 0xf38e07165dd79cfa
    li t2, 0xf2f25a0bc4ed4893
    fsriw s6,t5,t2,3
    sd s6,0(a1)
    li s10, 0x25f269ba9c6f7aa2
    li s6, 0x11fe7c5ffcae8655
    fsriw a7,s10,s6,5
    sd a7,8(a1)
    li s10, 0xe6b16607a8a22391
    li a5, 0xb4ea93d41b4286dd
    fsriw s6,s10,a5,17
    sd s6,16(a1)
    li a3, 0xb6213a3c430b3272
    li t3, 0xd1ced3e82b77485c
    fsriw a4,a3,t3,24
    sd a4,24(a1)
    li s6, 0xf0190cecadd85909
    li s4, 0x38b5a7ff116023b7
    fsriw s5,s6,s4,25
    sd s5,32(a1)
    li t0, 0x66f7d0bc81c0d967
    li a0, 0x6198b4fc2ba53005
    fsriw t5,t0,a0,31
    sd t5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
