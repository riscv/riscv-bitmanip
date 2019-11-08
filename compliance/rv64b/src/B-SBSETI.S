#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t3, 0xf0774453522a1063
    sbseti s7,t3,3
    sd s7,0(a1)
    li s10, 0xedd116c18a671b8c
    sbseti a5,s10,15
    sd a5,8(a1)
    li s0, 0x8130cd0d02eb0801
    sbseti t6,s0,27
    sd t6,16(a1)
    li t3, 0x1f9f61e943737b61
    sbseti a0,t3,42
    sd a0,24(a1)
    li t3, 0x915695b3f20d8a82
    sbseti a4,t3,59
    sd a4,32(a1)
    li s11, 0x925c6cb79543c51a
    sbseti t4,s11,62
    sd t4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
