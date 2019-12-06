#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t6, 0xa7b2ca1a778bd1db
    li s5, 0x935b4969def3c035
    sbclr s11,t6,s5
    sd s11,0(a1)
    li t0, 0x55f04ca8ffaace79
    li a3, 0x1a785a2011e15d6b
    sbclr s2,t0,a3
    sd s2,8(a1)
    li a7, 0xb23279cf04bc5eac
    li s7, 0x2c4cb61533397f4e
    sbclr s11,a7,s7
    sd s11,16(a1)
    li t6, 0x6b5ed10440ee4840
    li a0, 0x4aecd4a818331b85
    sbclr a3,t6,a0
    sd a3,24(a1)
    li s3, 0x1607b7125a0d8ae2
    li s9, 0x05100ad8faafb8a6
    sbclr s7,s3,s9
    sd s7,32(a1)
    li t0, 0xd7ab5710cccb9502
    li s7, 0x7926d5b8de163e74
    sbclr s1,t0,s7
    sd s1,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
