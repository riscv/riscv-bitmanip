#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s6, 0xf0774453522a1063
    greviw s0,s6,3
    sd s0,0(a1)
    li a6, 0xedd116c18a671b8c
    greviw a3,a6,5
    sd a3,8(a1)
    li s4, 0x8130cd0d02eb0801
    greviw t4,s4,17
    sd t4,16(a1)
    li t2, 0x1f9f61e943737b61
    greviw t1,t2,24
    sd t1,24(a1)
    li t0, 0x915695b3f20d8a82
    greviw a3,t0,25
    sd a3,32(a1)
    li t0, 0x925c6cb79543c51a
    greviw a6,t0,31
    sd a6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
