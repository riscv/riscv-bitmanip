#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a3, 0xf0774453522a1063
    roriw s7,a3,3
    sd s7,0(a1)
    li t0, 0xedd116c18a671b8c
    roriw t1,t0,5
    sd t1,8(a1)
    li s8, 0x8130cd0d02eb0801
    roriw s10,s8,17
    sd s10,16(a1)
    li s1, 0x1f9f61e943737b61
    roriw t2,s1,24
    sd t2,24(a1)
    li s0, 0x915695b3f20d8a82
    roriw s3,s0,25
    sd s3,32(a1)
    li s8, 0x925c6cb79543c51a
    roriw t5,s8,31
    sd t5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
