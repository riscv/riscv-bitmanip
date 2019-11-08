#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s7, 0xa7b2ca1a778bd1db
    li s8, 0x935b4969def3c035
    sbinvw t1,s7,s8
    sd t1,0(a1)
    li a7, 0x55f04ca8ffaace79
    li t2, 0x1a785a2011e15d6b
    sbinvw a4,a7,t2
    sd a4,8(a1)
    li s10, 0xb23279cf04bc5eac
    li t5, 0x2c4cb61533397f4e
    sbinvw a4,s10,t5
    sd a4,16(a1)
    li s3, 0x6b5ed10440ee4840
    li t5, 0x4aecd4a818331b85
    sbinvw s5,s3,t5
    sd s5,24(a1)
    li a7, 0x1607b7125a0d8ae2
    li s11, 0x05100ad8faafb8a6
    sbinvw t6,a7,s11
    sd t6,32(a1)
    li t3, 0xd7ab5710cccb9502
    li t5, 0x7926d5b8de163e74
    sbinvw s2,t3,t5
    sd s2,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
