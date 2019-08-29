#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s4, 0xf0774453522a1063
    sbclriw a7,s4,3
    sd a7,0(a1)
    li s4, 0xedd116c18a671b8c
    sbclriw s9,s4,5
    sd s9,8(a1)
    li t2, 0x8130cd0d02eb0801
    sbclriw s5,t2,17
    sd s5,16(a1)
    li a4, 0x1f9f61e943737b61
    sbclriw t1,a4,24
    sd t1,24(a1)
    li t2, 0x915695b3f20d8a82
    sbclriw s10,t2,25
    sd s10,32(a1)
    li a3, 0x925c6cb79543c51a
    sbclriw s7,a3,31
    sd s7,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
