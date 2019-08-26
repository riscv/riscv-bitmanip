#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s8, 0xf0774453522a1063
    sloiw a3,s8,3
    sd a3,0(a1)
    li t2, 0xedd116c18a671b8c
    sloiw s3,t2,5
    sd s3,8(a1)
    li s9, 0x8130cd0d02eb0801
    sloiw s5,s9,17
    sd s5,16(a1)
    li t1, 0x1f9f61e943737b61
    sloiw t5,t1,24
    sd t5,24(a1)
    li s0, 0x915695b3f20d8a82
    sloiw t6,s0,25
    sd t6,32(a1)
    li s4, 0x925c6cb79543c51a
    sloiw a7,s4,31
    sd a7,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
