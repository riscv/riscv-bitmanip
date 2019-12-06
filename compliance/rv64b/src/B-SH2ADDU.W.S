#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t1, 0xf0774453522a1063
    li s7, 0xb370bd7dd2d6b642
    sh2addu.w t5,t1,s7
    sd t5,0(a1)
    li s5, 0xedd116c18a671b8c
    li s6, 0x6f94f8db5b4289cf
    sh2addu.w a7,s5,s6
    sd a7,8(a1)
    li a4, 0x8130cd0d02eb0801
    li t1, 0x36ecfc1781920806
    sh2addu.w a7,a4,t1
    sd a7,16(a1)
    li t5, 0x1f9f61e943737b61
    li t6, 0xb320deb657861f11
    sh2addu.w s10,t5,t6
    sd s10,24(a1)
    li s6, 0x915695b3f20d8a82
    li s7, 0xbda8a08e1ceb0c11
    sh2addu.w a3,s6,s7
    sd a3,32(a1)
    li t2, 0x925c6cb79543c51a
    li a7, 0xe79ad1779a48a02c
    sh2addu.w s5,t2,a7
    sd s5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
