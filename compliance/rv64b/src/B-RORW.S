#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s8, 0xf0774453522a1063
    li s5, 0xb370bd7dd2d6b642
    rorw s4,s8,s5
    sd s4,0(a1)
    li s10, 0xedd116c18a671b8c
    li a2, 0x6f94f8db5b4289cf
    rorw s7,s10,a2
    sd s7,8(a1)
    li s1, 0x8130cd0d02eb0801
    li s0, 0x36ecfc1781920806
    rorw s3,s1,s0
    sd s3,16(a1)
    li s5, 0x1f9f61e943737b61
    li s1, 0xb320deb657861f11
    rorw s9,s5,s1
    sd s9,24(a1)
    li t4, 0x915695b3f20d8a82
    li s5, 0xbda8a08e1ceb0c11
    rorw t1,t4,s5
    sd t1,32(a1)
    li a6, 0x925c6cb79543c51a
    li t2, 0xe79ad1779a48a02c
    rorw a7,a6,t2
    sd a7,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
