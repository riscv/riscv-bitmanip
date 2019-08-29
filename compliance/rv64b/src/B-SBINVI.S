#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s7, 0xf0774453522a1063
    sbinvi a7,s7,3
    sd a7,0(a1)
    li s4, 0xedd116c18a671b8c
    sbinvi t2,s4,15
    sd t2,8(a1)
    li s8, 0x8130cd0d02eb0801
    sbinvi a3,s8,27
    sd a3,16(a1)
    li s5, 0x1f9f61e943737b61
    sbinvi t1,s5,42
    sd t1,24(a1)
    li s7, 0x915695b3f20d8a82
    sbinvi s0,s7,59
    sd s0,32(a1)
    li s5, 0x925c6cb79543c51a
    sbinvi a7,s5,62
    sd a7,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
