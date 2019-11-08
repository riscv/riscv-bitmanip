#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s9, 0xf0774453522a1063
    sroiw a7,s9,3
    sd a7,0(a1)
    li a4, 0xedd116c18a671b8c
    sroiw s9,a4,5
    sd s9,8(a1)
    li s7, 0x8130cd0d02eb0801
    sroiw a4,s7,17
    sd a4,16(a1)
    li t5, 0x1f9f61e943737b61
    sroiw t0,t5,24
    sd t0,24(a1)
    li a5, 0x915695b3f20d8a82
    sroiw s5,a5,25
    sd s5,32(a1)
    li t4, 0x925c6cb79543c51a
    sroiw s9,t4,31
    sd s9,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
