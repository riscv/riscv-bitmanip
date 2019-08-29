#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s3, 0xf0774453522a1063
    li t5, 0xb370bd7dd2d6b642
    clmul s5,s3,t5
    sd s5,0(a1)
    li t2, 0xedd116c18a671b8c
    li a7, 0x6f94f8db5b4289cf
    clmul t3,t2,a7
    sd t3,8(a1)
    li t5, 0x8130cd0d02eb0801
    li s10, 0x36ecfc1781920806
    clmul s4,t5,s10
    sd s4,16(a1)
    li s6, 0x1f9f61e943737b61
    li t2, 0xb320deb657861f11
    clmul a2,s6,t2
    sd a2,24(a1)
    li s10, 0x915695b3f20d8a82
    li s4, 0xbda8a08e1ceb0c11
    clmul s11,s10,s4
    sd s11,32(a1)
    li s2, 0x925c6cb79543c51a
    li s6, 0xe79ad1779a48a02c
    clmul t1,s2,s6
    sd t1,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
