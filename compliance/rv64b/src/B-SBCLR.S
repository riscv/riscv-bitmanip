#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s7, 0xa7b2ca1a778bd1db
    li t3, 0x935b4969def3c035
    sbclr s6,s7,t3
    sd s6,0(a1)
    li s0, 0x55f04ca8ffaace79
    li t4, 0x1a785a2011e15d6b
    sbclr s7,s0,t4
    sd s7,8(a1)
    li t5, 0xb23279cf04bc5eac
    li s10, 0x2c4cb61533397f4e
    sbclr a0,t5,s10
    sd a0,16(a1)
    li t5, 0x6b5ed10440ee4840
    li s3, 0x4aecd4a818331b85
    sbclr a2,t5,s3
    sd a2,24(a1)
    li s1, 0x1607b7125a0d8ae2
    li s9, 0x05100ad8faafb8a6
    sbclr s5,s1,s9
    sd s5,32(a1)
    li a0, 0xd7ab5710cccb9502
    li s2, 0x7926d5b8de163e74
    sbclr a2,a0,s2
    sd a2,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
