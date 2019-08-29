#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t0, 0xa7b2ca1a778bd1db
    li s6, 0x935b4969def3c035
    subu.w a3,t0,s6
    sd a3,0(a1)
    li a3, 0x55f04ca8ffaace79
    li t2, 0x1a785a2011e15d6b
    subu.w a6,a3,t2
    sd a6,8(a1)
    li t0, 0xb23279cf04bc5eac
    li s8, 0x2c4cb61533397f4e
    subu.w a6,t0,s8
    sd a6,16(a1)
    li s10, 0x6b5ed10440ee4840
    li s3, 0x4aecd4a818331b85
    subu.w a7,s10,s3
    sd a7,24(a1)
    li s10, 0x1607b7125a0d8ae2
    li s5, 0x05100ad8faafb8a6
    subu.w s0,s10,s5
    sd s0,32(a1)
    li s9, 0xd7ab5710cccb9502
    li a2, 0x7926d5b8de163e74
    subu.w t5,s9,a2
    sd t5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
