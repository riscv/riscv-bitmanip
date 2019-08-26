#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t1, 0xf0774453522a1063
    sroi a5,t1,3
    sd a5,0(a1)
    li s6, 0xedd116c18a671b8c
    sroi t3,s6,15
    sd t3,8(a1)
    li s11, 0x8130cd0d02eb0801
    sroi s5,s11,27
    sd s5,16(a1)
    li s9, 0x1f9f61e943737b61
    sroi s3,s9,42
    sd s3,24(a1)
    li a0, 0x915695b3f20d8a82
    sroi a5,a0,59
    sd a5,32(a1)
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
