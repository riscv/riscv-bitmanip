#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s0, 0xf0774453522a1063
    sroi a3,s0,3
    sd a3,0(a1)
    li s8, 0xedd116c18a671b8c
    sroi t0,s8,15
    sd t0,8(a1)
    li s9, 0x8130cd0d02eb0801
    sroi s0,s9,27
    sd s0,16(a1)
    li s7, 0x1f9f61e943737b61
    sroi a7,s7,42
    sd a7,24(a1)
    li s9, 0x915695b3f20d8a82
    sroi s5,s9,59
    sd s5,32(a1)
    li s5, 0x925c6cb79543c51a
    sroi a0,s5,62
    sd a0,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
