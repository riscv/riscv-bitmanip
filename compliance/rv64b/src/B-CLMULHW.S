#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a7, 0xf0774453522a1063
    li s10, 0xb370bd7dd2d6b642
    clmulhw t5,a7,s10
    sd t5,0(a1)
    li t1, 0xedd116c18a671b8c
    li s10, 0x6f94f8db5b4289cf
    clmulhw a3,t1,s10
    sd a3,8(a1)
    li s7, 0x8130cd0d02eb0801
    li s8, 0x36ecfc1781920806
    clmulhw a7,s7,s8
    sd a7,16(a1)
    li s4, 0x1f9f61e943737b61
    li t0, 0xb320deb657861f11
    clmulhw s2,s4,t0
    sd s2,24(a1)
    li a0, 0x915695b3f20d8a82
    li s8, 0xbda8a08e1ceb0c11
    clmulhw s10,a0,s8
    sd s10,32(a1)
    li t6, 0x925c6cb79543c51a
    li t5, 0xe79ad1779a48a02c
    clmulhw a0,t6,t5
    sd a0,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
