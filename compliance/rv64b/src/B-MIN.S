#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t0, 0xa7b2ca1a778bd1db
    li a6, 0x935b4969def3c035
    min s11,t0,a6
    sd s11,0(a1)
    li s1, 0x55f04ca8ffaace79
    li t4, 0x1a785a2011e15d6b
    min t3,s1,t4
    sd t3,8(a1)
    li t0, 0xb23279cf04bc5eac
    li a2, 0x2c4cb61533397f4e
    min s8,t0,a2
    sd s8,16(a1)
    li t6, 0x6b5ed10440ee4840
    li a7, 0x4aecd4a818331b85
    min s2,t6,a7
    sd s2,24(a1)
    li s10, 0x1607b7125a0d8ae2
    li s2, 0x05100ad8faafb8a6
    min a4,s10,s2
    sd a4,32(a1)
    li s11, 0xd7ab5710cccb9502
    li a6, 0x7926d5b8de163e74
    min s4,s11,a6
    sd s4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
