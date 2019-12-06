#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s6, 0xf0774453522a1063
    li t1, 0xb370bd7dd2d6b642
    clmulr s9,s6,t1
    sd s9,0(a1)
    li s4, 0xedd116c18a671b8c
    li a6, 0x6f94f8db5b4289cf
    clmulr s1,s4,a6
    sd s1,8(a1)
    li t5, 0x8130cd0d02eb0801
    li a5, 0x36ecfc1781920806
    clmulr s11,t5,a5
    sd s11,16(a1)
    li a7, 0x1f9f61e943737b61
    li a2, 0xb320deb657861f11
    clmulr t4,a7,a2
    sd t4,24(a1)
    li s6, 0x915695b3f20d8a82
    li a6, 0xbda8a08e1ceb0c11
    clmulr a5,s6,a6
    sd a5,32(a1)
    li s2, 0x925c6cb79543c51a
    li s6, 0xe79ad1779a48a02c
    clmulr a0,s2,s6
    sd a0,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
