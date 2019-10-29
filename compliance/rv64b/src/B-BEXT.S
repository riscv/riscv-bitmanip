#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s9, 0xf0774453522a1063
    li a4, 0xb370bd7dd2d6b642
    bext t1,s9,a4
    sd t1,0(a1)
    li s2, 0xedd116c18a671b8c
    li s7, 0x6f94f8db5b4289cf
    bext a6,s2,s7
    sd a6,8(a1)
    li a0, 0x8130cd0d02eb0801
    li a3, 0x36ecfc1781920806
    bext s6,a0,a3
    sd s6,16(a1)
    li t3, 0x1f9f61e943737b61
    li t5, 0xb320deb657861f11
    bext s2,t3,t5
    sd s2,24(a1)
    li s11, 0x915695b3f20d8a82
    li s10, 0xbda8a08e1ceb0c11
    bext a3,s11,s10
    sd a3,32(a1)
    li t4, 0x925c6cb79543c51a
    li t5, 0xe79ad1779a48a02c
    bext t3,t4,t5
    sd t3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
