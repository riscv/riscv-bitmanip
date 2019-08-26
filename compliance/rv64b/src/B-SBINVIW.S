#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s7, 0xf0774453522a1063
    sbinviw a7,s7,3
    sd a7,0(a1)
    li s10, 0xedd116c18a671b8c
    sbinviw a4,s10,5
    sd a4,8(a1)
    li s10, 0x8130cd0d02eb0801
    sbinviw a5,s10,17
    sd a5,16(a1)
    li s4, 0x1f9f61e943737b61
    sbinviw s2,s4,24
    sd s2,24(a1)
    li a4, 0x915695b3f20d8a82
    sbinviw a7,a4,25
    sd a7,32(a1)
    li a7, 0x925c6cb79543c51a
    sbinviw t5,a7,31
    sd t5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
