#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s0, 0xf0774453522a1063
    sbsetiw s10,s0,3
    sd s10,0(a1)
    li t3, 0xedd116c18a671b8c
    sbsetiw s7,t3,5
    sd s7,8(a1)
    li a0, 0x8130cd0d02eb0801
    sbsetiw s7,a0,17
    sd s7,16(a1)
    li a0, 0x1f9f61e943737b61
    sbsetiw t0,a0,24
    sd t0,24(a1)
    li s4, 0x915695b3f20d8a82
    sbsetiw t2,s4,25
    sd t2,32(a1)
    li t5, 0x925c6cb79543c51a
    sbsetiw s10,t5,31
    sd s10,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
