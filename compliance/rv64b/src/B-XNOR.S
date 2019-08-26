#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s4, 0xa7b2ca1a778bd1db
    li a2, 0x935b4969def3c035
    xnor t6,s4,a2
    sd t6,0(a1)
    li s10, 0x55f04ca8ffaace79
    li t6, 0x1a785a2011e15d6b
    xnor s3,s10,t6
    sd s3,8(a1)
    li a4, 0xb23279cf04bc5eac
    li s8, 0x2c4cb61533397f4e
    xnor t4,a4,s8
    sd t4,16(a1)
    li a7, 0x6b5ed10440ee4840
    li t0, 0x4aecd4a818331b85
    xnor a6,a7,t0
    sd a6,24(a1)
    li t6, 0x1607b7125a0d8ae2
    li s4, 0x05100ad8faafb8a6
    xnor a2,t6,s4
    sd a2,32(a1)
    li s1, 0xd7ab5710cccb9502
    li t2, 0x7926d5b8de163e74
    xnor s0,s1,t2
    sd s0,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
