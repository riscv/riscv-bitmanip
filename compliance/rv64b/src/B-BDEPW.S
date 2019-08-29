#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t0, 0xf0774453522a1063
    li s8, 0xb370bd7dd2d6b642
    bdepw a5,t0,s8
    sd a5,0(a1)
    li t2, 0xedd116c18a671b8c
    li t6, 0x6f94f8db5b4289cf
    bdepw s1,t2,t6
    sd s1,8(a1)
    li t5, 0x8130cd0d02eb0801
    li s6, 0x36ecfc1781920806
    bdepw a7,t5,s6
    sd a7,16(a1)
    li t0, 0x1f9f61e943737b61
    li s11, 0xb320deb657861f11
    bdepw t3,t0,s11
    sd t3,24(a1)
    li a7, 0x915695b3f20d8a82
    li s10, 0xbda8a08e1ceb0c11
    bdepw t5,a7,s10
    sd t5,32(a1)
    li t1, 0x925c6cb79543c51a
    li s10, 0xe79ad1779a48a02c
    bdepw a3,t1,s10
    sd a3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
