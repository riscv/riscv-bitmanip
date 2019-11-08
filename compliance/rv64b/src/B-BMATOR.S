#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a6, 0xf0774453522a1063
    li t0, 0xb370bd7dd2d6b642
    bmator a0,a6,t0
    sd a0,0(a1)
    li a4, 0xedd116c18a671b8c
    li a7, 0x6f94f8db5b4289cf
    bmator t6,a4,a7
    sd t6,8(a1)
    li a7, 0x8130cd0d02eb0801
    li s5, 0x36ecfc1781920806
    bmator a3,a7,s5
    sd a3,16(a1)
    li a6, 0x1f9f61e943737b61
    li t5, 0xb320deb657861f11
    bmator s4,a6,t5
    sd s4,24(a1)
    li a7, 0x915695b3f20d8a82
    li a4, 0xbda8a08e1ceb0c11
    bmator t5,a7,a4
    sd t5,32(a1)
    li a2, 0x925c6cb79543c51a
    li s6, 0xe79ad1779a48a02c
    bmator a0,a2,s6
    sd a0,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
