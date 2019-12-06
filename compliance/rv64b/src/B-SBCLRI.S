#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a4, 0xf0774453522a1063
    sbclri t1,a4,3
    sd t1,0(a1)
    li a6, 0xedd116c18a671b8c
    sbclri s10,a6,15
    sd s10,8(a1)
    li t5, 0x8130cd0d02eb0801
    sbclri a3,t5,27
    sd a3,16(a1)
    li t5, 0x1f9f61e943737b61
    sbclri t0,t5,42
    sd t0,24(a1)
    li s11, 0x915695b3f20d8a82
    sbclri s1,s11,59
    sd s1,32(a1)
    li t3, 0x925c6cb79543c51a
    sbclri s11,t3,62
    sd s11,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
