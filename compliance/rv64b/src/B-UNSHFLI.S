#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s11, 0xf0774453522a1063
    unshfli s10,s11,3
    sd s10,0(a1)
    li s2, 0xedd116c18a671b8c
    unshfli t4,s2,5
    sd t4,8(a1)
    li s4, 0x8130cd0d02eb0801
    unshfli t4,s4,17
    sd t4,16(a1)
    li a0, 0x1f9f61e943737b61
    unshfli a7,a0,24
    sd a7,24(a1)
    li t0, 0x915695b3f20d8a82
    unshfli s0,t0,25
    sd s0,32(a1)
    li a6, 0x925c6cb79543c51a
    unshfli a3,a6,31
    sd a3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
