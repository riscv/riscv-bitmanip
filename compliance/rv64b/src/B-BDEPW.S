#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t4, 0xf0774453522a1063
    li t3, 0xb370bd7dd2d6b642
    bdepw a5,t4,t3
    sd a5,0(a1)
    li a0, 0xedd116c18a671b8c
    li s11, 0x6f94f8db5b4289cf
    bdepw s9,a0,s11
    sd s9,8(a1)
    li a6, 0x8130cd0d02eb0801
    li t4, 0x36ecfc1781920806
    bdepw s1,a6,t4
    sd s1,16(a1)
    li s3, 0x1f9f61e943737b61
    li a7, 0xb320deb657861f11
    bdepw s10,s3,a7
    sd s10,24(a1)
    li t2, 0x915695b3f20d8a82
    li a7, 0xbda8a08e1ceb0c11
    bdepw a4,t2,a7
    sd a4,32(a1)
    li s7, 0x925c6cb79543c51a
    li s6, 0xe79ad1779a48a02c
    bdepw a7,s7,s6
    sd a7,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
