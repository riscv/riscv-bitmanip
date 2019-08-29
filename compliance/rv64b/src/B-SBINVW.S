#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t2, 0xa7b2ca1a778bd1db
    li s1, 0x935b4969def3c035
    sbinvw s2,t2,s1
    sd s2,0(a1)
    li a7, 0x55f04ca8ffaace79
    li s0, 0x1a785a2011e15d6b
    sbinvw a6,a7,s0
    sd a6,8(a1)
    li t2, 0xb23279cf04bc5eac
    li s6, 0x2c4cb61533397f4e
    sbinvw s0,t2,s6
    sd s0,16(a1)
    li s9, 0x6b5ed10440ee4840
    li s5, 0x4aecd4a818331b85
    sbinvw s7,s9,s5
    sd s7,24(a1)
    li t3, 0x1607b7125a0d8ae2
    li t5, 0x05100ad8faafb8a6
    sbinvw s11,t3,t5
    sd s11,32(a1)
    li s7, 0xd7ab5710cccb9502
    li a4, 0x7926d5b8de163e74
    sbinvw s11,s7,a4
    sd s11,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
