#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s0, 0xf0774453522a1063
    li a6, 0xb370bd7dd2d6b642
    clmulhw s2,s0,a6
    sd s2,0(a1)
    li s1, 0xedd116c18a671b8c
    li s3, 0x6f94f8db5b4289cf
    clmulhw t3,s1,s3
    sd t3,8(a1)
    li t0, 0x8130cd0d02eb0801
    li s8, 0x36ecfc1781920806
    clmulhw a5,t0,s8
    sd a5,16(a1)
    li t2, 0x1f9f61e943737b61
    li t6, 0xb320deb657861f11
    clmulhw s1,t2,t6
    sd s1,24(a1)
    li t5, 0x915695b3f20d8a82
    li s6, 0xbda8a08e1ceb0c11
    clmulhw a7,t5,s6
    sd a7,32(a1)
    li t0, 0x925c6cb79543c51a
    li s11, 0xe79ad1779a48a02c
    clmulhw t3,t0,s11
    sd t3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
