#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s3, 0xa7b2ca1a778bd1db
    li t6, 0x935b4969def3c035
    sbsetw t2,s3,t6
    sd t2,0(a1)
    li a2, 0x55f04ca8ffaace79
    li s10, 0x1a785a2011e15d6b
    sbsetw s2,a2,s10
    sd s2,8(a1)
    li t5, 0xb23279cf04bc5eac
    li s5, 0x2c4cb61533397f4e
    sbsetw t2,t5,s5
    sd t2,16(a1)
    li t1, 0x6b5ed10440ee4840
    li s5, 0x4aecd4a818331b85
    sbsetw a5,t1,s5
    sd a5,24(a1)
    li s4, 0x1607b7125a0d8ae2
    li s1, 0x05100ad8faafb8a6
    sbsetw t5,s4,s1
    sd t5,32(a1)
    li s9, 0xd7ab5710cccb9502
    li a4, 0x7926d5b8de163e74
    sbsetw t1,s9,a4
    sd t1,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
