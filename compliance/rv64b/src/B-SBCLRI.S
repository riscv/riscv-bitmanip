#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s5, 0xf0774453522a1063
    sbclri a0,s5,3
    sd a0,0(a1)
    li s10, 0xedd116c18a671b8c
    sbclri s8,s10,15
    sd s8,8(a1)
    li t2, 0x8130cd0d02eb0801
    sbclri s1,t2,27
    sd s1,16(a1)
    li s5, 0x1f9f61e943737b61
    sbclri t1,s5,42
    sd t1,24(a1)
    li a4, 0x915695b3f20d8a82
    sbclri t1,a4,59
    sd t1,32(a1)
    li a6, 0x925c6cb79543c51a
    sbclri s10,a6,62
    sd s10,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
