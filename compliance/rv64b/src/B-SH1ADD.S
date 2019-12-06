#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a0, 0xf0774453522a1063
    li s2, 0xb370bd7dd2d6b642
    sh1add s7,a0,s2
    sd s7,0(a1)
    li s5, 0xedd116c18a671b8c
    li t1, 0x6f94f8db5b4289cf
    sh1add a0,s5,t1
    sd a0,8(a1)
    li a2, 0x8130cd0d02eb0801
    li s10, 0x36ecfc1781920806
    sh1add s1,a2,s10
    sd s1,16(a1)
    li s4, 0x1f9f61e943737b61
    li t0, 0xb320deb657861f11
    sh1add a7,s4,t0
    sd a7,24(a1)
    li t2, 0x915695b3f20d8a82
    li a7, 0xbda8a08e1ceb0c11
    sh1add s1,t2,a7
    sd s1,32(a1)
    li t6, 0x925c6cb79543c51a
    li s9, 0xe79ad1779a48a02c
    sh1add t2,t6,s9
    sd t2,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
