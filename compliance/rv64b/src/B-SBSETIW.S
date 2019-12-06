#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a5, 0xf0774453522a1063
    sbsetiw s4,a5,3
    sd s4,0(a1)
    li s2, 0xedd116c18a671b8c
    sbsetiw t6,s2,5
    sd t6,8(a1)
    li s0, 0x8130cd0d02eb0801
    sbsetiw s4,s0,17
    sd s4,16(a1)
    li s9, 0x1f9f61e943737b61
    sbsetiw s11,s9,24
    sd s11,24(a1)
    li s6, 0x915695b3f20d8a82
    sbsetiw s0,s6,25
    sd s0,32(a1)
    li a6, 0x925c6cb79543c51a
    sbsetiw a3,a6,31
    sd a3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
