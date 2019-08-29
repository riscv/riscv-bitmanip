#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t6, 0xf0774453522a1063
    slliu.w s9,t6,3
    sd s9,0(a1)
    li s9, 0xedd116c18a671b8c
    slliu.w a2,s9,15
    sd a2,8(a1)
    li t1, 0x8130cd0d02eb0801
    slliu.w t5,t1,27
    sd t5,16(a1)
    li s2, 0x1f9f61e943737b61
    slliu.w t4,s2,42
    sd t4,24(a1)
    li s4, 0x915695b3f20d8a82
    slliu.w t5,s4,59
    sd t5,32(a1)
    li a3, 0x925c6cb79543c51a
    slliu.w s9,a3,62
    sd s9,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
