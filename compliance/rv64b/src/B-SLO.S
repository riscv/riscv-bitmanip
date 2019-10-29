#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s8, 0xf0774453522a1063
    li s3, 0xb370bd7dd2d6b642
    slo s11,s8,s3
    sd s11,0(a1)
    li a3, 0xedd116c18a671b8c
    li s6, 0x6f94f8db5b4289cf
    slo s0,a3,s6
    sd s0,8(a1)
    li s5, 0x8130cd0d02eb0801
    li a2, 0x36ecfc1781920806
    slo a5,s5,a2
    sd a5,16(a1)
    li t2, 0x1f9f61e943737b61
    li t3, 0xb320deb657861f11
    slo s6,t2,t3
    sd s6,24(a1)
    li s6, 0x915695b3f20d8a82
    li t3, 0xbda8a08e1ceb0c11
    slo s4,s6,t3
    sd s4,32(a1)
    li a6, 0x925c6cb79543c51a
    li t1, 0xe79ad1779a48a02c
    slo s9,a6,t1
    sd s9,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
