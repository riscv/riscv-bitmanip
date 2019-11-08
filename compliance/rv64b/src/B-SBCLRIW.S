#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s5, 0xf0774453522a1063
    sbclriw s10,s5,3
    sd s10,0(a1)
    li s5, 0xedd116c18a671b8c
    sbclriw a7,s5,5
    sd a7,8(a1)
    li s1, 0x8130cd0d02eb0801
    sbclriw s8,s1,17
    sd s8,16(a1)
    li a3, 0x1f9f61e943737b61
    sbclriw t4,a3,24
    sd t4,24(a1)
    li t2, 0x915695b3f20d8a82
    sbclriw s5,t2,25
    sd s5,32(a1)
    li a0, 0x925c6cb79543c51a
    sbclriw s4,a0,31
    sd s4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
