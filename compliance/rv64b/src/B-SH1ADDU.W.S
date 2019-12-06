#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t3, 0xf0774453522a1063
    li s4, 0xb370bd7dd2d6b642
    sh1addu.w a6,t3,s4
    sd a6,0(a1)
    li s4, 0xedd116c18a671b8c
    li s10, 0x6f94f8db5b4289cf
    sh1addu.w s2,s4,s10
    sd s2,8(a1)
    li s10, 0x8130cd0d02eb0801
    li s4, 0x36ecfc1781920806
    sh1addu.w s8,s10,s4
    sd s8,16(a1)
    li t5, 0x1f9f61e943737b61
    li t2, 0xb320deb657861f11
    sh1addu.w s10,t5,t2
    sd s10,24(a1)
    li a4, 0x915695b3f20d8a82
    li a6, 0xbda8a08e1ceb0c11
    sh1addu.w t1,a4,a6
    sd t1,32(a1)
    li s5, 0x925c6cb79543c51a
    li a2, 0xe79ad1779a48a02c
    sh1addu.w t1,s5,a2
    sd t1,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
