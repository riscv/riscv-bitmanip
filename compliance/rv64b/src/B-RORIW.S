#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a4, 0xf0774453522a1063
    roriw a7,a4,3
    sd a7,0(a1)
    li t2, 0xedd116c18a671b8c
    roriw s1,t2,5
    sd s1,8(a1)
    li a7, 0x8130cd0d02eb0801
    roriw s5,a7,17
    sd s5,16(a1)
    li t2, 0x1f9f61e943737b61
    roriw a2,t2,24
    sd a2,24(a1)
    li s5, 0x915695b3f20d8a82
    roriw s10,s5,25
    sd s10,32(a1)
    li s5, 0x925c6cb79543c51a
    roriw a7,s5,31
    sd a7,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
