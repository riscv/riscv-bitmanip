#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a0, 0xf0774453522a1063
    sbinviw s3,a0,3
    sd s3,0(a1)
    li s2, 0xedd116c18a671b8c
    sbinviw t4,s2,5
    sd t4,8(a1)
    li a6, 0x8130cd0d02eb0801
    sbinviw a3,a6,17
    sd a3,16(a1)
    li s9, 0x1f9f61e943737b61
    sbinviw t3,s9,24
    sd t3,24(a1)
    li s6, 0x915695b3f20d8a82
    sbinviw s0,s6,25
    sd s0,32(a1)
    li t2, 0x925c6cb79543c51a
    sbinviw s4,t2,31
    sd s4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
