#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s2, 0xf0774453522a1063
    greviw a3,s2,3
    sd a3,0(a1)
    li a4, 0xedd116c18a671b8c
    greviw t2,a4,5
    sd t2,8(a1)
    li s0, 0x8130cd0d02eb0801
    greviw a2,s0,17
    sd a2,16(a1)
    li t3, 0x1f9f61e943737b61
    greviw a6,t3,24
    sd a6,24(a1)
    li s5, 0x915695b3f20d8a82
    greviw a7,s5,25
    sd a7,32(a1)
    li a7, 0x925c6cb79543c51a
    greviw s2,a7,31
    sd s2,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
