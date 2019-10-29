#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s2, 0xf0774453522a1063
    li s6, 0xb370bd7dd2d6b642
    clmulhw a0,s2,s6
    sd a0,0(a1)
    li t3, 0xedd116c18a671b8c
    li s8, 0x6f94f8db5b4289cf
    clmulhw a6,t3,s8
    sd a6,8(a1)
    li t2, 0x8130cd0d02eb0801
    li s9, 0x36ecfc1781920806
    clmulhw s11,t2,s9
    sd s11,16(a1)
    li s6, 0x1f9f61e943737b61
    li s11, 0xb320deb657861f11
    clmulhw s9,s6,s11
    sd s9,24(a1)
    li s3, 0x915695b3f20d8a82
    li t0, 0xbda8a08e1ceb0c11
    clmulhw s0,s3,t0
    sd s0,32(a1)
    li s0, 0x925c6cb79543c51a
    li s1, 0xe79ad1779a48a02c
    clmulhw s10,s0,s1
    sd s10,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
