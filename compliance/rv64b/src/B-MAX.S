#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s6, 0xa7b2ca1a778bd1db
    li s7, 0x935b4969def3c035
    max t3,s6,s7
    sd t3,0(a1)
    li a3, 0x55f04ca8ffaace79
    li a2, 0x1a785a2011e15d6b
    max t5,a3,a2
    sd t5,8(a1)
    li a4, 0xb23279cf04bc5eac
    li t6, 0x2c4cb61533397f4e
    max s4,a4,t6
    sd s4,16(a1)
    li t0, 0x6b5ed10440ee4840
    li a0, 0x4aecd4a818331b85
    max a4,t0,a0
    sd a4,24(a1)
    li a4, 0x1607b7125a0d8ae2
    li s0, 0x05100ad8faafb8a6
    max s9,a4,s0
    sd s9,32(a1)
    li t2, 0xd7ab5710cccb9502
    li t5, 0x7926d5b8de163e74
    max s3,t2,t5
    sd s3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
