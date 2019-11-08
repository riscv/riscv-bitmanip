#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s8, 0xa7b2ca1a778bd1db
    li a2, 0x935b4969def3c035
    packw a3,s8,a2
    sd a3,0(a1)
    li a0, 0x55f04ca8ffaace79
    li s9, 0x1a785a2011e15d6b
    packw s8,a0,s9
    sd s8,8(a1)
    li s1, 0xb23279cf04bc5eac
    li a0, 0x2c4cb61533397f4e
    packw t2,s1,a0
    sd t2,16(a1)
    li a7, 0x6b5ed10440ee4840
    li s11, 0x4aecd4a818331b85
    packw s3,a7,s11
    sd s3,24(a1)
    li t1, 0x1607b7125a0d8ae2
    li s2, 0x05100ad8faafb8a6
    packw t3,t1,s2
    sd t3,32(a1)
    li t2, 0xd7ab5710cccb9502
    li a7, 0x7926d5b8de163e74
    packw t3,t2,a7
    sd t3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
