#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s3, 0xa7b2ca1a778bd1db
    li s11, 0x935b4969def3c035
    subu.w s7,s3,s11
    sd s7,0(a1)
    li s7, 0x55f04ca8ffaace79
    li s3, 0x1a785a2011e15d6b
    subu.w s0,s7,s3
    sd s0,8(a1)
    li a0, 0xb23279cf04bc5eac
    li s10, 0x2c4cb61533397f4e
    subu.w s9,a0,s10
    sd s9,16(a1)
    li t3, 0x6b5ed10440ee4840
    li a4, 0x4aecd4a818331b85
    subu.w s3,t3,a4
    sd s3,24(a1)
    li t1, 0x1607b7125a0d8ae2
    li s11, 0x05100ad8faafb8a6
    subu.w s9,t1,s11
    sd s9,32(a1)
    li a3, 0xd7ab5710cccb9502
    li s3, 0x7926d5b8de163e74
    subu.w a7,a3,s3
    sd a7,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
