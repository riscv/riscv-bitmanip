#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s2, 0xf0774453522a1063
    li s0, 0xb370bd7dd2d6b642
    bmator t0,s2,s0
    sd t0,0(a1)
    li a2, 0xedd116c18a671b8c
    li s10, 0x6f94f8db5b4289cf
    bmator s2,a2,s10
    sd s2,8(a1)
    li a3, 0x8130cd0d02eb0801
    li a6, 0x36ecfc1781920806
    bmator s5,a3,a6
    sd s5,16(a1)
    li t3, 0x1f9f61e943737b61
    li t5, 0xb320deb657861f11
    bmator s2,t3,t5
    sd s2,24(a1)
    li t1, 0x915695b3f20d8a82
    li s11, 0xbda8a08e1ceb0c11
    bmator a4,t1,s11
    sd a4,32(a1)
    li s6, 0x925c6cb79543c51a
    li t1, 0xe79ad1779a48a02c
    bmator s9,s6,t1
    sd s9,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
