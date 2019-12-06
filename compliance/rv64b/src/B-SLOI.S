#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s11, 0xf0774453522a1063
    sloi t4,s11,3
    sd t4,0(a1)
    li a0, 0xedd116c18a671b8c
    sloi a2,a0,15
    sd a2,8(a1)
    li s5, 0x8130cd0d02eb0801
    sloi a7,s5,27
    sd a7,16(a1)
    li s6, 0x1f9f61e943737b61
    sloi a2,s6,42
    sd a2,24(a1)
    li s8, 0x915695b3f20d8a82
    sloi s10,s8,59
    sd s10,32(a1)
    li s9, 0x925c6cb79543c51a
    sloi s11,s9,62
    sd s11,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
