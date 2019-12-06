#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t1, 0xf0774453522a1063
    sloiw s9,t1,3
    sd s9,0(a1)
    li s0, 0xedd116c18a671b8c
    sloiw t3,s0,5
    sd t3,8(a1)
    li a7, 0x8130cd0d02eb0801
    sloiw s1,a7,17
    sd s1,16(a1)
    li t5, 0x1f9f61e943737b61
    sloiw s11,t5,24
    sd s11,24(a1)
    li s6, 0x915695b3f20d8a82
    sloiw t2,s6,25
    sd t2,32(a1)
    li s8, 0x925c6cb79543c51a
    sloiw s11,s8,31
    sd s11,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
