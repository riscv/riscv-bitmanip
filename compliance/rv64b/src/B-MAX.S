#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a7, 0xa7b2ca1a778bd1db
    li a5, 0x935b4969def3c035
    max t2,a7,a5
    sd t2,0(a1)
    li a5, 0x55f04ca8ffaace79
    li a4, 0x1a785a2011e15d6b
    max t4,a5,a4
    sd t4,8(a1)
    li a4, 0xb23279cf04bc5eac
    li s9, 0x2c4cb61533397f4e
    max t0,a4,s9
    sd t0,16(a1)
    li s0, 0x6b5ed10440ee4840
    li a6, 0x4aecd4a818331b85
    max a4,s0,a6
    sd a4,24(a1)
    li a0, 0x1607b7125a0d8ae2
    li s5, 0x05100ad8faafb8a6
    max s6,a0,s5
    sd s6,32(a1)
    li s0, 0xd7ab5710cccb9502
    li t4, 0x7926d5b8de163e74
    max s10,s0,t4
    sd s10,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
