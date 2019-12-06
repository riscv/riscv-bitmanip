#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a3, 0xf0774453522a1063
    li s6, 0xb370bd7dd2d6b642
    sro s0,a3,s6
    sd s0,0(a1)
    li s5, 0xedd116c18a671b8c
    li a2, 0x6f94f8db5b4289cf
    sro a5,s5,a2
    sd a5,8(a1)
    li t2, 0x8130cd0d02eb0801
    li t3, 0x36ecfc1781920806
    sro s6,t2,t3
    sd s6,16(a1)
    li s6, 0x1f9f61e943737b61
    li t3, 0xb320deb657861f11
    sro s4,s6,t3
    sd s4,24(a1)
    li a6, 0x915695b3f20d8a82
    li t1, 0xbda8a08e1ceb0c11
    sro s9,a6,t1
    sd s9,32(a1)
    li s7, 0x925c6cb79543c51a
    li s4, 0xe79ad1779a48a02c
    sro s2,s7,s4
    sd s2,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
