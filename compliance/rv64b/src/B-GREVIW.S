#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a3, 0xf0774453522a1063
    greviw t3,a3,3
    sd t3,0(a1)
    li a6, 0xedd116c18a671b8c
    greviw s10,a6,5
    sd s10,8(a1)
    li a5, 0x8130cd0d02eb0801
    greviw s4,a5,17
    sd s4,16(a1)
    li s2, 0x1f9f61e943737b61
    greviw t6,s2,24
    sd t6,24(a1)
    li s0, 0x915695b3f20d8a82
    greviw s4,s0,25
    sd s4,32(a1)
    li s9, 0x925c6cb79543c51a
    greviw s11,s9,31
    sd s11,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
