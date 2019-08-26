#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a0, 0xf0774453522a1063
    sbclriw s10,a0,3
    sd s10,0(a1)
    li a3, 0xedd116c18a671b8c
    sbclriw a0,a3,5
    sd a0,8(a1)
    li s7, 0x8130cd0d02eb0801
    sbclriw s0,s7,17
    sd s0,16(a1)
    li a0, 0x1f9f61e943737b61
    sbclriw t3,a0,24
    sd t3,24(a1)
    li s10, 0x915695b3f20d8a82
    sbclriw s8,s10,25
    sd s8,32(a1)
    li t5, 0x925c6cb79543c51a
    sbclriw s10,t5,31
    sd s10,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
