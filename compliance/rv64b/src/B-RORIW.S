#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s4, 0xf0774453522a1063
    roriw a3,s4,3
    sd a3,0(a1)
    li s5, 0xedd116c18a671b8c
    roriw t1,s5,5
    sd t1,8(a1)
    li a0, 0x8130cd0d02eb0801
    roriw a4,a0,17
    sd a4,16(a1)
    li s5, 0x1f9f61e943737b61
    roriw a0,s5,24
    sd a0,24(a1)
    li s10, 0x915695b3f20d8a82
    roriw s4,s10,25
    sd s4,32(a1)
    li t3, 0x925c6cb79543c51a
    roriw a0,t3,31
    sd a0,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
