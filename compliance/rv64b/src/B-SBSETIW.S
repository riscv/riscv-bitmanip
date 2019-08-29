#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a7, 0xf0774453522a1063
    sbsetiw s2,a7,3
    sd s2,0(a1)
    li t0, 0xedd116c18a671b8c
    sbsetiw s0,t0,5
    sd s0,8(a1)
    li s5, 0x8130cd0d02eb0801
    sbsetiw t1,s5,17
    sd t1,16(a1)
    li s3, 0x1f9f61e943737b61
    sbsetiw s6,s3,24
    sd s6,24(a1)
    li a4, 0x915695b3f20d8a82
    sbsetiw s3,a4,25
    sd s3,32(a1)
    li a3, 0x925c6cb79543c51a
    sbsetiw t4,a3,31
    sd t4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
