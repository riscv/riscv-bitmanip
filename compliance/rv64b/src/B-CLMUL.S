#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s11, 0xf0774453522a1063
    li a3, 0xb370bd7dd2d6b642
    clmul s3,s11,a3
    sd s3,0(a1)
    li s0, 0xedd116c18a671b8c
    li a6, 0x6f94f8db5b4289cf
    clmul s2,s0,a6
    sd s2,8(a1)
    li t4, 0x8130cd0d02eb0801
    li a5, 0x36ecfc1781920806
    clmul s6,t4,a5
    sd s6,16(a1)
    li s10, 0x1f9f61e943737b61
    li s5, 0xb320deb657861f11
    clmul a5,s10,s5
    sd a5,24(a1)
    li s0, 0x915695b3f20d8a82
    li s4, 0xbda8a08e1ceb0c11
    clmul s2,s0,s4
    sd s2,32(a1)
    li t4, 0x925c6cb79543c51a
    li t3, 0xe79ad1779a48a02c
    clmul a5,t4,t3
    sd a5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
