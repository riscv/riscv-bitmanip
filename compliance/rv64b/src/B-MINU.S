#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a5, 0xa7b2ca1a778bd1db
    li a7, 0x935b4969def3c035
    minu t5,a5,a7
    sd t5,0(a1)
    li a6, 0x55f04ca8ffaace79
    li t6, 0x1a785a2011e15d6b
    minu t3,a6,t6
    sd t3,8(a1)
    li t6, 0xb23279cf04bc5eac
    li s4, 0x2c4cb61533397f4e
    minu a2,t6,s4
    sd a2,16(a1)
    li t2, 0x6b5ed10440ee4840
    li t5, 0x4aecd4a818331b85
    minu s3,t2,t5
    sd s3,24(a1)
    li s4, 0x1607b7125a0d8ae2
    li s5, 0x05100ad8faafb8a6
    minu s11,s4,s5
    sd s11,32(a1)
    li a2, 0xd7ab5710cccb9502
    li s5, 0x7926d5b8de163e74
    minu s6,a2,s5
    sd s6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
