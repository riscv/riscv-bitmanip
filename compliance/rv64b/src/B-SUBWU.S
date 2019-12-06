#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t5, 0xa7b2ca1a778bd1db
    li a2, 0x935b4969def3c035
    subwu s0,t5,a2
    sd s0,0(a1)
    li s2, 0x55f04ca8ffaace79
    li t4, 0x1a785a2011e15d6b
    subwu s3,s2,t4
    sd s3,8(a1)
    li s8, 0xb23279cf04bc5eac
    li a3, 0x2c4cb61533397f4e
    subwu t2,s8,a3
    sd t2,16(a1)
    li s1, 0x6b5ed10440ee4840
    li s3, 0x4aecd4a818331b85
    subwu t1,s1,s3
    sd t1,24(a1)
    li t0, 0x1607b7125a0d8ae2
    li a2, 0x05100ad8faafb8a6
    subwu a3,t0,a2
    sd a3,32(a1)
    li s9, 0xd7ab5710cccb9502
    li a7, 0x7926d5b8de163e74
    subwu s6,s9,a7
    sd s6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
