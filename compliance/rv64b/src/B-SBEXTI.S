#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a0, 0xf0774453522a1063
    sbexti t3,a0,3
    sd t3,0(a1)
    li a7, 0xedd116c18a671b8c
    sbexti s2,a7,15
    sd s2,8(a1)
    li s4, 0x8130cd0d02eb0801
    sbexti s9,s4,27
    sd s9,16(a1)
    li a3, 0x1f9f61e943737b61
    sbexti a4,a3,42
    sd a4,24(a1)
    li t0, 0x915695b3f20d8a82
    sbexti s5,t0,59
    sd s5,32(a1)
    li a4, 0x925c6cb79543c51a
    sbexti s9,a4,62
    sd s9,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
