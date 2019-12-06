#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t3, 0xf0774453522a1063
    sroi a6,t3,3
    sd a6,0(a1)
    li a2, 0xedd116c18a671b8c
    sroi s1,a2,15
    sd s1,8(a1)
    li t5, 0x8130cd0d02eb0801
    sroi s10,t5,27
    sd s10,16(a1)
    li t6, 0x1f9f61e943737b61
    sroi t2,t6,42
    sd t2,24(a1)
    li t0, 0x915695b3f20d8a82
    sroi s2,t0,59
    sd s2,32(a1)
    li s5, 0x925c6cb79543c51a
    sroi s10,s5,62
    sd s10,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
