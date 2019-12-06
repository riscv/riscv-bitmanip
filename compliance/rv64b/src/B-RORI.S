#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t2, 0xf0774453522a1063
    rori a2,t2,3
    sd a2,0(a1)
    li a4, 0xedd116c18a671b8c
    rori s3,a4,15
    sd s3,8(a1)
    li a3, 0x8130cd0d02eb0801
    rori s7,a3,27
    sd s7,16(a1)
    li s2, 0x1f9f61e943737b61
    rori t6,s2,42
    sd t6,24(a1)
    li s7, 0x915695b3f20d8a82
    rori t0,s7,59
    sd t0,32(a1)
    li t4, 0x925c6cb79543c51a
    rori s9,t4,62
    sd s9,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
