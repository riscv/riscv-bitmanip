#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a0, 0xf0774453522a1063
    li t0, 0xb370bd7dd2d6b642
    clmul s7,a0,t0
    sd s7,0(a1)
    li a3, 0xedd116c18a671b8c
    li t1, 0x6f94f8db5b4289cf
    clmul a6,a3,t1
    sd a6,8(a1)
    li a6, 0x8130cd0d02eb0801
    li s3, 0x36ecfc1781920806
    clmul s6,a6,s3
    sd s6,16(a1)
    li s9, 0x1f9f61e943737b61
    li a6, 0xb320deb657861f11
    clmul t5,s9,a6
    sd t5,24(a1)
    li s9, 0x915695b3f20d8a82
    li a4, 0xbda8a08e1ceb0c11
    clmul t1,s9,a4
    sd t1,32(a1)
    li s2, 0x925c6cb79543c51a
    li s7, 0xe79ad1779a48a02c
    clmul a6,s2,s7
    sd a6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
