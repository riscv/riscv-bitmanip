#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s6, 0xf0774453522a1063
    li s3, 0xb370bd7dd2d6b642
    clmulrw t3,s6,s3
    sd t3,0(a1)
    li a3, 0xedd116c18a671b8c
    li a7, 0x6f94f8db5b4289cf
    clmulrw s10,a3,a7
    sd s10,8(a1)
    li s2, 0x8130cd0d02eb0801
    li a7, 0x36ecfc1781920806
    clmulrw a4,s2,a7
    sd a4,16(a1)
    li t2, 0x1f9f61e943737b61
    li a5, 0xb320deb657861f11
    clmulrw s10,t2,a5
    sd s10,24(a1)
    li s7, 0x915695b3f20d8a82
    li t4, 0xbda8a08e1ceb0c11
    clmulrw a7,s7,t4
    sd a7,32(a1)
    li a0, 0x925c6cb79543c51a
    li s9, 0xe79ad1779a48a02c
    clmulrw a4,a0,s9
    sd a4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
