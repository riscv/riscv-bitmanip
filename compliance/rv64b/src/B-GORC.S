#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a6, 0xa7b2ca1a778bd1db
    li t2, 0x935b4969def3c035
    gorc t0,a6,t2
    sd t0,0(a1)
    li a4, 0x55f04ca8ffaace79
    li s8, 0x1a785a2011e15d6b
    gorc t4,a4,s8
    sd t4,8(a1)
    li t6, 0xb23279cf04bc5eac
    li a7, 0x2c4cb61533397f4e
    gorc s2,t6,a7
    sd s2,16(a1)
    li a4, 0x6b5ed10440ee4840
    li s0, 0x4aecd4a818331b85
    gorc s9,a4,s0
    sd s9,24(a1)
    li t1, 0x1607b7125a0d8ae2
    li a7, 0x05100ad8faafb8a6
    gorc s10,t1,a7
    sd s10,32(a1)
    li s4, 0xd7ab5710cccb9502
    li s5, 0x7926d5b8de163e74
    gorc s11,s4,s5
    sd s11,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
