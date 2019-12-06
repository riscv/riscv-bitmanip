#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a5, 0xf0774453522a1063
    slliu.w s2,a5,3
    sd s2,0(a1)
    li s10, 0xedd116c18a671b8c
    slliu.w s2,s10,15
    sd s2,8(a1)
    li s6, 0x8130cd0d02eb0801
    slliu.w s11,s6,27
    sd s11,16(a1)
    li t1, 0x1f9f61e943737b61
    slliu.w a4,t1,42
    sd a4,24(a1)
    li t1, 0x915695b3f20d8a82
    slliu.w a2,t1,59
    sd a2,32(a1)
    li s3, 0x925c6cb79543c51a
    slliu.w s8,s3,62
    sd s8,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
