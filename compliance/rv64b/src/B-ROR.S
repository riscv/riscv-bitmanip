#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s8, 0xf0774453522a1063
    li a0, 0xb370bd7dd2d6b642
    ror a6,s8,a0
    sd a6,0(a1)
    li t3, 0xedd116c18a671b8c
    li a2, 0x6f94f8db5b4289cf
    ror t0,t3,a2
    sd t0,8(a1)
    li s7, 0x8130cd0d02eb0801
    li s4, 0x36ecfc1781920806
    ror s5,s7,s4
    sd s5,16(a1)
    li t0, 0x1f9f61e943737b61
    li s4, 0xb320deb657861f11
    ror a4,t0,s4
    sd a4,24(a1)
    li t0, 0x915695b3f20d8a82
    li s8, 0xbda8a08e1ceb0c11
    ror a5,t0,s8
    sd a5,32(a1)
    li s9, 0x925c6cb79543c51a
    li t4, 0xe79ad1779a48a02c
    ror s7,s9,t4
    sd s7,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
