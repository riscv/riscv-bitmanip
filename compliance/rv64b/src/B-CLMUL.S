#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t0, 0xf0774453522a1063
    li a5, 0xb370bd7dd2d6b642
    clmul a4,t0,a5
    sd a4,0(a1)
    li s9, 0xedd116c18a671b8c
    li a7, 0x6f94f8db5b4289cf
    clmul s3,s9,a7
    sd s3,8(a1)
    li s11, 0x8130cd0d02eb0801
    li t5, 0x36ecfc1781920806
    clmul a6,s11,t5
    sd a6,16(a1)
    li s6, 0x1f9f61e943737b61
    li t2, 0xb320deb657861f11
    clmul t0,s6,t2
    sd t0,24(a1)
    li a5, 0x915695b3f20d8a82
    li s11, 0xbda8a08e1ceb0c11
    clmul a0,a5,s11
    sd a0,32(a1)
    li s1, 0x925c6cb79543c51a
    li s0, 0xe79ad1779a48a02c
    clmul s3,s1,s0
    sd s3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
