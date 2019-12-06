#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s10, 0xf0774453522a1063
    unshfli s0,s10,3
    sd s0,0(a1)
    li s1, 0xedd116c18a671b8c
    unshfli s10,s1,5
    sd s10,8(a1)
    li s9, 0x8130cd0d02eb0801
    unshfli t5,s9,17
    sd t5,16(a1)
    li a4, 0x1f9f61e943737b61
    unshfli s11,a4,24
    sd s11,24(a1)
    li s0, 0x915695b3f20d8a82
    unshfli s11,s0,25
    sd s11,32(a1)
    li a6, 0x925c6cb79543c51a
    unshfli s6,a6,31
    sd s6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
