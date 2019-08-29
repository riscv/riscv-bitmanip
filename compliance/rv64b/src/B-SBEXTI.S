#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s2, 0xf0774453522a1063
    sbexti a4,s2,3
    sd a4,0(a1)
    li s3, 0xedd116c18a671b8c
    sbexti s0,s3,15
    sd s0,8(a1)
    li s7, 0x8130cd0d02eb0801
    sbexti a7,s7,27
    sd a7,16(a1)
    li t3, 0x1f9f61e943737b61
    sbexti s7,t3,42
    sd s7,24(a1)
    li s10, 0x915695b3f20d8a82
    sbexti a5,s10,59
    sd a5,32(a1)
    li s0, 0x925c6cb79543c51a
    sbexti t6,s0,62
    sd t6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
