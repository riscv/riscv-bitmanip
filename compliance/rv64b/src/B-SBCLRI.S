#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s6, 0xf0774453522a1063
    sbclri s9,s6,3
    sd s9,0(a1)
    li t2, 0xedd116c18a671b8c
    sbclri a4,t2,15
    sd a4,8(a1)
    li s2, 0x8130cd0d02eb0801
    sbclri a3,s2,27
    sd a3,16(a1)
    li t3, 0x1f9f61e943737b61
    sbclri s4,t3,42
    sd s4,24(a1)
    li a0, 0x915695b3f20d8a82
    sbclri s7,a0,59
    sd s7,32(a1)
    li s4, 0x925c6cb79543c51a
    sbclri s2,s4,62
    sd s2,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
