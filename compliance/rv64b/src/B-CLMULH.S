#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a0, 0xf0774453522a1063
    li s9, 0xb370bd7dd2d6b642
    clmulh s8,a0,s9
    sd s8,0(a1)
    li a7, 0xedd116c18a671b8c
    li s4, 0x6f94f8db5b4289cf
    clmulh a4,a7,s4
    sd a4,8(a1)
    li a5, 0x8130cd0d02eb0801
    li s7, 0x36ecfc1781920806
    clmulh s11,a5,s7
    sd s11,16(a1)
    li s11, 0x1f9f61e943737b61
    li a6, 0xb320deb657861f11
    clmulh t4,s11,a6
    sd t4,24(a1)
    li s0, 0x915695b3f20d8a82
    li a4, 0xbda8a08e1ceb0c11
    clmulh t5,s0,a4
    sd t5,32(a1)
    li s11, 0x925c6cb79543c51a
    li a3, 0xe79ad1779a48a02c
    clmulh s3,s11,a3
    sd s3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
