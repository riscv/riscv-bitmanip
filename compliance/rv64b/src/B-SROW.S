#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a3, 0xf0774453522a1063
    li s6, 0xb370bd7dd2d6b642
    srow t0,a3,s6
    sd t0,0(a1)
    li t5, 0xedd116c18a671b8c
    li s3, 0x6f94f8db5b4289cf
    srow a0,t5,s3
    sd a0,8(a1)
    li t1, 0x8130cd0d02eb0801
    li t5, 0x36ecfc1781920806
    srow t6,t1,t5
    sd t6,16(a1)
    li a0, 0x1f9f61e943737b61
    li t2, 0xb320deb657861f11
    srow a5,a0,t2
    sd a5,24(a1)
    li s9, 0x915695b3f20d8a82
    li t2, 0xbda8a08e1ceb0c11
    srow s0,s9,t2
    sd s0,32(a1)
    li t2, 0x925c6cb79543c51a
    li s5, 0xe79ad1779a48a02c
    srow s3,t2,s5
    sd s3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
