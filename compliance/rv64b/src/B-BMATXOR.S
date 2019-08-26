#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t3, 0xf0774453522a1063
    li t5, 0xb370bd7dd2d6b642
    bmatxor s11,t3,t5
    sd s11,0(a1)
    li s11, 0xedd116c18a671b8c
    li s3, 0x6f94f8db5b4289cf
    bmatxor s6,s11,s3
    sd s6,8(a1)
    li t3, 0x8130cd0d02eb0801
    li s10, 0x36ecfc1781920806
    bmatxor a3,t3,s10
    sd a3,16(a1)
    li s4, 0x1f9f61e943737b61
    li s1, 0xb320deb657861f11
    bmatxor t5,s4,s1
    sd t5,24(a1)
    li s0, 0x915695b3f20d8a82
    li a0, 0xbda8a08e1ceb0c11
    bmatxor a3,s0,a0
    sd a3,32(a1)
    li s7, 0x925c6cb79543c51a
    li s6, 0xe79ad1779a48a02c
    bmatxor t1,s7,s6
    sd t1,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
