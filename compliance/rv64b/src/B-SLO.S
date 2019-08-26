#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s8, 0xf0774453522a1063
    li a2, 0xb370bd7dd2d6b642
    slo a3,s8,a2
    sd a3,0(a1)
    li s2, 0xedd116c18a671b8c
    li s7, 0x6f94f8db5b4289cf
    slo s11,s2,s7
    sd s11,8(a1)
    li s3, 0x8130cd0d02eb0801
    li s8, 0x36ecfc1781920806
    slo t6,s3,s8
    sd t6,16(a1)
    li a3, 0x1f9f61e943737b61
    li s1, 0xb320deb657861f11
    slo t1,a3,s1
    sd t1,24(a1)
    li a5, 0x915695b3f20d8a82
    li t2, 0xbda8a08e1ceb0c11
    slo s4,a5,t2
    sd s4,32(a1)
    li a6, 0x925c6cb79543c51a
    li t0, 0xe79ad1779a48a02c
    slo a0,a6,t0
    sd a0,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
