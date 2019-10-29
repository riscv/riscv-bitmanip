#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s5, 0xf0774453522a1063
    li s1, 0xb370bd7dd2d6b642
    bextw s9,s5,s1
    sd s9,0(a1)
    li t4, 0xedd116c18a671b8c
    li s5, 0x6f94f8db5b4289cf
    bextw t1,t4,s5
    sd t1,8(a1)
    li a6, 0x8130cd0d02eb0801
    li t2, 0x36ecfc1781920806
    bextw a7,a6,t2
    sd a7,16(a1)
    li s0, 0x1f9f61e943737b61
    li a4, 0xb320deb657861f11
    bextw a3,s0,a4
    sd a3,24(a1)
    li s10, 0x915695b3f20d8a82
    li a4, 0xbda8a08e1ceb0c11
    bextw a5,s10,a4
    sd a5,32(a1)
    li s8, 0x925c6cb79543c51a
    li a7, 0xe79ad1779a48a02c
    bextw a3,s8,a7
    sd a3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
