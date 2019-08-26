#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t2, 0xf0774453522a1063
    shfli s1,t2,3
    sd s1,0(a1)
    li s4, 0xedd116c18a671b8c
    shfli s9,s4,5
    sd s9,8(a1)
    li s6, 0x8130cd0d02eb0801
    shfli a3,s6,17
    sd a3,16(a1)
    li t6, 0x1f9f61e943737b61
    shfli t2,t6,24
    sd t2,24(a1)
    li a7, 0x915695b3f20d8a82
    shfli s5,a7,25
    sd s5,32(a1)
    li t2, 0x925c6cb79543c51a
    shfli s5,t2,31
    sd s5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
