#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a0, 0xf0774453522a1063
    li t4, 0xb370bd7dd2d6b642
    rorw t5,a0,t4
    sd t5,0(a1)
    li t1, 0xedd116c18a671b8c
    li s1, 0x6f94f8db5b4289cf
    rorw a5,t1,s1
    sd a5,8(a1)
    li s0, 0x8130cd0d02eb0801
    li s6, 0x36ecfc1781920806
    rorw t1,s0,s6
    sd t1,16(a1)
    li s1, 0x1f9f61e943737b61
    li s8, 0xb320deb657861f11
    rorw s2,s1,s8
    sd s2,24(a1)
    li t6, 0x915695b3f20d8a82
    li s8, 0xbda8a08e1ceb0c11
    rorw a2,t6,s8
    sd a2,32(a1)
    li t2, 0x925c6cb79543c51a
    li s8, 0xe79ad1779a48a02c
    rorw a4,t2,s8
    sd a4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
