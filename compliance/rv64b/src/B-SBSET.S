#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s9, 0xa7b2ca1a778bd1db
    li s10, 0x935b4969def3c035
    sbset a6,s9,s10
    sd a6,0(a1)
    li s10, 0x55f04ca8ffaace79
    li t6, 0x1a785a2011e15d6b
    sbset s5,s10,t6
    sd s5,8(a1)
    li s5, 0xb23279cf04bc5eac
    li t5, 0x2c4cb61533397f4e
    sbset a2,s5,t5
    sd a2,16(a1)
    li a0, 0x6b5ed10440ee4840
    li s2, 0x4aecd4a818331b85
    sbset a2,a0,s2
    sd a2,24(a1)
    li s1, 0x1607b7125a0d8ae2
    li t4, 0x05100ad8faafb8a6
    sbset t0,s1,t4
    sd t0,32(a1)
    li t6, 0xd7ab5710cccb9502
    li s7, 0x7926d5b8de163e74
    sbset s5,t6,s7
    sd s5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
