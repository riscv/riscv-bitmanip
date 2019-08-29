#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t5, 0xa7b2ca1a778bd1db
    li t6, 0x935b4969def3c035
    pack s1,t5,t6
    sd s1,0(a1)
    li s10, 0x55f04ca8ffaace79
    li s11, 0x1a785a2011e15d6b
    pack s5,s10,s11
    sd s5,8(a1)
    li a7, 0xb23279cf04bc5eac
    li a4, 0x2c4cb61533397f4e
    pack a5,a7,a4
    sd a5,16(a1)
    li t5, 0x6b5ed10440ee4840
    li s3, 0x4aecd4a818331b85
    pack a2,t5,s3
    sd a2,24(a1)
    li a0, 0x1607b7125a0d8ae2
    li s11, 0x05100ad8faafb8a6
    pack s0,a0,s11
    sd s0,32(a1)
    li s2, 0xd7ab5710cccb9502
    li a2, 0x7926d5b8de163e74
    pack s7,s2,a2
    sd s7,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
