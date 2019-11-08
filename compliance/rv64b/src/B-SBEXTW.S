#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s11, 0xa7b2ca1a778bd1db
    li a4, 0x935b4969def3c035
    sbextw s1,s11,a4
    sd s1,0(a1)
    li s3, 0x55f04ca8ffaace79
    li t6, 0x1a785a2011e15d6b
    sbextw t2,s3,t6
    sd t2,8(a1)
    li a2, 0xb23279cf04bc5eac
    li s10, 0x2c4cb61533397f4e
    sbextw s2,a2,s10
    sd s2,16(a1)
    li t5, 0x6b5ed10440ee4840
    li s5, 0x4aecd4a818331b85
    sbextw t2,t5,s5
    sd t2,24(a1)
    li t1, 0x1607b7125a0d8ae2
    li s5, 0x05100ad8faafb8a6
    sbextw a5,t1,s5
    sd a5,32(a1)
    li s4, 0xd7ab5710cccb9502
    li s1, 0x7926d5b8de163e74
    sbextw t5,s4,s1
    sd t5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
