#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s6, 0xf0774453522a1063
    grevi s2,s6,3
    sd s2,0(a1)
    li a0, 0xedd116c18a671b8c
    grevi a5,a0,15
    sd a5,8(a1)
    li t2, 0x8130cd0d02eb0801
    grevi s10,t2,27
    sd s10,16(a1)
    li s0, 0x1f9f61e943737b61
    grevi s10,s0,42
    sd s10,24(a1)
    li s10, 0x915695b3f20d8a82
    grevi a4,s10,59
    sd a4,32(a1)
    li t1, 0x925c6cb79543c51a
    grevi t5,t1,62
    sd t5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
