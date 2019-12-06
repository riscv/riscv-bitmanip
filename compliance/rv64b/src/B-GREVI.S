#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s7, 0xf0774453522a1063
    grevi s0,s7,3
    sd s0,0(a1)
    li s5, 0xedd116c18a671b8c
    grevi a7,s5,15
    sd a7,8(a1)
    li t2, 0x8130cd0d02eb0801
    grevi t1,t2,27
    sd t1,16(a1)
    li s6, 0x1f9f61e943737b61
    grevi a3,s6,42
    sd a3,24(a1)
    li t4, 0x915695b3f20d8a82
    grevi s10,t4,59
    sd s10,32(a1)
    li t1, 0x925c6cb79543c51a
    grevi a0,t1,62
    sd a0,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
