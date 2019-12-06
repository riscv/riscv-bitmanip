#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s9, 0xf0774453522a1063
    gorciw s10,s9,3
    sd s10,0(a1)
    li a3, 0xedd116c18a671b8c
    gorciw t3,a3,5
    sd t3,8(a1)
    li s4, 0x8130cd0d02eb0801
    gorciw t4,s4,17
    sd t4,16(a1)
    li s11, 0x1f9f61e943737b61
    gorciw s1,s11,24
    sd s1,24(a1)
    li s3, 0x915695b3f20d8a82
    gorciw a5,s3,25
    sd a5,32(a1)
    li s7, 0x925c6cb79543c51a
    gorciw t5,s7,31
    sd t5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
