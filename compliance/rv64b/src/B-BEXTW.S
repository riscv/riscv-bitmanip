#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t4, 0xf0774453522a1063
    li s7, 0xb370bd7dd2d6b642
    bextw a0,t4,s7
    sd a0,0(a1)
    li a6, 0xedd116c18a671b8c
    li t1, 0x6f94f8db5b4289cf
    bextw s9,a6,t1
    sd s9,8(a1)
    li a2, 0x8130cd0d02eb0801
    li s6, 0x36ecfc1781920806
    bextw a0,a2,s6
    sd a0,16(a1)
    li s2, 0x1f9f61e943737b61
    li s6, 0xb320deb657861f11
    bextw a0,s2,s6
    sd a0,24(a1)
    li t3, 0x915695b3f20d8a82
    li s8, 0xbda8a08e1ceb0c11
    bextw a6,t3,s8
    sd a6,32(a1)
    li t2, 0x925c6cb79543c51a
    li s9, 0xe79ad1779a48a02c
    bextw s11,t2,s9
    sd s11,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
