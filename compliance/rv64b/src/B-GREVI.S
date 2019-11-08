#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a4, 0xf0774453522a1063
    grevi t2,a4,3
    sd t2,0(a1)
    li t6, 0xedd116c18a671b8c
    grevi a0,t6,15
    sd a0,8(a1)
    li a0, 0x8130cd0d02eb0801
    grevi t0,a0,27
    sd t0,16(a1)
    li a4, 0x1f9f61e943737b61
    grevi a7,a4,42
    sd a7,24(a1)
    li t0, 0x915695b3f20d8a82
    grevi s0,t0,59
    sd s0,32(a1)
    li t2, 0x925c6cb79543c51a
    grevi s5,t2,62
    sd s5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
