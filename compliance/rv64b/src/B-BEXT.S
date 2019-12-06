#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a4, 0xf0774453522a1063
    li s2, 0xb370bd7dd2d6b642
    bext a3,a4,s2
    sd a3,0(a1)
    li a2, 0xedd116c18a671b8c
    li a0, 0x6f94f8db5b4289cf
    bext s1,a2,a0
    sd s1,8(a1)
    li s1, 0x8130cd0d02eb0801
    li s3, 0x36ecfc1781920806
    bext t3,s1,s3
    sd t3,16(a1)
    li a6, 0x1f9f61e943737b61
    li s4, 0xb320deb657861f11
    bext t1,a6,s4
    sd t1,24(a1)
    li a0, 0x915695b3f20d8a82
    li t1, 0xbda8a08e1ceb0c11
    bext a6,a0,t1
    sd a6,32(a1)
    li a7, 0x925c6cb79543c51a
    li a2, 0xe79ad1779a48a02c
    bext s8,a7,a2
    sd s8,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
