#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s3, 0xa7b2ca1a778bd1db
    li t0, 0x935b4969def3c035
    gorc s9,s3,t0
    sd s9,0(a1)
    li s11, 0x55f04ca8ffaace79
    li t0, 0x1a785a2011e15d6b
    gorc a7,s11,t0
    sd a7,8(a1)
    li s1, 0xb23279cf04bc5eac
    li s9, 0x2c4cb61533397f4e
    gorc s5,s1,s9
    sd s5,16(a1)
    li s2, 0x6b5ed10440ee4840
    li a2, 0x4aecd4a818331b85
    gorc s7,s2,a2
    sd s7,24(a1)
    li s8, 0x1607b7125a0d8ae2
    li a3, 0x05100ad8faafb8a6
    gorc s11,s8,a3
    sd s11,32(a1)
    li a6, 0xd7ab5710cccb9502
    li s6, 0x7926d5b8de163e74
    gorc s9,a6,s6
    sd s9,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
