#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a5, 0xa7b2ca1a778bd1db
    li s6, 0x935b4969def3c035
    packu a3,a5,s6
    sd a3,0(a1)
    li a0, 0x55f04ca8ffaace79
    li a5, 0x1a785a2011e15d6b
    packu a7,a0,a5
    sd a7,8(a1)
    li a0, 0xb23279cf04bc5eac
    li s11, 0x2c4cb61533397f4e
    packu s0,a0,s11
    sd s0,16(a1)
    li s7, 0x6b5ed10440ee4840
    li s10, 0x4aecd4a818331b85
    packu s4,s7,s10
    sd s4,24(a1)
    li s2, 0x1607b7125a0d8ae2
    li t3, 0x05100ad8faafb8a6
    packu s8,s2,t3
    sd s8,32(a1)
    li s8, 0xd7ab5710cccb9502
    li a2, 0x7926d5b8de163e74
    packu a3,s8,a2
    sd a3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
