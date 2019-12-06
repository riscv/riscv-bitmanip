#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t5, 0xf0774453522a1063
    li t3, 0xb370bd7dd2d6b642
    slow t2,t5,t3
    sd t2,0(a1)
    li a3, 0xedd116c18a671b8c
    li t3, 0x6f94f8db5b4289cf
    slow s6,a3,t3
    sd s6,8(a1)
    li s0, 0x8130cd0d02eb0801
    li t2, 0x36ecfc1781920806
    slow s6,s0,t2
    sd s6,16(a1)
    li a5, 0x1f9f61e943737b61
    li a2, 0xb320deb657861f11
    slow s3,a5,a2
    sd s3,24(a1)
    li s9, 0x915695b3f20d8a82
    li a0, 0xbda8a08e1ceb0c11
    slow t2,s9,a0
    sd t2,32(a1)
    li a4, 0x925c6cb79543c51a
    li t6, 0xe79ad1779a48a02c
    slow t2,a4,t6
    sd t2,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
