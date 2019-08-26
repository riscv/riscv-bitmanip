#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s11, 0xf0774453522a1063
    li s3, 0xb370bd7dd2d6b642
    sro s0,s11,s3
    sd s0,0(a1)
    li a7, 0xedd116c18a671b8c
    li t2, 0x6f94f8db5b4289cf
    sro a4,a7,t2
    sd a4,8(a1)
    li a7, 0x8130cd0d02eb0801
    li s11, 0x36ecfc1781920806
    sro s3,a7,s11
    sd s3,16(a1)
    li a7, 0x1f9f61e943737b61
    li s4, 0xb320deb657861f11
    sro a0,a7,s4
    sd a0,24(a1)
    li t5, 0x915695b3f20d8a82
    li a5, 0xbda8a08e1ceb0c11
    sro a2,t5,a5
    sd a2,32(a1)
    li t1, 0x925c6cb79543c51a
    li s1, 0xe79ad1779a48a02c
    sro s3,t1,s1
    sd s3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
