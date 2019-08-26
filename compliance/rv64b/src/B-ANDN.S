#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s6, 0xa7b2ca1a778bd1db
    li a5, 0x935b4969def3c035
    andn a6,s6,a5
    sd a6,0(a1)
    li a6, 0x55f04ca8ffaace79
    li t2, 0x1a785a2011e15d6b
    andn t0,a6,t2
    sd t0,8(a1)
    li a2, 0xb23279cf04bc5eac
    li a6, 0x2c4cb61533397f4e
    andn t0,a2,a6
    sd t0,16(a1)
    li t5, 0x6b5ed10440ee4840
    li s3, 0x4aecd4a818331b85
    andn a6,t5,s3
    sd a6,24(a1)
    li s11, 0x1607b7125a0d8ae2
    li s0, 0x05100ad8faafb8a6
    andn a3,s11,s0
    sd a3,32(a1)
    li a6, 0xd7ab5710cccb9502
    li t2, 0x7926d5b8de163e74
    andn s0,a6,t2
    sd s0,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
