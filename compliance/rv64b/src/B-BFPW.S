#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s1, 0xa7b2ca1a778bd1db
    li t4, 0x935b4969def3c035
    bfpw t0,s1,t4
    sd t0,0(a1)
    li s2, 0x55f04ca8ffaace79
    li a0, 0x1a785a2011e15d6b
    bfpw s7,s2,a0
    sd s7,8(a1)
    li t1, 0xb23279cf04bc5eac
    li a2, 0x2c4cb61533397f4e
    bfpw s5,t1,a2
    sd s5,16(a1)
    li s11, 0x6b5ed10440ee4840
    li s3, 0x4aecd4a818331b85
    bfpw s0,s11,s3
    sd s0,24(a1)
    li a0, 0x1607b7125a0d8ae2
    li s9, 0x05100ad8faafb8a6
    bfpw s8,a0,s9
    sd s8,32(a1)
    li s7, 0xd7ab5710cccb9502
    li t3, 0x7926d5b8de163e74
    bfpw a5,s7,t3
    sd a5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
