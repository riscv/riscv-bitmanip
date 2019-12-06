#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s4, 0xf0774453522a1063
    shfli t3,s4,3
    sd t3,0(a1)
    li t4, 0xedd116c18a671b8c
    shfli t6,t4,5
    sd t6,8(a1)
    li a2, 0x8130cd0d02eb0801
    shfli t0,a2,17
    sd t0,16(a1)
    li a7, 0x1f9f61e943737b61
    shfli s1,a7,24
    sd s1,24(a1)
    li s9, 0x915695b3f20d8a82
    shfli a4,s9,25
    sd a4,32(a1)
    li a5, 0x925c6cb79543c51a
    shfli a7,a5,31
    sd a7,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
