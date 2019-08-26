#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s3, 0xf0774453522a1063
    rori s7,s3,3
    sd s7,0(a1)
    li a3, 0xedd116c18a671b8c
    rori s6,a3,15
    sd s6,8(a1)
    li t2, 0x8130cd0d02eb0801
    rori s11,t2,27
    sd s11,16(a1)
    li s0, 0x1f9f61e943737b61
    rori a3,s0,42
    sd a3,24(a1)
    li t6, 0x915695b3f20d8a82
    rori a2,t6,59
    sd a2,32(a1)
    li t2, 0x925c6cb79543c51a
    rori s10,t2,62
    sd s10,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
