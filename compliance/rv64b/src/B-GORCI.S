#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s7, 0xf0774453522a1063
    gorci a7,s7,3
    sd a7,0(a1)
    li s9, 0xedd116c18a671b8c
    gorci s5,s9,15
    sd s5,8(a1)
    li s5, 0x8130cd0d02eb0801
    gorci a0,s5,27
    sd a0,16(a1)
    li s10, 0x1f9f61e943737b61
    gorci s8,s10,42
    sd s8,24(a1)
    li t2, 0x915695b3f20d8a82
    gorci s1,t2,59
    sd s1,32(a1)
    li s5, 0x925c6cb79543c51a
    gorci t1,s5,62
    sd t1,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
