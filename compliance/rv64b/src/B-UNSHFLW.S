#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a7, 0xf0774453522a1063
    li a2, 0xb370bd7dd2d6b642
    unshflw s8,a7,a2
    sd s8,0(a1)
    li a3, 0xedd116c18a671b8c
    li s11, 0x6f94f8db5b4289cf
    unshflw s3,a3,s11
    sd s3,8(a1)
    li a6, 0x8130cd0d02eb0801
    li s11, 0x36ecfc1781920806
    unshflw s6,a6,s11
    sd s6,16(a1)
    li s9, 0x1f9f61e943737b61
    li s11, 0xb320deb657861f11
    unshflw s3,s9,s11
    sd s3,24(a1)
    li s1, 0x915695b3f20d8a82
    li s11, 0xbda8a08e1ceb0c11
    unshflw a5,s1,s11
    sd a5,32(a1)
    li s2, 0x925c6cb79543c51a
    li a5, 0xe79ad1779a48a02c
    unshflw a3,s2,a5
    sd a3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
