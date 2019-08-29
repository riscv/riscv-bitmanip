#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t6, 0xa7b2ca1a778bd1db
    li t2, 0x935b4969def3c035
    sbinv a3,t6,t2
    sd a3,0(a1)
    li a2, 0x55f04ca8ffaace79
    li a6, 0x1a785a2011e15d6b
    sbinv t0,a2,a6
    sd t0,8(a1)
    li a7, 0xb23279cf04bc5eac
    li t0, 0x2c4cb61533397f4e
    sbinv a6,a7,t0
    sd a6,16(a1)
    li s10, 0x6b5ed10440ee4840
    li s2, 0x4aecd4a818331b85
    sbinv a4,s10,s2
    sd a4,24(a1)
    li t2, 0x1607b7125a0d8ae2
    li t5, 0x05100ad8faafb8a6
    sbinv s3,t2,t5
    sd s3,32(a1)
    li a7, 0xd7ab5710cccb9502
    li s10, 0x7926d5b8de163e74
    sbinv s4,a7,s10
    sd s4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
