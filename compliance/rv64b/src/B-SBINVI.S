#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a0, 0xf0774453522a1063
    sbinvi s9,a0,3
    sd s9,0(a1)
    li s0, 0xedd116c18a671b8c
    sbinvi a2,s0,15
    sd a2,8(a1)
    li s0, 0x8130cd0d02eb0801
    sbinvi s6,s0,27
    sd s6,16(a1)
    li s6, 0x1f9f61e943737b61
    sbinvi s9,s6,42
    sd s9,24(a1)
    li s10, 0x915695b3f20d8a82
    sbinvi a5,s10,59
    sd a5,32(a1)
    li t2, 0x925c6cb79543c51a
    sbinvi a4,t2,62
    sd a4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
