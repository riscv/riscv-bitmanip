#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s0, 0xf0774453522a1063
    li a0, 0xb370bd7dd2d6b642
    clmulr a3,s0,a0
    sd a3,0(a1)
    li s7, 0xedd116c18a671b8c
    li s6, 0x6f94f8db5b4289cf
    clmulr t1,s7,s6
    sd t1,8(a1)
    li t6, 0x8130cd0d02eb0801
    li s6, 0x36ecfc1781920806
    clmulr s5,t6,s6
    sd s5,16(a1)
    li s10, 0x1f9f61e943737b61
    li t2, 0xb320deb657861f11
    clmulr t1,s10,t2
    sd t1,24(a1)
    li s10, 0x915695b3f20d8a82
    li a2, 0xbda8a08e1ceb0c11
    clmulr s7,s10,a2
    sd s7,32(a1)
    li a2, 0x925c6cb79543c51a
    li a3, 0xe79ad1779a48a02c
    clmulr a7,a2,a3
    sd a7,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
