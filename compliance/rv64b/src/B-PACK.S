#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s10, 0xa7b2ca1a778bd1db
    li t6, 0x935b4969def3c035
    pack s3,s10,t6
    sd s3,0(a1)
    li a4, 0x55f04ca8ffaace79
    li t6, 0x1a785a2011e15d6b
    pack s4,a4,t6
    sd s4,8(a1)
    li s0, 0xb23279cf04bc5eac
    li a5, 0x2c4cb61533397f4e
    pack s11,s0,a5
    sd s11,16(a1)
    li t1, 0x6b5ed10440ee4840
    li s10, 0x4aecd4a818331b85
    pack s2,t1,s10
    sd s2,24(a1)
    li s5, 0x1607b7125a0d8ae2
    li s1, 0x05100ad8faafb8a6
    pack s9,s5,s1
    sd s9,32(a1)
    li s3, 0xd7ab5710cccb9502
    li s1, 0x7926d5b8de163e74
    pack a2,s3,s1
    sd a2,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
