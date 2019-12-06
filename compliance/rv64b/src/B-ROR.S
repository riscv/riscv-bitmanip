#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s6, 0xf0774453522a1063
    li s4, 0xb370bd7dd2d6b642
    ror t6,s6,s4
    sd t6,0(a1)
    li s2, 0xedd116c18a671b8c
    li s0, 0x6f94f8db5b4289cf
    ror t5,s2,s0
    sd t5,8(a1)
    li t6, 0x8130cd0d02eb0801
    li s5, 0x36ecfc1781920806
    ror t2,t6,s5
    sd t2,16(a1)
    li t4, 0x1f9f61e943737b61
    li s7, 0xb320deb657861f11
    ror a0,t4,s7
    sd a0,24(a1)
    li s2, 0x915695b3f20d8a82
    li t4, 0xbda8a08e1ceb0c11
    ror a2,s2,t4
    sd a2,32(a1)
    li s2, 0x925c6cb79543c51a
    li a6, 0xe79ad1779a48a02c
    ror t3,s2,a6
    sd t3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
