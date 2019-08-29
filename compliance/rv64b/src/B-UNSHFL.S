#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a6, 0xf0774453522a1063
    li t5, 0xb370bd7dd2d6b642
    unshfl s10,a6,t5
    sd s10,0(a1)
    li t1, 0xedd116c18a671b8c
    li s5, 0x6f94f8db5b4289cf
    unshfl a5,t1,s5
    sd a5,8(a1)
    li s3, 0x8130cd0d02eb0801
    li a0, 0x36ecfc1781920806
    unshfl a4,s3,a0
    sd a4,16(a1)
    li s4, 0x1f9f61e943737b61
    li a5, 0xb320deb657861f11
    unshfl s3,s4,a5
    sd s3,24(a1)
    li t6, 0x915695b3f20d8a82
    li s11, 0xbda8a08e1ceb0c11
    unshfl a3,t6,s11
    sd a3,32(a1)
    li s11, 0x925c6cb79543c51a
    li t0, 0xe79ad1779a48a02c
    unshfl s5,s11,t0
    sd s5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
