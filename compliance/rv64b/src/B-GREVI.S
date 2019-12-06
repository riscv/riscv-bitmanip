#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t4, 0xf0774453522a1063
    grevi s10,t4,3
    sd s10,0(a1)
    li t1, 0xedd116c18a671b8c
    grevi a0,t1,15
    sd a0,8(a1)
    li t3, 0x8130cd0d02eb0801
    grevi a3,t3,27
    sd a3,16(a1)
    li s1, 0x1f9f61e943737b61
    grevi s8,s1,42
    sd s8,24(a1)
    li t3, 0x915695b3f20d8a82
    grevi s10,t3,59
    sd s10,32(a1)
    li s1, 0x925c6cb79543c51a
    grevi t2,s1,62
    sd t2,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
