#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a6, 0xa7b2ca1a778bd1db
    li t1, 0x935b4969def3c035
    sbclr a5,a6,t1
    sd a5,0(a1)
    li a7, 0x55f04ca8ffaace79
    li t0, 0x1a785a2011e15d6b
    sbclr a6,a7,t0
    sd a6,8(a1)
    li a4, 0xb23279cf04bc5eac
    li s0, 0x2c4cb61533397f4e
    sbclr s9,a4,s0
    sd s9,16(a1)
    li s4, 0x6b5ed10440ee4840
    li t3, 0x4aecd4a818331b85
    sbclr a0,s4,t3
    sd a0,24(a1)
    li s8, 0x1607b7125a0d8ae2
    li s1, 0x05100ad8faafb8a6
    sbclr s5,s8,s1
    sd s5,32(a1)
    li s10, 0xd7ab5710cccb9502
    li a0, 0x7926d5b8de163e74
    sbclr t4,s10,a0
    sd t4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
