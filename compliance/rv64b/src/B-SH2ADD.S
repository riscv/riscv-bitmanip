#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s7, 0xf0774453522a1063
    li s6, 0xb370bd7dd2d6b642
    sh2add s0,s7,s6
    sd s0,0(a1)
    li a0, 0xedd116c18a671b8c
    li t1, 0x6f94f8db5b4289cf
    sh2add t0,a0,t1
    sd t0,8(a1)
    li s10, 0x8130cd0d02eb0801
    li t0, 0x36ecfc1781920806
    sh2add s4,s10,t0
    sd s4,16(a1)
    li t2, 0x1f9f61e943737b61
    li t5, 0xb320deb657861f11
    sh2add t1,t2,t5
    sd t1,24(a1)
    li t0, 0x915695b3f20d8a82
    li s1, 0xbda8a08e1ceb0c11
    sh2add s0,t0,s1
    sd s0,32(a1)
    li a7, 0x925c6cb79543c51a
    li s2, 0xe79ad1779a48a02c
    sh2add s5,a7,s2
    sd s5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
