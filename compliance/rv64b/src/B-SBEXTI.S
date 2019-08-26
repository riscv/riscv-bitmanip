#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a6, 0xf0774453522a1063
    sbexti a3,a6,3
    sd a3,0(a1)
    li a6, 0xedd116c18a671b8c
    sbexti s6,a6,15
    sd s6,8(a1)
    li t1, 0x8130cd0d02eb0801
    sbexti t6,t1,27
    sd t6,16(a1)
    li s7, 0x1f9f61e943737b61
    sbexti a7,s7,42
    sd a7,24(a1)
    li t2, 0x915695b3f20d8a82
    sbexti a4,t2,59
    sd a4,32(a1)
    li t0, 0x925c6cb79543c51a
    sbexti s9,t0,62
    sd s9,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
