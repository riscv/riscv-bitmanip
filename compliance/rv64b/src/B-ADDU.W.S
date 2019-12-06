#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a0, 0xa7b2ca1a778bd1db
    li s6, 0x935b4969def3c035
    addu.w a2,a0,s6
    sd a2,0(a1)
    li s3, 0x55f04ca8ffaace79
    li s0, 0x1a785a2011e15d6b
    addu.w s1,s3,s0
    sd s1,8(a1)
    li s6, 0xb23279cf04bc5eac
    li t0, 0x2c4cb61533397f4e
    addu.w a7,s6,t0
    sd a7,16(a1)
    li s7, 0x6b5ed10440ee4840
    li s2, 0x4aecd4a818331b85
    addu.w s5,s7,s2
    sd s5,24(a1)
    li s7, 0x1607b7125a0d8ae2
    li t6, 0x05100ad8faafb8a6
    addu.w t3,s7,t6
    sd t3,32(a1)
    li s7, 0xd7ab5710cccb9502
    li a0, 0x7926d5b8de163e74
    addu.w a4,s7,a0
    sd a4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
