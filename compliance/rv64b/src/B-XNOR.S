#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s4, 0xa7b2ca1a778bd1db
    li a2, 0x935b4969def3c035
    xnor t6,s4,a2
    sd t6,0(a1)
    li s1, 0x55f04ca8ffaace79
    li t4, 0x1a785a2011e15d6b
    xnor t3,s1,t4
    sd t3,8(a1)
    li a4, 0xb23279cf04bc5eac
    li t6, 0x2c4cb61533397f4e
    xnor s4,a4,t6
    sd s4,16(a1)
    li s2, 0x6b5ed10440ee4840
    li t6, 0x4aecd4a818331b85
    xnor s9,s2,t6
    sd s9,24(a1)
    li a7, 0x1607b7125a0d8ae2
    li s2, 0x05100ad8faafb8a6
    xnor s4,a7,s2
    sd s4,32(a1)
    li a5, 0xd7ab5710cccb9502
    li s7, 0x7926d5b8de163e74
    xnor a3,a5,s7
    sd a3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
