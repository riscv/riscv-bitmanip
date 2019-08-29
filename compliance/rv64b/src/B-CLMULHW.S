#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a6, 0xf0774453522a1063
    li s4, 0xb370bd7dd2d6b642
    clmulhw t1,a6,s4
    sd t1,0(a1)
    li s9, 0xedd116c18a671b8c
    li t4, 0x6f94f8db5b4289cf
    clmulhw s7,s9,t4
    sd s7,8(a1)
    li a5, 0x8130cd0d02eb0801
    li s3, 0x36ecfc1781920806
    clmulhw a4,a5,s3
    sd a4,16(a1)
    li t5, 0x1f9f61e943737b61
    li t3, 0xb320deb657861f11
    clmulhw t2,t5,t3
    sd t2,24(a1)
    li a3, 0x915695b3f20d8a82
    li t3, 0xbda8a08e1ceb0c11
    clmulhw s6,a3,t3
    sd s6,32(a1)
    li s0, 0x925c6cb79543c51a
    li t2, 0xe79ad1779a48a02c
    clmulhw s6,s0,t2
    sd s6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
