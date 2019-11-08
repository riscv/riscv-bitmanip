#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s0, 0xf0774453522a1063
    shfli s3,s0,3
    sd s3,0(a1)
    li t1, 0xedd116c18a671b8c
    shfli s9,t1,5
    sd s9,8(a1)
    li s7, 0x8130cd0d02eb0801
    shfli t5,s7,17
    sd t5,16(a1)
    li t5, 0x1f9f61e943737b61
    shfli s6,t5,24
    sd s6,24(a1)
    li s8, 0x915695b3f20d8a82
    shfli t5,s8,25
    sd t5,32(a1)
    li s0, 0x925c6cb79543c51a
    shfli t3,s0,31
    sd t3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
