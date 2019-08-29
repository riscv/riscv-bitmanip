#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s1, 0xf0774453522a1063
    gorci s2,s1,3
    sd s2,0(a1)
    li a5, 0xedd116c18a671b8c
    gorci s3,a5,15
    sd s3,8(a1)
    li s4, 0x8130cd0d02eb0801
    gorci s2,s4,27
    sd s2,16(a1)
    li s4, 0x1f9f61e943737b61
    gorci a3,s4,42
    sd a3,24(a1)
    li a3, 0x915695b3f20d8a82
    gorci a0,a3,59
    sd a0,32(a1)
    li t3, 0x925c6cb79543c51a
    gorci a6,t3,62
    sd a6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
