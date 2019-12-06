#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a0, 0xf0774453522a1063
    sbsetiw s6,a0,3
    sd s6,0(a1)
    li s11, 0xedd116c18a671b8c
    sbsetiw s10,s11,5
    sd s10,8(a1)
    li t0, 0x8130cd0d02eb0801
    sbsetiw s0,t0,17
    sd s0,16(a1)
    li a2, 0x1f9f61e943737b61
    sbsetiw s4,a2,24
    sd s4,24(a1)
    li a3, 0x915695b3f20d8a82
    sbsetiw a6,a3,25
    sd a6,32(a1)
    li s10, 0x925c6cb79543c51a
    sbsetiw a7,s10,31
    sd a7,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
