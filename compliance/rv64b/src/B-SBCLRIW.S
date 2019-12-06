#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t5, 0xf0774453522a1063
    sbclriw s6,t5,3
    sd s6,0(a1)
    li t4, 0xedd116c18a671b8c
    sbclriw t6,t4,5
    sd t6,8(a1)
    li a5, 0x8130cd0d02eb0801
    sbclriw a7,a5,17
    sd a7,16(a1)
    li s5, 0x1f9f61e943737b61
    sbclriw t0,s5,24
    sd t0,24(a1)
    li a3, 0x915695b3f20d8a82
    sbclriw a5,a3,25
    sd a5,32(a1)
    li s11, 0x925c6cb79543c51a
    sbclriw t4,s11,31
    sd t4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
