#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t1, 0xf0774453522a1063
    roriw a0,t1,3
    sd a0,0(a1)
    li s9, 0xedd116c18a671b8c
    roriw s10,s9,5
    sd s10,8(a1)
    li a3, 0x8130cd0d02eb0801
    roriw t3,a3,17
    sd t3,16(a1)
    li s4, 0x1f9f61e943737b61
    roriw t4,s4,24
    sd t4,24(a1)
    li s11, 0x915695b3f20d8a82
    roriw s1,s11,25
    sd s1,32(a1)
    li s3, 0x925c6cb79543c51a
    roriw a5,s3,31
    sd a5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
