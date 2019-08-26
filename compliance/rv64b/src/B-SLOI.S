#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a3, 0xf0774453522a1063
    sloi t0,a3,3
    sd t0,0(a1)
    li a7, 0xedd116c18a671b8c
    sloi t5,a7,15
    sd t5,8(a1)
    li a6, 0x8130cd0d02eb0801
    sloi s1,a6,27
    sd s1,16(a1)
    li s6, 0x1f9f61e943737b61
    sloi s2,s6,42
    sd s2,24(a1)
    li a5, 0x915695b3f20d8a82
    sloi s3,a5,59
    sd s3,32(a1)
    li s3, 0x925c6cb79543c51a
    sloi s0,s3,62
    sd s0,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
