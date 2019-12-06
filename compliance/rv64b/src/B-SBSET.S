#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t5, 0xa7b2ca1a778bd1db
    li s10, 0x935b4969def3c035
    sbset a0,t5,s10
    sd a0,0(a1)
    li s11, 0x55f04ca8ffaace79
    li s0, 0x1a785a2011e15d6b
    sbset a3,s11,s0
    sd a3,8(a1)
    li s11, 0xb23279cf04bc5eac
    li a6, 0x2c4cb61533397f4e
    sbset s4,s11,a6
    sd s4,16(a1)
    li a7, 0x6b5ed10440ee4840
    li s10, 0x4aecd4a818331b85
    sbset s4,a7,s10
    sd s4,24(a1)
    li s10, 0x1607b7125a0d8ae2
    li a2, 0x05100ad8faafb8a6
    sbset a0,s10,a2
    sd a0,32(a1)
    li s11, 0xd7ab5710cccb9502
    li a4, 0x7926d5b8de163e74
    sbset s1,s11,a4
    sd s1,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
