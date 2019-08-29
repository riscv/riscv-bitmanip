#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s2, 0xa7b2ca1a778bd1db
    li t3, 0x935b4969def3c035
    grevw s8,s2,t3
    sd s8,0(a1)
    li a2, 0x55f04ca8ffaace79
    li s5, 0x1a785a2011e15d6b
    grevw s6,a2,s5
    sd s6,8(a1)
    li s4, 0xb23279cf04bc5eac
    li t6, 0x2c4cb61533397f4e
    grevw a0,s4,t6
    sd a0,16(a1)
    li t0, 0x6b5ed10440ee4840
    li s7, 0x4aecd4a818331b85
    grevw s1,t0,s7
    sd s1,24(a1)
    li s3, 0x1607b7125a0d8ae2
    li t6, 0x05100ad8faafb8a6
    grevw t2,s3,t6
    sd t2,32(a1)
    li s10, 0xd7ab5710cccb9502
    li t5, 0x7926d5b8de163e74
    grevw a4,s10,t5
    sd a4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
