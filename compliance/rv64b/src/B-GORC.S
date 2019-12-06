#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t5, 0xa7b2ca1a778bd1db
    li s3, 0x935b4969def3c035
    gorc a6,t5,s3
    sd a6,0(a1)
    li s10, 0x55f04ca8ffaace79
    li s2, 0x1a785a2011e15d6b
    gorc a4,s10,s2
    sd a4,8(a1)
    li t1, 0xb23279cf04bc5eac
    li a7, 0x2c4cb61533397f4e
    gorc s10,t1,a7
    sd s10,16(a1)
    li s7, 0x6b5ed10440ee4840
    li t4, 0x4aecd4a818331b85
    gorc a6,s7,t4
    sd a6,24(a1)
    li t1, 0x1607b7125a0d8ae2
    li a2, 0x05100ad8faafb8a6
    gorc s5,t1,a2
    sd s5,32(a1)
    li a3, 0xd7ab5710cccb9502
    li s11, 0x7926d5b8de163e74
    gorc s9,a3,s11
    sd s9,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
