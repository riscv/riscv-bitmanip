#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s5, 0xa7b2ca1a778bd1db
    li s6, 0x935b4969def3c035
    bfpw s1,s5,s6
    sd s1,0(a1)
    li s2, 0x55f04ca8ffaace79
    li s0, 0x1a785a2011e15d6b
    bfpw t0,s2,s0
    sd t0,8(a1)
    li s7, 0xb23279cf04bc5eac
    li a4, 0x2c4cb61533397f4e
    bfpw s11,s7,a4
    sd s11,16(a1)
    li a6, 0x6b5ed10440ee4840
    li t5, 0x4aecd4a818331b85
    bfpw s10,a6,t5
    sd s10,24(a1)
    li t3, 0x1607b7125a0d8ae2
    li s10, 0x05100ad8faafb8a6
    bfpw a3,t3,s10
    sd a3,32(a1)
    li s9, 0xd7ab5710cccb9502
    li a6, 0x7926d5b8de163e74
    bfpw t5,s9,a6
    sd t5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
