#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t4, 0xa7b2ca1a778bd1db
    li t5, 0x935b4969def3c035
    subwu s9,t4,t5
    sd s9,0(a1)
    li t6, 0x55f04ca8ffaace79
    li t2, 0x1a785a2011e15d6b
    subwu a6,t6,t2
    sd a6,8(a1)
    li s5, 0xb23279cf04bc5eac
    li s0, 0x2c4cb61533397f4e
    subwu a6,s5,s0
    sd a6,16(a1)
    li a0, 0x6b5ed10440ee4840
    li s5, 0x4aecd4a818331b85
    subwu s3,a0,s5
    sd s3,24(a1)
    li a4, 0x1607b7125a0d8ae2
    li s4, 0x05100ad8faafb8a6
    subwu t5,a4,s4
    sd t5,32(a1)
    li s2, 0xd7ab5710cccb9502
    li s3, 0x7926d5b8de163e74
    subwu t4,s2,s3
    sd t4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
