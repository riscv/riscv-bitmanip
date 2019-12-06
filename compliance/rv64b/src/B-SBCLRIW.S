#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t5, 0xf0774453522a1063
    sbclriw a3,t5,3
    sd a3,0(a1)
    li s9, 0xedd116c18a671b8c
    sbclriw a7,s9,5
    sd a7,8(a1)
    li s7, 0x8130cd0d02eb0801
    sbclriw t0,s7,17
    sd t0,16(a1)
    li t2, 0x1f9f61e943737b61
    sbclriw s6,t2,24
    sd s6,24(a1)
    li t1, 0x915695b3f20d8a82
    sbclriw s9,t1,25
    sd s9,32(a1)
    li s0, 0x925c6cb79543c51a
    sbclriw t3,s0,31
    sd t3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
