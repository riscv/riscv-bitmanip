#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s0, 0xf0774453522a1063
    sbexti a2,s0,3
    sd a2,0(a1)
    li s0, 0xedd116c18a671b8c
    sbexti a0,s0,15
    sd a0,8(a1)
    li s4, 0x8130cd0d02eb0801
    sbexti t2,s4,27
    sd t2,16(a1)
    li a7, 0x1f9f61e943737b61
    sbexti t5,a7,42
    sd t5,24(a1)
    li a7, 0x915695b3f20d8a82
    sbexti s5,a7,59
    sd s5,32(a1)
    li s3, 0x925c6cb79543c51a
    sbexti s6,s3,62
    sd s6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
