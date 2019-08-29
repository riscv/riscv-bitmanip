#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s5, 0xa7b2ca1a778bd1db
    li s11, 0x935b4969def3c035
    addwu t0,s5,s11
    sd t0,0(a1)
    li s6, 0x55f04ca8ffaace79
    li s8, 0x1a785a2011e15d6b
    addwu t2,s6,s8
    sd t2,8(a1)
    li a3, 0xb23279cf04bc5eac
    li a2, 0x2c4cb61533397f4e
    addwu a5,a3,a2
    sd a5,16(a1)
    li s8, 0x6b5ed10440ee4840
    li t5, 0x4aecd4a818331b85
    addwu s11,s8,t5
    sd s11,24(a1)
    li s11, 0x1607b7125a0d8ae2
    li s3, 0x05100ad8faafb8a6
    addwu t4,s11,s3
    sd t4,32(a1)
    li t6, 0xd7ab5710cccb9502
    li a7, 0x7926d5b8de163e74
    addwu s3,t6,a7
    sd s3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
