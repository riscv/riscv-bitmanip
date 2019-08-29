#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t5, 0xf0774453522a1063
    shfli a3,t5,3
    sd a3,0(a1)
    li a3, 0xedd116c18a671b8c
    shfli t3,a3,5
    sd t3,8(a1)
    li s1, 0x8130cd0d02eb0801
    shfli s8,s1,17
    sd s8,16(a1)
    li t0, 0x1f9f61e943737b61
    shfli t1,t0,24
    sd t1,24(a1)
    li s9, 0x915695b3f20d8a82
    shfli a7,s9,25
    sd a7,32(a1)
    li s4, 0x925c6cb79543c51a
    shfli t4,s4,31
    sd t4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
