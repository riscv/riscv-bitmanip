#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s1, 0xa7b2ca1a778bd1db
    li a0, 0x935b4969def3c035
    sbextw t2,s1,a0
    sd t2,0(a1)
    li a7, 0x55f04ca8ffaace79
    li s11, 0x1a785a2011e15d6b
    sbextw s3,a7,s11
    sd s3,8(a1)
    li t1, 0xb23279cf04bc5eac
    li s2, 0x2c4cb61533397f4e
    sbextw t3,t1,s2
    sd t3,16(a1)
    li t2, 0x6b5ed10440ee4840
    li a7, 0x4aecd4a818331b85
    sbextw t3,t2,a7
    sd t3,24(a1)
    li s8, 0x1607b7125a0d8ae2
    li s3, 0x05100ad8faafb8a6
    sbextw s11,s8,s3
    sd s11,32(a1)
    li t1, 0xd7ab5710cccb9502
    li s11, 0x7926d5b8de163e74
    sbextw a4,t1,s11
    sd a4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
