#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t0, 0xf0774453522a1063
    sloiw s5,t0,3
    sd s5,0(a1)
    li t3, 0xedd116c18a671b8c
    sloiw a4,t3,5
    sd a4,8(a1)
    li t5, 0x8130cd0d02eb0801
    sloiw a3,t5,17
    sd a3,16(a1)
    li s9, 0x1f9f61e943737b61
    sloiw a7,s9,24
    sd a7,24(a1)
    li s7, 0x915695b3f20d8a82
    sloiw t0,s7,25
    sd t0,32(a1)
    li t2, 0x925c6cb79543c51a
    sloiw s6,t2,31
    sd s6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
