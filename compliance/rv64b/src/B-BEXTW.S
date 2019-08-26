#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s10, 0xf0774453522a1063
    li s4, 0xb370bd7dd2d6b642
    bextw s11,s10,s4
    sd s11,0(a1)
    li t6, 0xedd116c18a671b8c
    li s5, 0x6f94f8db5b4289cf
    bextw t2,t6,s5
    sd t2,8(a1)
    li s6, 0x8130cd0d02eb0801
    li t3, 0x36ecfc1781920806
    bextw s4,s6,t3
    sd s4,16(a1)
    li a7, 0x1f9f61e943737b61
    li a4, 0xb320deb657861f11
    bextw t5,a7,a4
    sd t5,24(a1)
    li s6, 0x915695b3f20d8a82
    li a6, 0xbda8a08e1ceb0c11
    bextw a5,s6,a6
    sd a5,32(a1)
    li t4, 0x925c6cb79543c51a
    li t3, 0xe79ad1779a48a02c
    bextw a5,t4,t3
    sd a5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
