#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s0, 0xf0774453522a1063
    sbseti a0,s0,3
    sd a0,0(a1)
    li s4, 0xedd116c18a671b8c
    sbseti t2,s4,15
    sd t2,8(a1)
    li a7, 0x8130cd0d02eb0801
    sbseti t5,a7,27
    sd t5,16(a1)
    li a7, 0x1f9f61e943737b61
    sbseti s5,a7,42
    sd s5,24(a1)
    li s3, 0x915695b3f20d8a82
    sbseti s6,s3,59
    sd s6,32(a1)
    li t2, 0x925c6cb79543c51a
    sbseti s10,t2,62
    sd s10,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
