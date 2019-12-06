#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s0, 0xf0774453522a1063
    gorciw s3,s0,3
    sd s3,0(a1)
    li s8, 0xedd116c18a671b8c
    gorciw t5,s8,5
    sd t5,8(a1)
    li a2, 0x8130cd0d02eb0801
    gorciw t0,a2,17
    sd t0,16(a1)
    li s10, 0x1f9f61e943737b61
    gorciw s4,s10,24
    sd s4,24(a1)
    li t2, 0x915695b3f20d8a82
    gorciw s1,t2,25
    sd s1,32(a1)
    li a3, 0x925c6cb79543c51a
    gorciw s5,a3,31
    sd s5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
