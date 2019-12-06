#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t1, 0xf0774453522a1063
    rori t5,t1,3
    sd t5,0(a1)
    li s10, 0xedd116c18a671b8c
    rori s4,s10,15
    sd s4,8(a1)
    li t5, 0x8130cd0d02eb0801
    rori s10,t5,27
    sd s10,16(a1)
    li a7, 0x1f9f61e943737b61
    rori s5,a7,42
    sd s5,24(a1)
    li t2, 0x915695b3f20d8a82
    rori a2,t2,59
    sd a2,32(a1)
    li a4, 0x925c6cb79543c51a
    rori s3,a4,62
    sd s3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
