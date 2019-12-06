#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s5, 0xf0774453522a1063
    sroiw a6,s5,3
    sd a6,0(a1)
    li a4, 0xedd116c18a671b8c
    sroiw t5,a4,5
    sd t5,8(a1)
    li a0, 0x8130cd0d02eb0801
    sroiw a7,a0,17
    sd a7,16(a1)
    li s5, 0x1f9f61e943737b61
    sroiw a4,s5,24
    sd a4,24(a1)
    li s5, 0x915695b3f20d8a82
    sroiw s10,s5,25
    sd s10,32(a1)
    li a2, 0x925c6cb79543c51a
    sroiw s4,a2,31
    sd s4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
