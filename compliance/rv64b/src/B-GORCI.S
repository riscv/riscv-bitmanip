#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s4, 0xf0774453522a1063
    gorci s2,s4,3
    sd s2,0(a1)
    li s9, 0xedd116c18a671b8c
    gorci a7,s9,15
    sd a7,8(a1)
    li s9, 0x8130cd0d02eb0801
    gorci s10,s9,27
    sd s10,16(a1)
    li s2, 0x1f9f61e943737b61
    gorci s0,s2,42
    sd s0,24(a1)
    li a3, 0x915695b3f20d8a82
    gorci t4,a3,59
    sd t4,32(a1)
    li t2, 0x925c6cb79543c51a
    gorci s4,t2,62
    sd s4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
