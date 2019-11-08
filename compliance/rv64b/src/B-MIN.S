#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a3, 0xa7b2ca1a778bd1db
    li a2, 0x935b4969def3c035
    min t5,a3,a2
    sd t5,0(a1)
    li t6, 0x55f04ca8ffaace79
    li s5, 0x1a785a2011e15d6b
    min s11,t6,s5
    sd s11,8(a1)
    li t0, 0xb23279cf04bc5eac
    li a3, 0x2c4cb61533397f4e
    min s2,t0,a3
    sd s2,16(a1)
    li a7, 0x6b5ed10440ee4840
    li s7, 0x4aecd4a818331b85
    min s11,a7,s7
    sd s11,24(a1)
    li t6, 0x1607b7125a0d8ae2
    li a0, 0x05100ad8faafb8a6
    min a3,t6,a0
    sd a3,32(a1)
    li s3, 0xd7ab5710cccb9502
    li s9, 0x7926d5b8de163e74
    min s7,s3,s9
    sd s7,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
