#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s7, 0xf0774453522a1063
    unshfli a4,s7,3
    sd a4,0(a1)
    li s2, 0xedd116c18a671b8c
    unshfli s0,s2,5
    sd s0,8(a1)
    li s6, 0x8130cd0d02eb0801
    unshfli a2,s6,17
    sd a2,16(a1)
    li s2, 0x1f9f61e943737b61
    unshfli t6,s2,24
    sd t6,24(a1)
    li t5, 0x915695b3f20d8a82
    unshfli t0,t5,25
    sd t0,32(a1)
    li s0, 0x925c6cb79543c51a
    unshfli s9,s0,31
    sd s9,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
