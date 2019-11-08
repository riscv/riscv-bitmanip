#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s11, 0xa7b2ca1a778bd1db
    li s3, 0x935b4969def3c035
    packuw s0,s11,s3
    sd s0,0(a1)
    li a3, 0x55f04ca8ffaace79
    li s11, 0x1a785a2011e15d6b
    packuw s9,a3,s11
    sd s9,8(a1)
    li a2, 0xb23279cf04bc5eac
    li s0, 0x2c4cb61533397f4e
    packuw t0,a2,s0
    sd t0,16(a1)
    li a5, 0x6b5ed10440ee4840
    li a0, 0x4aecd4a818331b85
    packuw t2,a5,a0
    sd t2,24(a1)
    li a3, 0x1607b7125a0d8ae2
    li a6, 0x05100ad8faafb8a6
    packuw s5,a3,a6
    sd s5,32(a1)
    li s3, 0xd7ab5710cccb9502
    li s10, 0x7926d5b8de163e74
    packuw s7,s3,s10
    sd s7,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
