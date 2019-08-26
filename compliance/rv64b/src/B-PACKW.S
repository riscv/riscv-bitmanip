#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s2, 0xa7b2ca1a778bd1db
    li a2, 0x935b4969def3c035
    packw s7,s2,a2
    sd s7,0(a1)
    li t2, 0x55f04ca8ffaace79
    li t1, 0x1a785a2011e15d6b
    packw s2,t2,t1
    sd s2,8(a1)
    li s7, 0xb23279cf04bc5eac
    li t4, 0x2c4cb61533397f4e
    packw a6,s7,t4
    sd a6,16(a1)
    li s4, 0x6b5ed10440ee4840
    li s0, 0x4aecd4a818331b85
    packw t1,s4,s0
    sd t1,24(a1)
    li a7, 0x1607b7125a0d8ae2
    li s0, 0x05100ad8faafb8a6
    packw a6,a7,s0
    sd a6,32(a1)
    li t6, 0xd7ab5710cccb9502
    li s7, 0x7926d5b8de163e74
    packw s5,t6,s7
    sd s5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
