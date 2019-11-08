#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t2, 0xf0774453522a1063
    sloi s3,t2,3
    sd s3,0(a1)
    li a0, 0xedd116c18a671b8c
    sloi a4,a0,15
    sd a4,8(a1)
    li a0, 0x8130cd0d02eb0801
    sloi t3,a0,27
    sd t3,16(a1)
    li a7, 0x1f9f61e943737b61
    sloi s2,a7,42
    sd s2,24(a1)
    li s4, 0x915695b3f20d8a82
    sloi s9,s4,59
    sd s9,32(a1)
    li a3, 0x925c6cb79543c51a
    sloi a4,a3,62
    sd a4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
