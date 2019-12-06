#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s6, 0xf0774453522a1063
    li t2, 0xb370bd7dd2d6b642
    unshfl a2,s6,t2
    sd a2,0(a1)
    li s10, 0xedd116c18a671b8c
    li s4, 0x6f94f8db5b4289cf
    unshfl s11,s10,s4
    sd s11,8(a1)
    li s2, 0x8130cd0d02eb0801
    li s6, 0x36ecfc1781920806
    unshfl t1,s2,s6
    sd t1,16(a1)
    li t6, 0x1f9f61e943737b61
    li s11, 0xb320deb657861f11
    unshfl a5,t6,s11
    sd a5,24(a1)
    li t2, 0x915695b3f20d8a82
    li a0, 0xbda8a08e1ceb0c11
    unshfl s10,t2,a0
    sd s10,32(a1)
    li t0, 0x925c6cb79543c51a
    li s1, 0xe79ad1779a48a02c
    unshfl s3,t0,s1
    sd s3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
