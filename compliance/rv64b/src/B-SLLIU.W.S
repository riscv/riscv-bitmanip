#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s10, 0xf0774453522a1063
    slliu.w s4,s10,3
    sd s4,0(a1)
    li t2, 0xedd116c18a671b8c
    slliu.w t1,t2,15
    sd t1,8(a1)
    li t5, 0x8130cd0d02eb0801
    slliu.w s11,t5,27
    sd s11,16(a1)
    li s5, 0x1f9f61e943737b61
    slliu.w a4,s5,42
    sd a4,24(a1)
    li s7, 0x915695b3f20d8a82
    slliu.w s5,s7,59
    sd s5,32(a1)
    li a2, 0x925c6cb79543c51a
    slliu.w s4,a2,62
    sd s4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
