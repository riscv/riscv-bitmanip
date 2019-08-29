#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a2, 0xf0774453522a1063
    gorciw s1,a2,3
    sd s1,0(a1)
    li t3, 0xedd116c18a671b8c
    gorciw a0,t3,5
    sd a0,8(a1)
    li s6, 0x8130cd0d02eb0801
    gorciw a3,s6,17
    sd a3,16(a1)
    li s4, 0x1f9f61e943737b61
    gorciw s2,s4,24
    sd s2,24(a1)
    li t0, 0x915695b3f20d8a82
    gorciw s5,t0,25
    sd s5,32(a1)
    li t3, 0x925c6cb79543c51a
    gorciw a4,t3,31
    sd a4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
