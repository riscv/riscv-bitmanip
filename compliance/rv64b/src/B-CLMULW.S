#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t6, 0xf0774453522a1063
    li s11, 0xb370bd7dd2d6b642
    clmulw a5,t6,s11
    sd a5,0(a1)
    li s2, 0xedd116c18a671b8c
    li t4, 0x6f94f8db5b4289cf
    clmulw a2,s2,t4
    sd a2,8(a1)
    li s7, 0x8130cd0d02eb0801
    li s4, 0x36ecfc1781920806
    clmulw s2,s7,s4
    sd s2,16(a1)
    li s11, 0x1f9f61e943737b61
    li t5, 0xb320deb657861f11
    clmulw s10,s11,t5
    sd s10,24(a1)
    li s6, 0x915695b3f20d8a82
    li s3, 0xbda8a08e1ceb0c11
    clmulw t3,s6,s3
    sd t3,32(a1)
    li a3, 0x925c6cb79543c51a
    li a7, 0xe79ad1779a48a02c
    clmulw s10,a3,a7
    sd s10,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
