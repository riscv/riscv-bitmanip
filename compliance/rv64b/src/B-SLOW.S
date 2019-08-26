#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a4, 0xf0774453522a1063
    li a7, 0xb370bd7dd2d6b642
    slow t6,a4,a7
    sd t6,0(a1)
    li s4, 0xedd116c18a671b8c
    li a6, 0x6f94f8db5b4289cf
    slow s1,s4,a6
    sd s1,8(a1)
    li t4, 0x8130cd0d02eb0801
    li a5, 0x36ecfc1781920806
    slow s6,t4,a5
    sd s6,16(a1)
    li a6, 0x1f9f61e943737b61
    li s4, 0xb320deb657861f11
    slow t1,a6,s4
    sd t1,24(a1)
    li s9, 0x915695b3f20d8a82
    li t4, 0xbda8a08e1ceb0c11
    slow s7,s9,t4
    sd s7,32(a1)
    li a5, 0x925c6cb79543c51a
    li s3, 0xe79ad1779a48a02c
    slow a4,a5,s3
    sd a4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
