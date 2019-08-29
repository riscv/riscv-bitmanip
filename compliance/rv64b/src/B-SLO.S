#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a2, 0xf0774453522a1063
    li s10, 0xb370bd7dd2d6b642
    slo s2,a2,s10
    sd s2,0(a1)
    li a3, 0xedd116c18a671b8c
    li a6, 0x6f94f8db5b4289cf
    slo s5,a3,a6
    sd s5,8(a1)
    li t3, 0x8130cd0d02eb0801
    li t5, 0x36ecfc1781920806
    slo s2,t3,t5
    sd s2,16(a1)
    li t1, 0x1f9f61e943737b61
    li s11, 0xb320deb657861f11
    slo a4,t1,s11
    sd a4,24(a1)
    li s6, 0x915695b3f20d8a82
    li t1, 0xbda8a08e1ceb0c11
    slo s9,s6,t1
    sd s9,32(a1)
    li s4, 0x925c6cb79543c51a
    li a6, 0xe79ad1779a48a02c
    slo s1,s4,a6
    sd s1,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
