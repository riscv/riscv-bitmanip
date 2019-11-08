#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a3, 0xf0774453522a1063
    sbclri a0,a3,3
    sd a0,0(a1)
    li t3, 0xedd116c18a671b8c
    sbclri a6,t3,15
    sd a6,8(a1)
    li a2, 0x8130cd0d02eb0801
    sbclri s1,a2,27
    sd s1,16(a1)
    li t5, 0x1f9f61e943737b61
    sbclri s10,t5,42
    sd s10,24(a1)
    li t6, 0x915695b3f20d8a82
    sbclri t2,t6,59
    sd t2,32(a1)
    li t0, 0x925c6cb79543c51a
    sbclri s2,t0,62
    sd s2,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
