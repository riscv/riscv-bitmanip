#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t4, 0xf0774453522a1063
    li s5, 0xb370bd7dd2d6b642
    unshflw t1,t4,s5
    sd t1,0(a1)
    li a6, 0xedd116c18a671b8c
    li t2, 0x6f94f8db5b4289cf
    unshflw a7,a6,t2
    sd a7,8(a1)
    li s0, 0x8130cd0d02eb0801
    li a4, 0x36ecfc1781920806
    unshflw a3,s0,a4
    sd a3,16(a1)
    li s10, 0x1f9f61e943737b61
    li a4, 0xb320deb657861f11
    unshflw a5,s10,a4
    sd a5,24(a1)
    li s8, 0x915695b3f20d8a82
    li a7, 0xbda8a08e1ceb0c11
    unshflw a3,s8,a7
    sd a3,32(a1)
    li a3, 0x925c6cb79543c51a
    li a4, 0xe79ad1779a48a02c
    unshflw a0,a3,a4
    sd a0,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
