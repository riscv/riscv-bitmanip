#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s5, 0xf0774453522a1063
    li s6, 0xb370bd7dd2d6b642
    rol s1,s5,s6
    sd s1,0(a1)
    li s3, 0xedd116c18a671b8c
    li t6, 0x6f94f8db5b4289cf
    rol t2,s3,t6
    sd t2,8(a1)
    li a5, 0x8130cd0d02eb0801
    li a0, 0x36ecfc1781920806
    rol t2,a5,a0
    sd t2,16(a1)
    li a7, 0x1f9f61e943737b61
    li s11, 0xb320deb657861f11
    rol t6,a7,s11
    sd t6,24(a1)
    li s8, 0x915695b3f20d8a82
    li s3, 0xbda8a08e1ceb0c11
    rol s11,s8,s3
    sd s11,32(a1)
    li a3, 0x925c6cb79543c51a
    li s6, 0xe79ad1779a48a02c
    rol s0,a3,s6
    sd s0,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
