#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a2, 0xf0774453522a1063
    li a0, 0xb370bd7dd2d6b642
    bdepw s1,a2,a0
    sd s1,0(a1)
    li t0, 0xedd116c18a671b8c
    li s4, 0x6f94f8db5b4289cf
    bdepw a4,t0,s4
    sd a4,8(a1)
    li s4, 0x8130cd0d02eb0801
    li a3, 0x36ecfc1781920806
    bdepw t0,s4,a3
    sd t0,16(a1)
    li s2, 0x1f9f61e943737b61
    li a7, 0xb320deb657861f11
    bdepw s8,s2,a7
    sd s8,24(a1)
    li a2, 0x915695b3f20d8a82
    li a3, 0xbda8a08e1ceb0c11
    bdepw a7,a2,a3
    sd a7,32(a1)
    li a0, 0x925c6cb79543c51a
    li s11, 0xe79ad1779a48a02c
    bdepw t4,a0,s11
    sd t4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
