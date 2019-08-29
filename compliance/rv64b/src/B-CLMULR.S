#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a6, 0xf0774453522a1063
    li s3, 0xb370bd7dd2d6b642
    clmulr s6,a6,s3
    sd s6,0(a1)
    li s9, 0xedd116c18a671b8c
    li a6, 0x6f94f8db5b4289cf
    clmulr t5,s9,a6
    sd t5,8(a1)
    li s9, 0x8130cd0d02eb0801
    li a4, 0x36ecfc1781920806
    clmulr t1,s9,a4
    sd t1,16(a1)
    li s2, 0x1f9f61e943737b61
    li s7, 0xb320deb657861f11
    clmulr a6,s2,s7
    sd a6,24(a1)
    li a0, 0x915695b3f20d8a82
    li a3, 0xbda8a08e1ceb0c11
    clmulr s6,a0,a3
    sd s6,32(a1)
    li t3, 0x925c6cb79543c51a
    li t5, 0xe79ad1779a48a02c
    clmulr s2,t3,t5
    sd s2,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
