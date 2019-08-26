#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s11, 0xf0774453522a1063
    li t5, 0xb370bd7dd2d6b642
    clmulrw a6,s11,t5
    sd a6,0(a1)
    li t3, 0xedd116c18a671b8c
    li t5, 0x6f94f8db5b4289cf
    clmulrw s2,t3,t5
    sd s2,8(a1)
    li t6, 0x8130cd0d02eb0801
    li s11, 0x36ecfc1781920806
    clmulrw a5,t6,s11
    sd a5,16(a1)
    li s2, 0x1f9f61e943737b61
    li t4, 0xb320deb657861f11
    clmulrw a2,s2,t4
    sd a2,24(a1)
    li s7, 0x915695b3f20d8a82
    li s4, 0xbda8a08e1ceb0c11
    clmulrw s2,s7,s4
    sd s2,32(a1)
    li s11, 0x925c6cb79543c51a
    li t5, 0xe79ad1779a48a02c
    clmulrw s10,s11,t5
    sd s10,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
