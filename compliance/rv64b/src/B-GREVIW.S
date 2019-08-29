#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s10, 0xf0774453522a1063
    greviw s4,s10,3
    sd s4,0(a1)
    li t5, 0xedd116c18a671b8c
    greviw s10,t5,5
    sd s10,8(a1)
    li t3, 0x8130cd0d02eb0801
    greviw a4,t3,17
    sd a4,16(a1)
    li t4, 0x1f9f61e943737b61
    greviw s10,t4,24
    sd s10,24(a1)
    li s9, 0x915695b3f20d8a82
    greviw a7,s9,25
    sd a7,32(a1)
    li a4, 0x925c6cb79543c51a
    greviw s9,a4,31
    sd s9,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
