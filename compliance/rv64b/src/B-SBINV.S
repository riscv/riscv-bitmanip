#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a7, 0xa7b2ca1a778bd1db
    li a3, 0x935b4969def3c035
    sbinv a6,a7,a3
    sd a6,0(a1)
    li s9, 0x55f04ca8ffaace79
    li s10, 0x1a785a2011e15d6b
    sbinv a6,s9,s10
    sd a6,8(a1)
    li t6, 0xb23279cf04bc5eac
    li s5, 0x2c4cb61533397f4e
    sbinv s11,t6,s5
    sd s11,16(a1)
    li s0, 0x6b5ed10440ee4840
    li a5, 0x4aecd4a818331b85
    sbinv s11,s0,a5
    sd s11,24(a1)
    li a7, 0x1607b7125a0d8ae2
    li s2, 0x05100ad8faafb8a6
    sbinv s4,a7,s2
    sd s4,32(a1)
    li s4, 0xd7ab5710cccb9502
    li t3, 0x7926d5b8de163e74
    sbinv a0,s4,t3
    sd a0,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
