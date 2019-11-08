#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s10, 0xf0774453522a1063
    sbinvi a4,s10,3
    sd a4,0(a1)
    li t1, 0xedd116c18a671b8c
    sbinvi t5,t1,15
    sd t5,8(a1)
    li s10, 0x8130cd0d02eb0801
    sbinvi s4,s10,27
    sd s4,16(a1)
    li t5, 0x1f9f61e943737b61
    sbinvi s10,t5,42
    sd s10,24(a1)
    li a7, 0x915695b3f20d8a82
    sbinvi s5,a7,59
    sd s5,32(a1)
    li t2, 0x925c6cb79543c51a
    sbinvi a2,t2,62
    sd a2,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
