#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t2, 0xf0774453522a1063
    sbinviw t1,t2,3
    sd t1,0(a1)
    li a4, 0xedd116c18a671b8c
    sbinviw t1,a4,5
    sd t1,8(a1)
    li a3, 0x8130cd0d02eb0801
    sbinviw a4,a3,17
    sd a4,16(a1)
    li a3, 0x1f9f61e943737b61
    sbinviw t3,a3,24
    sd t3,24(a1)
    li a6, 0x915695b3f20d8a82
    sbinviw s10,a6,25
    sd s10,32(a1)
    li a5, 0x925c6cb79543c51a
    sbinviw s4,a5,31
    sd s4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
