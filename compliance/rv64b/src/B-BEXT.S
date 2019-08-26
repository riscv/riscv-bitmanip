#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s11, 0xf0774453522a1063
    li a4, 0xb370bd7dd2d6b642
    bext s1,s11,a4
    sd s1,0(a1)
    li a2, 0xedd116c18a671b8c
    li s0, 0x6f94f8db5b4289cf
    bext t0,a2,s0
    sd t0,8(a1)
    li s3, 0x8130cd0d02eb0801
    li t5, 0x36ecfc1781920806
    bext s5,s3,t5
    sd s5,16(a1)
    li t2, 0x1f9f61e943737b61
    li a7, 0xb320deb657861f11
    bext t3,t2,a7
    sd t3,24(a1)
    li t5, 0x915695b3f20d8a82
    li s10, 0xbda8a08e1ceb0c11
    bext s4,t5,s10
    sd s4,32(a1)
    li s6, 0x925c6cb79543c51a
    li t2, 0xe79ad1779a48a02c
    bext a2,s6,t2
    sd a2,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
