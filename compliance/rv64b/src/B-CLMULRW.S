#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s11, 0xf0774453522a1063
    li s10, 0xb370bd7dd2d6b642
    clmulrw a3,s11,s10
    sd a3,0(a1)
    li t2, 0xedd116c18a671b8c
    li a0, 0x6f94f8db5b4289cf
    clmulrw s10,t2,a0
    sd s10,8(a1)
    li s2, 0x8130cd0d02eb0801
    li a6, 0x36ecfc1781920806
    clmulrw t3,s2,a6
    sd t3,16(a1)
    li a3, 0x1f9f61e943737b61
    li s6, 0xb320deb657861f11
    clmulrw t0,a3,s6
    sd t0,24(a1)
    li t5, 0x915695b3f20d8a82
    li s3, 0xbda8a08e1ceb0c11
    clmulrw a0,t5,s3
    sd a0,32(a1)
    li t1, 0x925c6cb79543c51a
    li t5, 0xe79ad1779a48a02c
    clmulrw t6,t1,t5
    sd t6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
