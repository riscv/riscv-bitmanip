#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t1, 0xa7b2ca1a778bd1db
    li s6, 0x935b4969def3c035
    grev s7,t1,s6
    sd s7,0(a1)
    li a5, 0x55f04ca8ffaace79
    li s6, 0x1a785a2011e15d6b
    grev a3,a5,s6
    sd a3,8(a1)
    li s11, 0xb23279cf04bc5eac
    li t0, 0x2c4cb61533397f4e
    grev a7,s11,t0
    sd a7,16(a1)
    li t0, 0x6b5ed10440ee4840
    li s3, 0x4aecd4a818331b85
    grev s0,t0,s3
    sd s0,24(a1)
    li a0, 0x1607b7125a0d8ae2
    li s2, 0x05100ad8faafb8a6
    grev a2,a0,s2
    sd a2,32(a1)
    li a0, 0xd7ab5710cccb9502
    li s5, 0x7926d5b8de163e74
    grev s6,a0,s5
    sd s6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
