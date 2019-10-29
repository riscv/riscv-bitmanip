#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s5, 0xf0774453522a1063
    rori t1,s5,3
    sd t1,0(a1)
    li s7, 0xedd116c18a671b8c
    rori s0,s7,15
    sd s0,8(a1)
    li s5, 0x8130cd0d02eb0801
    rori a7,s5,27
    sd a7,16(a1)
    li t2, 0x1f9f61e943737b61
    rori t1,t2,42
    sd t1,24(a1)
    li s6, 0x915695b3f20d8a82
    rori a3,s6,59
    sd a3,32(a1)
    li t4, 0x925c6cb79543c51a
    rori s10,t4,62
    sd s10,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
