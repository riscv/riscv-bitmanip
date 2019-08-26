#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t0, 0xf0774453522a1063
    li s7, 0xb370bd7dd2d6b642
    bdep s1,t0,s7
    sd s1,0(a1)
    li s7, 0xedd116c18a671b8c
    li a4, 0x6f94f8db5b4289cf
    bdep s11,s7,a4
    sd s11,8(a1)
    li t5, 0x8130cd0d02eb0801
    li s5, 0x36ecfc1781920806
    bdep t2,t5,s5
    sd t2,16(a1)
    li s3, 0x1f9f61e943737b61
    li s10, 0xb320deb657861f11
    bdep s7,s3,s10
    sd s7,24(a1)
    li t2, 0x915695b3f20d8a82
    li s5, 0xbda8a08e1ceb0c11
    bdep t5,t2,s5
    sd t5,32(a1)
    li a4, 0x925c6cb79543c51a
    li s2, 0xe79ad1779a48a02c
    bdep a3,a4,s2
    sd a3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
