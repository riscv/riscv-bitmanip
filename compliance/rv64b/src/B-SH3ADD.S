#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s10, 0xf0774453522a1063
    li s1, 0xb370bd7dd2d6b642
    sh3add a5,s10,s1
    sd a5,0(a1)
    li a0, 0xedd116c18a671b8c
    li t0, 0x6f94f8db5b4289cf
    sh3add t3,a0,t0
    sd t3,8(a1)
    li s4, 0x8130cd0d02eb0801
    li s1, 0x36ecfc1781920806
    sh3add t2,s4,s1
    sd t2,16(a1)
    li t3, 0x1f9f61e943737b61
    li t5, 0xb320deb657861f11
    sh3add a0,t3,t5
    sd a0,24(a1)
    li s4, 0x915695b3f20d8a82
    li a2, 0xbda8a08e1ceb0c11
    sh3add s9,s4,a2
    sd s9,32(a1)
    li a7, 0x925c6cb79543c51a
    li s7, 0xe79ad1779a48a02c
    sh3add s5,a7,s7
    sd s5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
