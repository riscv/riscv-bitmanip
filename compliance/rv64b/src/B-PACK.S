#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t5, 0xa7b2ca1a778bd1db
    li t6, 0x935b4969def3c035
    pack s1,t5,t6
    sd s1,0(a1)
    li t2, 0x55f04ca8ffaace79
    li s1, 0x1a785a2011e15d6b
    pack t1,t2,s1
    sd t1,8(a1)
    li a5, 0xb23279cf04bc5eac
    li s6, 0x2c4cb61533397f4e
    pack a3,a5,s6
    sd a3,16(a1)
    li a2, 0x6b5ed10440ee4840
    li s9, 0x4aecd4a818331b85
    pack s8,a2,s9
    sd s8,24(a1)
    li a4, 0x1607b7125a0d8ae2
    li s9, 0x05100ad8faafb8a6
    pack t0,a4,s9
    sd t0,32(a1)
    li s6, 0xd7ab5710cccb9502
    li s5, 0x7926d5b8de163e74
    pack t0,s6,s5
    sd t0,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
