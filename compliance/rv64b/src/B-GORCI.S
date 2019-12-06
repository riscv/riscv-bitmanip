#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a0, 0xf0774453522a1063
    gorci s7,a0,3
    sd s7,0(a1)
    li s4, 0xedd116c18a671b8c
    gorci s2,s4,15
    sd s2,8(a1)
    li s4, 0x8130cd0d02eb0801
    gorci a7,s4,27
    sd a7,16(a1)
    li a4, 0x1f9f61e943737b61
    gorci t1,a4,42
    sd t1,24(a1)
    li s4, 0x915695b3f20d8a82
    gorci s2,s4,59
    sd s2,32(a1)
    li s9, 0x925c6cb79543c51a
    gorci a7,s9,62
    sd a7,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
