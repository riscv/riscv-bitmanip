#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a7, 0xa7b2ca1a778bd1db
    li a4, 0x935b4969def3c035
    max a5,a7,a4
    sd a5,0(a1)
    li a0, 0x55f04ca8ffaace79
    li t2, 0x1a785a2011e15d6b
    max s5,a0,t2
    sd s5,8(a1)
    li s1, 0xb23279cf04bc5eac
    li t2, 0x2c4cb61533397f4e
    max s0,s1,t2
    sd s0,16(a1)
    li t2, 0x6b5ed10440ee4840
    li t1, 0x4aecd4a818331b85
    max s2,t2,t1
    sd s2,24(a1)
    li t6, 0x1607b7125a0d8ae2
    li a4, 0x05100ad8faafb8a6
    max t0,t6,a4
    sd t0,32(a1)
    li s9, 0xd7ab5710cccb9502
    li s5, 0x7926d5b8de163e74
    max s7,s9,s5
    sd s7,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
