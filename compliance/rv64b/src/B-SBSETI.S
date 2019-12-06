#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s3, 0xf0774453522a1063
    sbseti s6,s3,3
    sd s6,0(a1)
    li t2, 0xedd116c18a671b8c
    sbseti s10,t2,15
    sd s10,8(a1)
    li a5, 0x8130cd0d02eb0801
    sbseti s4,a5,27
    sd s4,16(a1)
    li s9, 0x1f9f61e943737b61
    sbseti a7,s9,42
    sd a7,24(a1)
    li a5, 0x915695b3f20d8a82
    sbseti s5,a5,59
    sd s5,32(a1)
    li s3, 0x925c6cb79543c51a
    sbseti a5,s3,62
    sd a5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
