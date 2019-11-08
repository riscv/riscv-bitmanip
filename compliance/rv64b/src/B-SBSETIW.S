#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a0, 0xf0774453522a1063
    sbsetiw a2,a0,3
    sd a2,0(a1)
    li t3, 0xedd116c18a671b8c
    sbsetiw a3,t3,5
    sd a3,8(a1)
    li s2, 0x8130cd0d02eb0801
    sbsetiw s0,s2,17
    sd s0,16(a1)
    li s0, 0x1f9f61e943737b61
    sbsetiw s9,s0,24
    sd s9,24(a1)
    li a7, 0x915695b3f20d8a82
    sbsetiw s10,a7,25
    sd s10,32(a1)
    li t3, 0x925c6cb79543c51a
    sbsetiw s11,t3,31
    sd s11,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
