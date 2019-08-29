#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t0, 0xf0774453522a1063
    li s9, 0xb370bd7dd2d6b642
    bext a3,t0,s9
    sd a3,0(a1)
    li s5, 0xedd116c18a671b8c
    li s11, 0x6f94f8db5b4289cf
    bext t3,s5,s11
    sd t3,8(a1)
    li t1, 0x8130cd0d02eb0801
    li a0, 0x36ecfc1781920806
    bext t2,t1,a0
    sd t2,16(a1)
    li s6, 0x1f9f61e943737b61
    li s4, 0xb320deb657861f11
    bext t6,s6,s4
    sd t6,24(a1)
    li s2, 0x915695b3f20d8a82
    li s0, 0xbda8a08e1ceb0c11
    bext t5,s2,s0
    sd t5,32(a1)
    li t6, 0x925c6cb79543c51a
    li s5, 0xe79ad1779a48a02c
    bext t2,t6,s5
    sd t2,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
