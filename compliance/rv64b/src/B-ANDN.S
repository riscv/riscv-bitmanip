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
    li s10, 0x55f04ca8ffaace79
    li t6, 0x1a785a2011e15d6b
    andn s3,s10,t6
    sd s3,8(a1)
    li t0, 0xb23279cf04bc5eac
    li a2, 0x2c4cb61533397f4e
    andn s8,t0,a2
    sd s8,16(a1)
    li t0, 0x6b5ed10440ee4840
    li a0, 0x4aecd4a818331b85
    andn a4,t0,a0
    sd a4,24(a1)
    li t1, 0x1607b7125a0d8ae2
    li a5, 0x05100ad8faafb8a6
    andn t5,t1,a5
    sd t5,32(a1)
    li s4, 0xd7ab5710cccb9502
    li t3, 0x7926d5b8de163e74
    andn a0,s4,t3
    sd a0,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
