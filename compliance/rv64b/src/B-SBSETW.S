#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s8, 0xa7b2ca1a778bd1db
    li s1, 0x935b4969def3c035
    sbsetw s5,s8,s1
    sd s5,0(a1)
    li s3, 0x55f04ca8ffaace79
    li s1, 0x1a785a2011e15d6b
    sbsetw a2,s3,s1
    sd a2,8(a1)
    li t6, 0xb23279cf04bc5eac
    li s7, 0x2c4cb61533397f4e
    sbsetw s5,t6,s7
    sd s5,16(a1)
    li s5, 0x6b5ed10440ee4840
    li s6, 0x4aecd4a818331b85
    sbsetw s1,s5,s6
    sd s1,24(a1)
    li a3, 0x1607b7125a0d8ae2
    li s11, 0x05100ad8faafb8a6
    sbsetw s9,a3,s11
    sd s9,32(a1)
    li s1, 0xd7ab5710cccb9502
    li a0, 0x7926d5b8de163e74
    sbsetw t2,s1,a0
    sd t2,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
