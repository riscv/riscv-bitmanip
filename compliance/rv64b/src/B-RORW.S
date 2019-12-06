#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s3, 0xf0774453522a1063
    li t1, 0xb370bd7dd2d6b642
    rorw s7,s3,t1
    sd s7,0(a1)
    li s0, 0xedd116c18a671b8c
    li a4, 0x6f94f8db5b4289cf
    rorw a2,s0,a4
    sd a2,8(a1)
    li s6, 0x8130cd0d02eb0801
    li t5, 0x36ecfc1781920806
    rorw s2,s6,t5
    sd s2,16(a1)
    li s8, 0x1f9f61e943737b61
    li s5, 0xb320deb657861f11
    rorw t0,s8,s5
    sd t0,24(a1)
    li t0, 0x915695b3f20d8a82
    li t2, 0xbda8a08e1ceb0c11
    rorw s9,t0,t2
    sd s9,32(a1)
    li s5, 0x925c6cb79543c51a
    li s8, 0xe79ad1779a48a02c
    rorw t1,s5,s8
    sd t1,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
