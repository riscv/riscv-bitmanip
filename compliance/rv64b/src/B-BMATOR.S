#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s7, 0xf0774453522a1063
    li s6, 0xb370bd7dd2d6b642
    bmator t1,s7,s6
    sd t1,0(a1)
    li t6, 0xedd116c18a671b8c
    li s6, 0x6f94f8db5b4289cf
    bmator s5,t6,s6
    sd s5,8(a1)
    li s10, 0x8130cd0d02eb0801
    li t2, 0x36ecfc1781920806
    bmator t1,s10,t2
    sd t1,16(a1)
    li s10, 0x1f9f61e943737b61
    li a2, 0xb320deb657861f11
    bmator s7,s10,a2
    sd s7,24(a1)
    li a2, 0x915695b3f20d8a82
    li a3, 0xbda8a08e1ceb0c11
    bmator a7,a2,a3
    sd a7,32(a1)
    li t0, 0x925c6cb79543c51a
    li s11, 0xe79ad1779a48a02c
    bmator t3,t0,s11
    sd t3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
