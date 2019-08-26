#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s7, 0xf0774453522a1063
    li s8, 0xb370bd7dd2d6b642
    unshfl t1,s7,s8
    sd t1,0(a1)
    li s1, 0xedd116c18a671b8c
    li a0, 0x6f94f8db5b4289cf
    unshfl t2,s1,a0
    sd t2,8(a1)
    li a3, 0x8130cd0d02eb0801
    li s9, 0x36ecfc1781920806
    unshfl t6,a3,s9
    sd t6,16(a1)
    li s9, 0x1f9f61e943737b61
    li t4, 0xb320deb657861f11
    unshfl a6,s9,t4
    sd a6,24(a1)
    li s8, 0x915695b3f20d8a82
    li a0, 0xbda8a08e1ceb0c11
    unshfl a6,s8,a0
    sd a6,32(a1)
    li t3, 0x925c6cb79543c51a
    li a2, 0xe79ad1779a48a02c
    unshfl t0,t3,a2
    sd t0,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
