#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s6, 0xf0774453522a1063
    unshfli s0,s6,3
    sd s0,0(a1)
    li s5, 0xedd116c18a671b8c
    unshfli a6,s5,5
    sd a6,8(a1)
    li a0, 0x8130cd0d02eb0801
    unshfli s6,a0,17
    sd s6,16(a1)
    li a0, 0x1f9f61e943737b61
    unshfli s3,a0,24
    sd s3,24(a1)
    li a6, 0x915695b3f20d8a82
    unshfli a3,a6,25
    sd a3,32(a1)
    li a4, 0x925c6cb79543c51a
    unshfli t5,a4,31
    sd t5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
