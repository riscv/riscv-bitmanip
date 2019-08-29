#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s10, 0xf0774453522a1063
    li t2, 0xb370bd7dd2d6b642
    srow t1,s10,t2
    sd t1,0(a1)
    li a5, 0xedd116c18a671b8c
    li s11, 0x6f94f8db5b4289cf
    srow a0,a5,s11
    sd a0,8(a1)
    li t4, 0x8130cd0d02eb0801
    li t5, 0x36ecfc1781920806
    srow t3,t4,t5
    sd t3,16(a1)
    li t0, 0x1f9f61e943737b61
    li s1, 0xb320deb657861f11
    srow s3,t0,s1
    sd s3,24(a1)
    li s3, 0x915695b3f20d8a82
    li t1, 0xbda8a08e1ceb0c11
    srow s7,s3,t1
    sd s7,32(a1)
    li s0, 0x925c6cb79543c51a
    li a4, 0xe79ad1779a48a02c
    srow a2,s0,a4
    sd a2,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
