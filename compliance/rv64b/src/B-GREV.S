#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s10, 0xa7b2ca1a778bd1db
    li t6, 0x935b4969def3c035
    grev s5,s10,t6
    sd s5,0(a1)
    li s5, 0x55f04ca8ffaace79
    li t5, 0x1a785a2011e15d6b
    grev a2,s5,t5
    sd a2,8(a1)
    li a0, 0xb23279cf04bc5eac
    li s2, 0x2c4cb61533397f4e
    grev a2,a0,s2
    sd a2,16(a1)
    li s1, 0x6b5ed10440ee4840
    li t4, 0x4aecd4a818331b85
    grev t0,s1,t4
    sd t0,24(a1)
    li t6, 0x1607b7125a0d8ae2
    li s7, 0x05100ad8faafb8a6
    grev s5,t6,s7
    sd s5,32(a1)
    li s2, 0xd7ab5710cccb9502
    li s0, 0x7926d5b8de163e74
    grev t0,s2,s0
    sd t0,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
