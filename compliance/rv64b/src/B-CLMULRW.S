#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t0, 0xf0774453522a1063
    li s11, 0xb370bd7dd2d6b642
    clmulrw t3,t0,s11
    sd t3,0(a1)
    li a7, 0xedd116c18a671b8c
    li s10, 0x6f94f8db5b4289cf
    clmulrw t5,a7,s10
    sd t5,8(a1)
    li t1, 0x8130cd0d02eb0801
    li s10, 0x36ecfc1781920806
    clmulrw a3,t1,s10
    sd a3,16(a1)
    li s7, 0x1f9f61e943737b61
    li s8, 0xb320deb657861f11
    clmulrw a7,s7,s8
    sd a7,24(a1)
    li s4, 0x915695b3f20d8a82
    li t0, 0xbda8a08e1ceb0c11
    clmulrw s2,s4,t0
    sd s2,32(a1)
    li a0, 0x925c6cb79543c51a
    li s8, 0xe79ad1779a48a02c
    clmulrw s10,a0,s8
    sd s10,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
