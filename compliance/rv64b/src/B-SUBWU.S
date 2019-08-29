#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s9, 0xa7b2ca1a778bd1db
    li a3, 0x935b4969def3c035
    subwu t3,s9,a3
    sd t3,0(a1)
    li s5, 0x55f04ca8ffaace79
    li s3, 0x1a785a2011e15d6b
    subwu s10,s5,s3
    sd s10,8(a1)
    li s6, 0xb23279cf04bc5eac
    li s11, 0x2c4cb61533397f4e
    subwu s0,s6,s11
    sd s0,16(a1)
    li a2, 0x6b5ed10440ee4840
    li a0, 0x4aecd4a818331b85
    subwu s4,a2,a0
    sd s4,24(a1)
    li t2, 0x1607b7125a0d8ae2
    li a2, 0x05100ad8faafb8a6
    subwu s4,t2,a2
    sd s4,32(a1)
    li s1, 0xd7ab5710cccb9502
    li s0, 0x7926d5b8de163e74
    subwu s10,s1,s0
    sd s10,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
