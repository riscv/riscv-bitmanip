#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t6, 0xa7b2ca1a778bd1db
    li t2, 0x935b4969def3c035
    sbext a3,t6,t2
    sd a3,0(a1)
    li a6, 0x55f04ca8ffaace79
    li t1, 0x1a785a2011e15d6b
    sbext a5,a6,t1
    sd a5,8(a1)
    li a6, 0xb23279cf04bc5eac
    li t6, 0x2c4cb61533397f4e
    sbext t3,a6,t6
    sd t3,16(a1)
    li a0, 0x6b5ed10440ee4840
    li t2, 0x4aecd4a818331b85
    sbext s5,a0,t2
    sd s5,24(a1)
    li a0, 0x1607b7125a0d8ae2
    li s11, 0x05100ad8faafb8a6
    sbext s0,a0,s11
    sd s0,32(a1)
    li s11, 0xd7ab5710cccb9502
    li a3, 0x7926d5b8de163e74
    sbext s3,s11,a3
    sd s3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
