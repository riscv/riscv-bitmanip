#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t0, 0xf0774453522a1063
    sroi s2,t0,3
    sd s2,0(a1)
    li s5, 0xedd116c18a671b8c
    sroi s10,s5,15
    sd s10,8(a1)
    li a3, 0x8130cd0d02eb0801
    sroi t4,a3,27
    sd t4,16(a1)
    li t0, 0x1f9f61e943737b61
    sroi t1,t0,42
    sd t1,24(a1)
    li s0, 0x915695b3f20d8a82
    sroi s4,s0,59
    sd s4,32(a1)
    li t2, 0x925c6cb79543c51a
    sroi s6,t2,62
    sd s6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
