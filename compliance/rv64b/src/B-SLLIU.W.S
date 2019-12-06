#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t5, 0xf0774453522a1063
    slliu.w s6,t5,3
    sd s6,0(a1)
    li s10, 0xedd116c18a671b8c
    slliu.w a7,s10,15
    sd a7,8(a1)
    li s10, 0x8130cd0d02eb0801
    slliu.w s6,s10,27
    sd s6,16(a1)
    li a3, 0x1f9f61e943737b61
    slliu.w a4,a3,42
    sd a4,24(a1)
    li s6, 0x915695b3f20d8a82
    slliu.w s5,s6,59
    sd s5,32(a1)
    li t0, 0x925c6cb79543c51a
    slliu.w t5,t0,62
    sd t5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
