#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t1, 0xa7b2ca1a778bd1db
    li s6, 0x935b4969def3c035
    xnor s7,t1,s6
    sd s7,0(a1)
    li a7, 0x55f04ca8ffaace79
    li a0, 0x1a785a2011e15d6b
    xnor s7,a7,a0
    sd s7,8(a1)
    li t5, 0xb23279cf04bc5eac
    li s3, 0x2c4cb61533397f4e
    xnor a2,t5,s3
    sd a2,16(a1)
    li a6, 0x6b5ed10440ee4840
    li t2, 0x4aecd4a818331b85
    xnor s0,a6,t2
    sd s0,24(a1)
    li t3, 0x1607b7125a0d8ae2
    li s9, 0x05100ad8faafb8a6
    xnor s4,t3,s9
    sd s4,32(a1)
    li s2, 0xd7ab5710cccb9502
    li a0, 0x7926d5b8de163e74
    xnor s7,s2,a0
    sd s7,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
