#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s7, 0xa7b2ca1a778bd1db
    li t3, 0x935b4969def3c035
    sbinvw a5,s7,t3
    sd a5,0(a1)
    li s3, 0x55f04ca8ffaace79
    li s8, 0x1a785a2011e15d6b
    sbinvw t6,s3,s8
    sd t6,8(a1)
    li a5, 0xb23279cf04bc5eac
    li s7, 0x2c4cb61533397f4e
    sbinvw s11,a5,s7
    sd s11,16(a1)
    li s9, 0x6b5ed10440ee4840
    li t4, 0x4aecd4a818331b85
    sbinvw a6,s9,t4
    sd a6,24(a1)
    li t5, 0x1607b7125a0d8ae2
    li a5, 0x05100ad8faafb8a6
    sbinvw a2,t5,a5
    sd a2,32(a1)
    li t0, 0xd7ab5710cccb9502
    li a5, 0x7926d5b8de163e74
    sbinvw a4,t0,a5
    sd a4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
