#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s1, 0xa7b2ca1a778bd1db
    li t1, 0x935b4969def3c035
    sbinvw s6,s1,t1
    sd s6,0(a1)
    li t6, 0x55f04ca8ffaace79
    li a0, 0x1a785a2011e15d6b
    sbinvw a3,t6,a0
    sd a3,8(a1)
    li s7, 0xb23279cf04bc5eac
    li a3, 0x2c4cb61533397f4e
    sbinvw t6,s7,a3
    sd t6,16(a1)
    li s2, 0x6b5ed10440ee4840
    li a0, 0x4aecd4a818331b85
    sbinvw s7,s2,a0
    sd s7,24(a1)
    li a2, 0x1607b7125a0d8ae2
    li s5, 0x05100ad8faafb8a6
    sbinvw s6,a2,s5
    sd s6,32(a1)
    li a0, 0xd7ab5710cccb9502
    li a6, 0x7926d5b8de163e74
    sbinvw a5,a0,a6
    sd a5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
