#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t5, 0xf0774453522a1063
    shfli s9,t5,3
    sd s9,0(a1)
    li t6, 0xedd116c18a671b8c
    shfli s3,t6,5
    sd s3,8(a1)
    li s5, 0x8130cd0d02eb0801
    shfli a0,s5,17
    sd a0,16(a1)
    li t4, 0x1f9f61e943737b61
    shfli s2,t4,24
    sd s2,24(a1)
    li s4, 0x915695b3f20d8a82
    shfli s8,s4,25
    sd s8,32(a1)
    li a3, 0x925c6cb79543c51a
    shfli s3,a3,31
    sd s3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
