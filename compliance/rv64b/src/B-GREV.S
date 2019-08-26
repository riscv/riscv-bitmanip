#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a2, 0xa7b2ca1a778bd1db
    li a6, 0x935b4969def3c035
    grev s5,a2,a6
    sd s5,0(a1)
    li a5, 0x55f04ca8ffaace79
    li a6, 0x1a785a2011e15d6b
    grev a4,a5,a6
    sd a4,8(a1)
    li a5, 0xb23279cf04bc5eac
    li a4, 0x2c4cb61533397f4e
    grev t4,a5,a4
    sd t4,16(a1)
    li s6, 0x6b5ed10440ee4840
    li t5, 0x4aecd4a818331b85
    grev a4,s6,t5
    sd a4,24(a1)
    li a5, 0x1607b7125a0d8ae2
    li s3, 0x05100ad8faafb8a6
    grev a3,a5,s3
    sd a3,32(a1)
    li a5, 0xd7ab5710cccb9502
    li s7, 0x7926d5b8de163e74
    grev a3,a5,s7
    sd a3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
