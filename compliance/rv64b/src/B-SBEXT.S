#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a2, 0xa7b2ca1a778bd1db
    li a6, 0x935b4969def3c035
    sbext s5,a2,a6
    sd s5,0(a1)
    li s3, 0x55f04ca8ffaace79
    li t0, 0x1a785a2011e15d6b
    sbext s9,s3,t0
    sd s9,8(a1)
    li a2, 0xb23279cf04bc5eac
    li s9, 0x2c4cb61533397f4e
    sbext s8,a2,s9
    sd s8,16(a1)
    li s5, 0x6b5ed10440ee4840
    li t5, 0x4aecd4a818331b85
    sbext a2,s5,t5
    sd a2,24(a1)
    li s0, 0x1607b7125a0d8ae2
    li a6, 0x05100ad8faafb8a6
    sbext a4,s0,a6
    sd a4,32(a1)
    li t6, 0xd7ab5710cccb9502
    li a0, 0x7926d5b8de163e74
    sbext a3,t6,a0
    sd a3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
