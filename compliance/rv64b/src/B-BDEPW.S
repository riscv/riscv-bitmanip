#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a6, 0xf0774453522a1063
    li t3, 0xb370bd7dd2d6b642
    bdepw a3,a6,t3
    sd a3,0(a1)
    li s11, 0xedd116c18a671b8c
    li s2, 0x6f94f8db5b4289cf
    bdepw s5,s11,s2
    sd s5,8(a1)
    li s2, 0x8130cd0d02eb0801
    li s5, 0x36ecfc1781920806
    bdepw t1,s2,s5
    sd t1,16(a1)
    li s4, 0x1f9f61e943737b61
    li a3, 0xb320deb657861f11
    bdepw t2,s4,a3
    sd t2,24(a1)
    li s4, 0x915695b3f20d8a82
    li s0, 0xbda8a08e1ceb0c11
    bdepw a3,s4,s0
    sd a3,32(a1)
    li s0, 0x925c6cb79543c51a
    li t4, 0xe79ad1779a48a02c
    bdepw a2,s0,t4
    sd a2,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
