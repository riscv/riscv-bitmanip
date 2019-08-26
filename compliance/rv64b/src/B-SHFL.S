#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s9, 0xf0774453522a1063
    li s5, 0xb370bd7dd2d6b642
    shfl s7,s9,s5
    sd s7,0(a1)
    li s7, 0xedd116c18a671b8c
    li t3, 0x6f94f8db5b4289cf
    shfl a5,s7,t3
    sd a5,8(a1)
    li t0, 0x8130cd0d02eb0801
    li s9, 0x36ecfc1781920806
    shfl a3,t0,s9
    sd a3,16(a1)
    li s5, 0x1f9f61e943737b61
    li s11, 0xb320deb657861f11
    shfl t3,s5,s11
    sd t3,24(a1)
    li t1, 0x915695b3f20d8a82
    li a0, 0xbda8a08e1ceb0c11
    shfl t2,t1,a0
    sd t2,32(a1)
    li s6, 0x925c6cb79543c51a
    li s4, 0xe79ad1779a48a02c
    shfl t6,s6,s4
    sd t6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
