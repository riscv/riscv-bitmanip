#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t5, 0xf0774453522a1063
    li a5, 0xb370bd7dd2d6b642
    slow s11,t5,a5
    sd s11,0(a1)
    li s10, 0xedd116c18a671b8c
    li s5, 0x6f94f8db5b4289cf
    slow a5,s10,s5
    sd a5,8(a1)
    li a0, 0x8130cd0d02eb0801
    li t1, 0x36ecfc1781920806
    slow a6,a0,t1
    sd a6,16(a1)
    li a0, 0x1f9f61e943737b61
    li t4, 0xb320deb657861f11
    slow t5,a0,t4
    sd t5,24(a1)
    li t1, 0x915695b3f20d8a82
    li s1, 0xbda8a08e1ceb0c11
    slow a5,t1,s1
    sd a5,32(a1)
    li s0, 0x925c6cb79543c51a
    li s6, 0xe79ad1779a48a02c
    slow t1,s0,s6
    sd t1,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
