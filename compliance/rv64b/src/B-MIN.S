#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a7, 0xa7b2ca1a778bd1db
    li a0, 0x935b4969def3c035
    min s7,a7,a0
    sd s7,0(a1)
    li t5, 0x55f04ca8ffaace79
    li s3, 0x1a785a2011e15d6b
    min a2,t5,s3
    sd a2,8(a1)
    li a6, 0xb23279cf04bc5eac
    li t2, 0x2c4cb61533397f4e
    min s0,a6,t2
    sd s0,16(a1)
    li t3, 0x6b5ed10440ee4840
    li s9, 0x4aecd4a818331b85
    min s4,t3,s9
    sd s4,24(a1)
    li s2, 0x1607b7125a0d8ae2
    li a0, 0x05100ad8faafb8a6
    min s7,s2,a0
    sd s7,32(a1)
    li s5, 0xd7ab5710cccb9502
    li s6, 0x7926d5b8de163e74
    min s1,s5,s6
    sd s1,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
