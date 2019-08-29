#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t0, 0xa7b2ca1a778bd1db
    li a6, 0x935b4969def3c035
    bfp s11,t0,a6
    sd s11,0(a1)
    li a3, 0x55f04ca8ffaace79
    li a2, 0x1a785a2011e15d6b
    bfp t5,a3,a2
    sd t5,8(a1)
    li s8, 0xb23279cf04bc5eac
    li a2, 0x2c4cb61533397f4e
    bfp t2,s8,a2
    sd t2,16(a1)
    li s0, 0x6b5ed10440ee4840
    li a5, 0x4aecd4a818331b85
    bfp s11,s0,a5
    sd s11,24(a1)
    li a5, 0x1607b7125a0d8ae2
    li s3, 0x05100ad8faafb8a6
    bfp a3,a5,s3
    sd a3,32(a1)
    li s1, 0xd7ab5710cccb9502
    li s4, 0x7926d5b8de163e74
    bfp a0,s1,s4
    sd a0,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
