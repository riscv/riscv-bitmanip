#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s3, 0xf0774453522a1063
    li s8, 0xb370bd7dd2d6b642
    rol t6,s3,s8
    sd t6,0(a1)
    li a3, 0xedd116c18a671b8c
    li s1, 0x6f94f8db5b4289cf
    rol t1,a3,s1
    sd t1,8(a1)
    li a5, 0x8130cd0d02eb0801
    li t2, 0x36ecfc1781920806
    rol s4,a5,t2
    sd s4,16(a1)
    li a6, 0x1f9f61e943737b61
    li t0, 0xb320deb657861f11
    rol a0,a6,t0
    sd a0,24(a1)
    li a4, 0x915695b3f20d8a82
    li a7, 0xbda8a08e1ceb0c11
    rol t6,a4,a7
    sd t6,32(a1)
    li a7, 0x925c6cb79543c51a
    li s5, 0xe79ad1779a48a02c
    rol a3,a7,s5
    sd a3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
