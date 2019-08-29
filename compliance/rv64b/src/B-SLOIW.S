#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s4, 0xf0774453522a1063
    sloiw t2,s4,3
    sd t2,0(a1)
    li t5, 0xedd116c18a671b8c
    sloiw s10,t5,5
    sd s10,8(a1)
    li t6, 0x8130cd0d02eb0801
    sloiw t2,t6,17
    sd t2,16(a1)
    li s11, 0x1f9f61e943737b61
    sloiw t4,s11,24
    sd t4,24(a1)
    li t1, 0x915695b3f20d8a82
    sloiw a0,t1,25
    sd a0,32(a1)
    li s9, 0x925c6cb79543c51a
    sloiw s10,s9,31
    sd s10,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
