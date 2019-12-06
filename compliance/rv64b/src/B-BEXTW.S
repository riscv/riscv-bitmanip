#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a0, 0xf0774453522a1063
    li s11, 0xb370bd7dd2d6b642
    bextw s9,a0,s11
    sd s9,0(a1)
    li a6, 0xedd116c18a671b8c
    li t4, 0x6f94f8db5b4289cf
    bextw s1,a6,t4
    sd s1,8(a1)
    li s3, 0x8130cd0d02eb0801
    li a7, 0x36ecfc1781920806
    bextw s10,s3,a7
    sd s10,16(a1)
    li t2, 0x1f9f61e943737b61
    li a7, 0xb320deb657861f11
    bextw a4,t2,a7
    sd a4,24(a1)
    li s7, 0x915695b3f20d8a82
    li s6, 0xbda8a08e1ceb0c11
    bextw a7,s7,s6
    sd a7,32(a1)
    li s10, 0x925c6cb79543c51a
    li a2, 0xe79ad1779a48a02c
    bextw a4,s10,a2
    sd a4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
