#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t4, 0xf0774453522a1063
    sbclri t1,t4,3
    sd t1,0(a1)
    li s0, 0xedd116c18a671b8c
    sbclri t1,s0,15
    sd t1,8(a1)
    li a3, 0x8130cd0d02eb0801
    sbclri s10,a3,27
    sd s10,16(a1)
    li s2, 0x1f9f61e943737b61
    sbclri t1,s2,42
    sd t1,24(a1)
    li s1, 0x915695b3f20d8a82
    sbclri a5,s1,59
    sd a5,32(a1)
    li s9, 0x925c6cb79543c51a
    sbclri s0,s9,62
    sd s0,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
