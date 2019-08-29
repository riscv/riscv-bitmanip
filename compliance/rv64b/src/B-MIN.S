#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s6, 0xa7b2ca1a778bd1db
    li t0, 0x935b4969def3c035
    min t6,s6,t0
    sd t6,0(a1)
    li a5, 0x55f04ca8ffaace79
    li a7, 0x1a785a2011e15d6b
    min t5,a5,a7
    sd t5,8(a1)
    li t5, 0xb23279cf04bc5eac
    li s10, 0x2c4cb61533397f4e
    min a0,t5,s10
    sd a0,16(a1)
    li a0, 0x6b5ed10440ee4840
    li t2, 0x4aecd4a818331b85
    min s5,a0,t2
    sd s5,24(a1)
    li a6, 0x1607b7125a0d8ae2
    li t2, 0x05100ad8faafb8a6
    min s0,a6,t2
    sd s0,32(a1)
    li s7, 0xd7ab5710cccb9502
    li s10, 0x7926d5b8de163e74
    min s4,s7,s10
    sd s4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
