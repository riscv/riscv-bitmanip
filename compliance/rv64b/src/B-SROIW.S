#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a3, 0xf0774453522a1063
    sroiw t4,a3,3
    sd t4,0(a1)
    li s6, 0xedd116c18a671b8c
    sroiw a2,s6,5
    sd a2,8(a1)
    li t3, 0x8130cd0d02eb0801
    sroiw s10,t3,17
    sd s10,16(a1)
    li t2, 0x1f9f61e943737b61
    sroiw s4,t2,24
    sd s4,24(a1)
    li t6, 0x915695b3f20d8a82
    sroiw a6,t6,25
    sd a6,32(a1)
    li a0, 0x925c6cb79543c51a
    sroiw s3,a0,31
    sd s3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
