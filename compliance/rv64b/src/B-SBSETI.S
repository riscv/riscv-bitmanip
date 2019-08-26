#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a3, 0xf0774453522a1063
    sbseti s3,a3,3
    sd s3,0(a1)
    li t5, 0xedd116c18a671b8c
    sbseti a0,t5,15
    sd a0,8(a1)
    li t1, 0x8130cd0d02eb0801
    sbseti a3,t1,27
    sd a3,16(a1)
    li s3, 0x1f9f61e943737b61
    sbseti s10,s3,42
    sd s10,24(a1)
    li s8, 0x915695b3f20d8a82
    sbseti t0,s8,59
    sd t0,32(a1)
    li s9, 0x925c6cb79543c51a
    sbseti t2,s9,62
    sd t2,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
