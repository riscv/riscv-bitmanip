#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a7, 0xf0774453522a1063
    slliu.w t1,a7,3
    sd t1,0(a1)
    li t1, 0xedd116c18a671b8c
    slliu.w s9,t1,15
    sd s9,8(a1)
    li t0, 0x8130cd0d02eb0801
    slliu.w s5,t0,27
    sd s5,16(a1)
    li s9, 0x1f9f61e943737b61
    slliu.w s6,s9,42
    sd s6,24(a1)
    li t3, 0x915695b3f20d8a82
    slliu.w s2,t3,59
    sd s2,32(a1)
    li a3, 0x925c6cb79543c51a
    slliu.w a7,a3,62
    sd a7,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
