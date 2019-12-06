#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s10, 0xf0774453522a1063
    sloi a5,s10,3
    sd a5,0(a1)
    li s0, 0xedd116c18a671b8c
    sloi t6,s0,15
    sd t6,8(a1)
    li t3, 0x8130cd0d02eb0801
    sloi a0,t3,27
    sd a0,16(a1)
    li t3, 0x1f9f61e943737b61
    sloi a4,t3,42
    sd a4,24(a1)
    li s11, 0x915695b3f20d8a82
    sloi t4,s11,59
    sd t4,32(a1)
    li a0, 0x925c6cb79543c51a
    sloi a2,a0,62
    sd a2,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
