#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a0, 0xf0774453522a1063
    li s11, 0xb370bd7dd2d6b642
    clmulw t4,a0,s11
    sd t4,0(a1)
    li a6, 0xedd116c18a671b8c
    li t3, 0x6f94f8db5b4289cf
    clmulw a3,a6,t3
    sd a3,8(a1)
    li s11, 0x8130cd0d02eb0801
    li s2, 0x36ecfc1781920806
    clmulw s5,s11,s2
    sd s5,16(a1)
    li s2, 0x1f9f61e943737b61
    li s5, 0xb320deb657861f11
    clmulw t1,s2,s5
    sd t1,24(a1)
    li s4, 0x915695b3f20d8a82
    li a3, 0xbda8a08e1ceb0c11
    clmulw t2,s4,a3
    sd t2,32(a1)
    li s4, 0x925c6cb79543c51a
    li s0, 0xe79ad1779a48a02c
    clmulw a3,s4,s0
    sd a3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
