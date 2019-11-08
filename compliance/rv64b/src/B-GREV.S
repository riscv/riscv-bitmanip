#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a4, 0xa7b2ca1a778bd1db
    li s8, 0x935b4969def3c035
    grev t4,a4,s8
    sd t4,0(a1)
    li t0, 0x55f04ca8ffaace79
    li a0, 0x1a785a2011e15d6b
    grev a4,t0,a0
    sd a4,8(a1)
    li a7, 0xb23279cf04bc5eac
    li s2, 0x2c4cb61533397f4e
    grev s4,a7,s2
    sd s4,16(a1)
    li s1, 0x6b5ed10440ee4840
    li s4, 0x4aecd4a818331b85
    grev a0,s1,s4
    sd a0,24(a1)
    li s4, 0x1607b7125a0d8ae2
    li s0, 0x05100ad8faafb8a6
    grev t1,s4,s0
    sd t1,32(a1)
    li s4, 0xd7ab5710cccb9502
    li t6, 0x7926d5b8de163e74
    grev a0,s4,t6
    sd a0,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
