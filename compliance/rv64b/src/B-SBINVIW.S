#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a4, 0xf0774453522a1063
    sbinviw s3,a4,3
    sd s3,0(a1)
    li a3, 0xedd116c18a671b8c
    sbinviw t4,a3,5
    sd t4,8(a1)
    li s6, 0x8130cd0d02eb0801
    sbinviw a2,s6,17
    sd a2,16(a1)
    li t3, 0x1f9f61e943737b61
    sbinviw s10,t3,24
    sd s10,24(a1)
    li t2, 0x915695b3f20d8a82
    sbinviw s4,t2,25
    sd s4,32(a1)
    li t6, 0x925c6cb79543c51a
    sbinviw a6,t6,31
    sd a6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
