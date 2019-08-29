#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s10, 0xf38e07165dd79cfa
    li s11, 0xf2f25a0bc4ed4893
    fsriw s4,s10,s11,3
    sd s4,0(a1)
    li t2, 0x25f269ba9c6f7aa2
    li a6, 0x11fe7c5ffcae8655
    fsriw t1,t2,a6,5
    sd t1,8(a1)
    li t5, 0xe6b16607a8a22391
    li s7, 0xb4ea93d41b4286dd
    fsriw s11,t5,s7,17
    sd s11,16(a1)
    li s5, 0xb6213a3c430b3272
    li t1, 0xd1ced3e82b77485c
    fsriw a4,s5,t1,24
    sd a4,24(a1)
    li s7, 0xf0190cecadd85909
    li s9, 0x38b5a7ff116023b7
    fsriw s5,s7,s9,25
    sd s5,32(a1)
    li a2, 0x66f7d0bc81c0d967
    li a7, 0x6198b4fc2ba53005
    fsriw s4,a2,a7,31
    sd s4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
