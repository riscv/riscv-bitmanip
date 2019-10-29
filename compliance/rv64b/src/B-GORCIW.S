#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a4, 0xf0774453522a1063
    gorciw t1,a4,3
    sd t1,0(a1)
    li t2, 0xedd116c18a671b8c
    gorciw s10,t2,5
    sd s10,8(a1)
    li a3, 0x8130cd0d02eb0801
    gorciw s7,a3,17
    sd s7,16(a1)
    li t0, 0x1f9f61e943737b61
    gorciw t1,t0,24
    sd t1,24(a1)
    li s8, 0x915695b3f20d8a82
    gorciw s10,s8,25
    sd s10,32(a1)
    li s1, 0x925c6cb79543c51a
    gorciw t2,s1,31
    sd t2,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
