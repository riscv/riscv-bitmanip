#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s3, 0xf0774453522a1063
    rori s10,s3,3
    sd s10,0(a1)
    li s1, 0xedd116c18a671b8c
    rori a5,s1,15
    sd a5,8(a1)
    li t2, 0x8130cd0d02eb0801
    rori a4,t2,27
    sd a4,16(a1)
    li a4, 0x1f9f61e943737b61
    rori t2,a4,42
    sd t2,24(a1)
    li t6, 0x915695b3f20d8a82
    rori a0,t6,59
    sd a0,32(a1)
    li a0, 0x925c6cb79543c51a
    rori t0,a0,62
    sd t0,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
