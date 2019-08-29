#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s5, 0xa7b2ca1a778bd1db
    li s0, 0x935b4969def3c035
    max s1,s5,s0
    sd s1,0(a1)
    li s0, 0x55f04ca8ffaace79
    li t4, 0x1a785a2011e15d6b
    max s7,s0,t4
    sd s7,8(a1)
    li a6, 0xb23279cf04bc5eac
    li t6, 0x2c4cb61533397f4e
    max t3,a6,t6
    sd t3,16(a1)
    li s11, 0x6b5ed10440ee4840
    li s0, 0x4aecd4a818331b85
    max a3,s11,s0
    sd a3,24(a1)
    li s1, 0x1607b7125a0d8ae2
    li t2, 0x05100ad8faafb8a6
    max s0,s1,t2
    sd s0,32(a1)
    li t3, 0xd7ab5710cccb9502
    li s9, 0x7926d5b8de163e74
    max s4,t3,s9
    sd s4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
