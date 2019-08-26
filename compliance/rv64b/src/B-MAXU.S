#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s5, 0xa7b2ca1a778bd1db
    li s0, 0x935b4969def3c035
    maxu s1,s5,s0
    sd s1,0(a1)
    li a5, 0x55f04ca8ffaace79
    li a7, 0x1a785a2011e15d6b
    maxu t5,a5,a7
    sd t5,8(a1)
    li a7, 0xb23279cf04bc5eac
    li a4, 0x2c4cb61533397f4e
    maxu a5,a7,a4
    sd a5,16(a1)
    li a0, 0x6b5ed10440ee4840
    li a5, 0x4aecd4a818331b85
    maxu a7,a0,a5
    sd a7,24(a1)
    li t0, 0x1607b7125a0d8ae2
    li s3, 0x05100ad8faafb8a6
    maxu s0,t0,s3
    sd s0,32(a1)
    li s0, 0xd7ab5710cccb9502
    li a6, 0x7926d5b8de163e74
    maxu a4,s0,a6
    sd a4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
