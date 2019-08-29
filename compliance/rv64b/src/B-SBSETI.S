#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s2, 0xf0774453522a1063
    sbseti t1,s2,3
    sd t1,0(a1)
    li s10, 0xedd116c18a671b8c
    sbseti a5,s10,15
    sd a5,8(a1)
    li t0, 0x8130cd0d02eb0801
    sbseti s9,t0,27
    sd s9,16(a1)
    li t2, 0x1f9f61e943737b61
    sbseti s3,t2,42
    sd s3,24(a1)
    li a0, 0x915695b3f20d8a82
    sbseti a4,a0,59
    sd a4,32(a1)
    li a0, 0x925c6cb79543c51a
    sbseti t3,a0,62
    sd t3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
