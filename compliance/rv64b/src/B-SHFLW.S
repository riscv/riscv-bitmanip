#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s6, 0xf0774453522a1063
    li t3, 0xb370bd7dd2d6b642
    shflw s4,s6,t3
    sd s4,0(a1)
    li a7, 0xedd116c18a671b8c
    li a4, 0x6f94f8db5b4289cf
    shflw t5,a7,a4
    sd t5,8(a1)
    li s6, 0x8130cd0d02eb0801
    li a6, 0x36ecfc1781920806
    shflw a5,s6,a6
    sd a5,16(a1)
    li t4, 0x1f9f61e943737b61
    li t3, 0xb320deb657861f11
    shflw a5,t4,t3
    sd a5,24(a1)
    li a0, 0x915695b3f20d8a82
    li s11, 0xbda8a08e1ceb0c11
    shflw s9,a0,s11
    sd s9,32(a1)
    li a6, 0x925c6cb79543c51a
    li t4, 0xe79ad1779a48a02c
    shflw s1,a6,t4
    sd s1,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
