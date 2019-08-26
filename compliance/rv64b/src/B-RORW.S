#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t6, 0xf0774453522a1063
    li s11, 0xb370bd7dd2d6b642
    rorw a3,t6,s11
    sd a3,0(a1)
    li s3, 0xedd116c18a671b8c
    li s5, 0x6f94f8db5b4289cf
    rorw s7,s3,s5
    sd s7,8(a1)
    li s10, 0x8130cd0d02eb0801
    li t2, 0x36ecfc1781920806
    rorw t1,s10,t2
    sd t1,16(a1)
    li a5, 0x1f9f61e943737b61
    li s11, 0xb320deb657861f11
    rorw a0,a5,s11
    sd a0,24(a1)
    li t4, 0x915695b3f20d8a82
    li t5, 0xbda8a08e1ceb0c11
    rorw t3,t4,t5
    sd t3,32(a1)
    li t0, 0x925c6cb79543c51a
    li s1, 0xe79ad1779a48a02c
    rorw s3,t0,s1
    sd s3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
