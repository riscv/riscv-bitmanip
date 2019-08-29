#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s9, 0xf0774453522a1063
    sloi s3,s9,3
    sd s3,0(a1)
    li t6, 0xedd116c18a671b8c
    sloi a2,t6,15
    sd a2,8(a1)
    li s9, 0x8130cd0d02eb0801
    sloi t2,s9,27
    sd t2,16(a1)
    li a0, 0x1f9f61e943737b61
    sloi s10,a0,42
    sd s10,24(a1)
    li s0, 0x915695b3f20d8a82
    sloi a2,s0,59
    sd a2,32(a1)
    li s0, 0x925c6cb79543c51a
    sloi a0,s0,62
    sd a0,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
