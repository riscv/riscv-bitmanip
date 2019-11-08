#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t2, 0xf0774453522a1063
    li s5, 0xb370bd7dd2d6b642
    unshfl t5,t2,s5
    sd t5,0(a1)
    li a4, 0xedd116c18a671b8c
    li s2, 0x6f94f8db5b4289cf
    unshfl a3,a4,s2
    sd a3,8(a1)
    li a2, 0x8130cd0d02eb0801
    li a0, 0x36ecfc1781920806
    unshfl s1,a2,a0
    sd s1,16(a1)
    li s1, 0x1f9f61e943737b61
    li s3, 0xb320deb657861f11
    unshfl t3,s1,s3
    sd t3,24(a1)
    li a6, 0x915695b3f20d8a82
    li s4, 0xbda8a08e1ceb0c11
    unshfl t1,a6,s4
    sd t1,32(a1)
    li a0, 0x925c6cb79543c51a
    li t1, 0xe79ad1779a48a02c
    unshfl a6,a0,t1
    sd a6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
