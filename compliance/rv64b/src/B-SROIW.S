#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s7, 0xf0774453522a1063
    sroiw a7,s7,3
    sd a7,0(a1)
    li t3, 0xedd116c18a671b8c
    sroiw s4,t3,5
    sd s4,8(a1)
    li t6, 0x8130cd0d02eb0801
    sroiw a0,t6,17
    sd a0,16(a1)
    li s0, 0x1f9f61e943737b61
    sroiw a0,s0,24
    sd a0,24(a1)
    li a2, 0x915695b3f20d8a82
    sroiw s1,a2,25
    sd s1,32(a1)
    li t2, 0x925c6cb79543c51a
    sroiw t1,t2,31
    sd t1,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
