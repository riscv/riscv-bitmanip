#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a7, 0xa7b2ca1a778bd1db
    li a3, 0x935b4969def3c035
    sbclr a6,a7,a3
    sd a6,0(a1)
    li a5, 0x55f04ca8ffaace79
    li a6, 0x1a785a2011e15d6b
    sbclr a4,a5,a6
    sd a4,8(a1)
    li s10, 0xb23279cf04bc5eac
    li t6, 0x2c4cb61533397f4e
    sbclr s5,s10,t6
    sd s5,16(a1)
    li a4, 0x6b5ed10440ee4840
    li s9, 0x4aecd4a818331b85
    sbclr t0,a4,s9
    sd t0,24(a1)
    li a7, 0x1607b7125a0d8ae2
    li s7, 0x05100ad8faafb8a6
    sbclr s11,a7,s7
    sd s11,32(a1)
    li t0, 0xd7ab5710cccb9502
    li a0, 0x7926d5b8de163e74
    sbclr t1,t0,a0
    sd t1,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
