#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s3, 0xf0774453522a1063
    li a0, 0xb370bd7dd2d6b642
    sro a4,s3,a0
    sd a4,0(a1)
    li s4, 0xedd116c18a671b8c
    li a5, 0x6f94f8db5b4289cf
    sro s3,s4,a5
    sd s3,8(a1)
    li t6, 0x8130cd0d02eb0801
    li s11, 0x36ecfc1781920806
    sro a3,t6,s11
    sd a3,16(a1)
    li s11, 0x1f9f61e943737b61
    li t0, 0xb320deb657861f11
    sro s5,s11,t0
    sd s5,24(a1)
    li s4, 0x915695b3f20d8a82
    li a3, 0xbda8a08e1ceb0c11
    sro t0,s4,a3
    sd t0,32(a1)
    li t2, 0x925c6cb79543c51a
    li t6, 0xe79ad1779a48a02c
    sro s1,t2,t6
    sd s1,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
