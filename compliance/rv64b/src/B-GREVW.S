#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s5, 0xa7b2ca1a778bd1db
    li s1, 0x935b4969def3c035
    grevw s9,s5,s1
    sd s9,0(a1)
    li a0, 0x55f04ca8ffaace79
    li s5, 0x1a785a2011e15d6b
    grevw s6,a0,s5
    sd s6,8(a1)
    li s8, 0xb23279cf04bc5eac
    li a3, 0x2c4cb61533397f4e
    grevw s11,s8,a3
    sd s11,16(a1)
    li t6, 0x6b5ed10440ee4840
    li a4, 0x4aecd4a818331b85
    grevw t0,t6,a4
    sd t0,24(a1)
    li t1, 0x1607b7125a0d8ae2
    li a2, 0x05100ad8faafb8a6
    grevw s5,t1,a2
    sd s5,32(a1)
    li s4, 0xd7ab5710cccb9502
    li t6, 0x7926d5b8de163e74
    grevw a0,s4,t6
    sd a0,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
