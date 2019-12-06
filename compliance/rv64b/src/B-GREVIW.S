#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t3, 0xf0774453522a1063
    greviw a3,t3,3
    sd a3,0(a1)
    li s2, 0xedd116c18a671b8c
    greviw s0,s2,5
    sd s0,8(a1)
    li s0, 0x8130cd0d02eb0801
    greviw s9,s0,17
    sd s9,16(a1)
    li a7, 0x1f9f61e943737b61
    greviw s10,a7,24
    sd s10,24(a1)
    li t3, 0x915695b3f20d8a82
    greviw s11,t3,25
    sd s11,32(a1)
    li a0, 0x925c6cb79543c51a
    greviw s6,a0,31
    sd s6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
