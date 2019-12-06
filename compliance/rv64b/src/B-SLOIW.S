#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s5, 0xf0774453522a1063
    sloiw a7,s5,3
    sd a7,0(a1)
    li s1, 0xedd116c18a671b8c
    sloiw s8,s1,5
    sd s8,8(a1)
    li a3, 0x8130cd0d02eb0801
    sloiw t4,a3,17
    sd t4,16(a1)
    li t2, 0x1f9f61e943737b61
    sloiw s5,t2,24
    sd s5,24(a1)
    li a0, 0x915695b3f20d8a82
    sloiw s4,a0,25
    sd s4,32(a1)
    li t5, 0x925c6cb79543c51a
    sloiw s6,t5,31
    sd s6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
