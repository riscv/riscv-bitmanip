#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s6, 0xa7b2ca1a778bd1db
    li t0, 0x935b4969def3c035
    minu t6,s6,t0
    sd t6,0(a1)
    li s10, 0x55f04ca8ffaace79
    li s11, 0x1a785a2011e15d6b
    minu s5,s10,s11
    sd s5,8(a1)
    li a7, 0xb23279cf04bc5eac
    li a0, 0x2c4cb61533397f4e
    minu s7,a7,a0
    sd s7,16(a1)
    li s11, 0x6b5ed10440ee4840
    li t0, 0x4aecd4a818331b85
    minu a7,s11,t0
    sd a7,24(a1)
    li s5, 0x1607b7125a0d8ae2
    li t5, 0x05100ad8faafb8a6
    minu a2,s5,t5
    sd a2,32(a1)
    li a7, 0xd7ab5710cccb9502
    li s7, 0x7926d5b8de163e74
    minu s11,a7,s7
    sd s11,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
