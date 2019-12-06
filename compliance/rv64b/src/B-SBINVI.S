#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a0, 0xf0774453522a1063
    sbinvi t0,a0,3
    sd t0,0(a1)
    li a4, 0xedd116c18a671b8c
    sbinvi a7,a4,15
    sd a7,8(a1)
    li t0, 0x8130cd0d02eb0801
    sbinvi s0,t0,27
    sd s0,16(a1)
    li t2, 0x1f9f61e943737b61
    sbinvi s5,t2,42
    sd s5,24(a1)
    li a3, 0x915695b3f20d8a82
    sbinvi t3,a3,59
    sd t3,32(a1)
    li t3, 0x925c6cb79543c51a
    sbinvi a4,t3,62
    sd a4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
