#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s7, 0xf0774453522a1063
    roriw t5,s7,3
    sd t5,0(a1)
    li s4, 0xedd116c18a671b8c
    roriw t3,s4,5
    sd t3,8(a1)
    li s9, 0x8130cd0d02eb0801
    roriw a4,s9,17
    sd a4,16(a1)
    li s7, 0x1f9f61e943737b61
    roriw s5,s7,24
    sd s5,24(a1)
    li a3, 0x915695b3f20d8a82
    roriw s11,a3,25
    sd s11,32(a1)
    li s4, 0x925c6cb79543c51a
    roriw s6,s4,31
    sd s6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
