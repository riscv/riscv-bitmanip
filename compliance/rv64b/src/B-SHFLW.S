#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s2, 0xf0774453522a1063
    li s0, 0xb370bd7dd2d6b642
    shflw t5,s2,s0
    sd t5,0(a1)
    li t2, 0xedd116c18a671b8c
    li t3, 0x6f94f8db5b4289cf
    shflw s6,t2,t3
    sd s6,8(a1)
    li a6, 0x8130cd0d02eb0801
    li t5, 0x36ecfc1781920806
    shflw s4,a6,t5
    sd s4,16(a1)
    li a7, 0x1f9f61e943737b61
    li a2, 0xb320deb657861f11
    shflw t4,a7,a2
    sd t4,24(a1)
    li s0, 0x915695b3f20d8a82
    li s4, 0xbda8a08e1ceb0c11
    shflw s2,s0,s4
    sd s2,32(a1)
    li a7, 0x925c6cb79543c51a
    li a2, 0xe79ad1779a48a02c
    shflw s8,a7,a2
    sd s8,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
