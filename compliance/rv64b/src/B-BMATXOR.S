#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t1, 0xf0774453522a1063
    li s2, 0xb370bd7dd2d6b642
    bmatxor t3,t1,s2
    sd t3,0(a1)
    li s10, 0xedd116c18a671b8c
    li t3, 0x6f94f8db5b4289cf
    bmatxor t4,s10,t3
    sd t4,8(a1)
    li t0, 0x8130cd0d02eb0801
    li a5, 0x36ecfc1781920806
    bmatxor a4,t0,a5
    sd a4,16(a1)
    li s9, 0x1f9f61e943737b61
    li a7, 0xb320deb657861f11
    bmatxor s3,s9,a7
    sd s3,24(a1)
    li s11, 0x915695b3f20d8a82
    li t5, 0xbda8a08e1ceb0c11
    bmatxor a6,s11,t5
    sd a6,32(a1)
    li s6, 0x925c6cb79543c51a
    li t2, 0xe79ad1779a48a02c
    bmatxor t0,s6,t2
    sd t0,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
