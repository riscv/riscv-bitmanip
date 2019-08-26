#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t0, 0xf0774453522a1063
    unshfli s0,t0,3
    sd s0,0(a1)
    li a4, 0xedd116c18a671b8c
    unshfli t1,a4,5
    sd t1,8(a1)
    li t3, 0x8130cd0d02eb0801
    unshfli a4,t3,17
    sd a4,16(a1)
    li a7, 0x1f9f61e943737b61
    unshfli s5,a7,24
    sd s5,24(a1)
    li s5, 0x915695b3f20d8a82
    unshfli t1,s5,25
    sd t1,32(a1)
    li a3, 0x925c6cb79543c51a
    unshfli a4,a3,31
    sd a4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
