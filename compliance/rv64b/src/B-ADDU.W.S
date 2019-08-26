#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s3, 0xa7b2ca1a778bd1db
    li s7, 0x935b4969def3c035
    addu.w a5,s3,s7
    sd a5,0(a1)
    li s0, 0x55f04ca8ffaace79
    li t3, 0x1a785a2011e15d6b
    addu.w s3,s0,t3
    sd s3,8(a1)
    li s7, 0xb23279cf04bc5eac
    li a2, 0x2c4cb61533397f4e
    addu.w t5,s7,a2
    sd t5,16(a1)
    li s8, 0x6b5ed10440ee4840
    li s3, 0x4aecd4a818331b85
    addu.w t5,s8,s3
    sd t5,24(a1)
    li s4, 0x1607b7125a0d8ae2
    li a2, 0x05100ad8faafb8a6
    addu.w t3,s4,a2
    sd t3,32(a1)
    li a2, 0xd7ab5710cccb9502
    li s5, 0x7926d5b8de163e74
    addu.w t0,a2,s5
    sd t0,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
