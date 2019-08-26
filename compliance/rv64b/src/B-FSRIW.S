#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s11, 0xf38e07165dd79cfa
    li a4, 0xf2f25a0bc4ed4893
    fsriw s1,s11,a4,3
    sd s1,0(a1)
    li a7, 0x25f269ba9c6f7aa2
    li t2, 0x11fe7c5ffcae8655
    fsriw s10,a7,t2,5
    sd s10,8(a1)
    li t2, 0xe6b16607a8a22391
    li a4, 0xb4ea93d41b4286dd
    fsriw s5,t2,a4,17
    sd s5,16(a1)
    li t2, 0xb6213a3c430b3272
    li a5, 0xd1ced3e82b77485c
    fsriw s4,t2,a5,24
    sd s4,24(a1)
    li s1, 0xf0190cecadd85909
    li t6, 0x38b5a7ff116023b7
    fsriw t2,s1,t6,25
    sd t2,32(a1)
    li s9, 0x66f7d0bc81c0d967
    li a3, 0x6198b4fc2ba53005
    fsriw s11,s9,a3,31
    sd s11,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
