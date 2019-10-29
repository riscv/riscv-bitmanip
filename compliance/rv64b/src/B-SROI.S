#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t3, 0xf0774453522a1063
    sroi s4,t3,3
    sd s4,0(a1)
    li a0, 0xedd116c18a671b8c
    sroi s7,a0,15
    sd s7,8(a1)
    li s4, 0x8130cd0d02eb0801
    sroi s2,s4,27
    sd s2,16(a1)
    li s4, 0x1f9f61e943737b61
    sroi a7,s4,42
    sd a7,24(a1)
    li a4, 0x915695b3f20d8a82
    sroi t1,a4,59
    sd t1,32(a1)
    li s4, 0x925c6cb79543c51a
    sroi s2,s4,62
    sd s2,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
