#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s7, 0xf0774453522a1063
    li s4, 0xb370bd7dd2d6b642
    unshflw s5,s7,s4
    sd s5,0(a1)
    li s11, 0xedd116c18a671b8c
    li t0, 0x6f94f8db5b4289cf
    unshflw s5,s11,t0
    sd s5,8(a1)
    li s8, 0x8130cd0d02eb0801
    li s5, 0x36ecfc1781920806
    unshflw s4,s8,s5
    sd s4,16(a1)
    li s10, 0x1f9f61e943737b61
    li a2, 0xb320deb657861f11
    unshflw s7,s10,a2
    sd s7,24(a1)
    li s1, 0x915695b3f20d8a82
    li s0, 0xbda8a08e1ceb0c11
    unshflw s3,s1,s0
    sd s3,32(a1)
    li s5, 0x925c6cb79543c51a
    li s1, 0xe79ad1779a48a02c
    unshflw s9,s5,s1
    sd s9,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
