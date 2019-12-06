#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t0, 0xf0774453522a1063
    sbexti s5,t0,3
    sd s5,0(a1)
    li a4, 0xedd116c18a671b8c
    sbexti s9,a4,15
    sd s9,8(a1)
    li a3, 0x8130cd0d02eb0801
    sbexti t3,a3,27
    sd t3,16(a1)
    li s0, 0x1f9f61e943737b61
    sbexti s9,s0,42
    sd s9,24(a1)
    li t2, 0x915695b3f20d8a82
    sbexti s5,t2,59
    sd s5,32(a1)
    li t6, 0x925c6cb79543c51a
    sbexti a6,t6,62
    sd a6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
