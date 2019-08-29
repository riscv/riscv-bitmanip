#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s10, 0xf0774453522a1063
    sroiw s8,s10,3
    sd s8,0(a1)
    li a7, 0xedd116c18a671b8c
    sroiw t5,a7,5
    sd t5,8(a1)
    li a7, 0x8130cd0d02eb0801
    sroiw s5,a7,17
    sd s5,16(a1)
    li t0, 0x1f9f61e943737b61
    sroiw s2,t0,24
    sd s2,24(a1)
    li a0, 0x915695b3f20d8a82
    sroiw a2,a0,25
    sd a2,32(a1)
    li t3, 0x925c6cb79543c51a
    sroiw a3,t3,31
    sd a3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
