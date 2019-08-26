#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t3, 0xf0774453522a1063
    li s10, 0xb370bd7dd2d6b642
    srow a7,t3,s10
    sd a7,0(a1)
    li t6, 0xedd116c18a671b8c
    li s6, 0x6f94f8db5b4289cf
    srow s5,t6,s6
    sd s5,8(a1)
    li s6, 0x8130cd0d02eb0801
    li t2, 0x36ecfc1781920806
    srow t0,s6,t2
    sd t0,16(a1)
    li s11, 0x1f9f61e943737b61
    li s10, 0xb320deb657861f11
    srow a3,s11,s10
    sd a3,24(a1)
    li t2, 0x915695b3f20d8a82
    li a0, 0xbda8a08e1ceb0c11
    srow s10,t2,a0
    sd s10,32(a1)
    li s2, 0x925c6cb79543c51a
    li a6, 0xe79ad1779a48a02c
    srow t3,s2,a6
    sd t3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
