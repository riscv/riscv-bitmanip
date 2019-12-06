#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s0, 0xf0774453522a1063
    li t1, 0xb370bd7dd2d6b642
    sh3addu.w a0,s0,t1
    sd a0,0(a1)
    li s0, 0xedd116c18a671b8c
    li s4, 0x6f94f8db5b4289cf
    sh3addu.w t6,s0,s4
    sd t6,8(a1)
    li a7, 0x8130cd0d02eb0801
    li s10, 0x36ecfc1781920806
    sh3addu.w s2,a7,s10
    sd s2,16(a1)
    li a7, 0x1f9f61e943737b61
    li a3, 0xb320deb657861f11
    sh3addu.w t5,a7,a3
    sd t5,24(a1)
    li t3, 0x915695b3f20d8a82
    li a7, 0xbda8a08e1ceb0c11
    sh3addu.w a4,t3,a7
    sd a4,32(a1)
    li a3, 0x925c6cb79543c51a
    li s7, 0xe79ad1779a48a02c
    sh3addu.w a4,a3,s7
    sd a4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
