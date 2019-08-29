#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s6, 0xa7b2ca1a778bd1db
    li s7, 0x935b4969def3c035
    minu t3,s6,s7
    sd t3,0(a1)
    li a7, 0x55f04ca8ffaace79
    li a5, 0x1a785a2011e15d6b
    minu t2,a7,a5
    sd t2,8(a1)
    li t6, 0xb23279cf04bc5eac
    li s5, 0x2c4cb61533397f4e
    minu s11,t6,s5
    sd s11,16(a1)
    li s6, 0x6b5ed10440ee4840
    li t5, 0x4aecd4a818331b85
    minu a4,s6,t5
    sd a4,24(a1)
    li t1, 0x1607b7125a0d8ae2
    li s10, 0x05100ad8faafb8a6
    minu s2,t1,s10
    sd s2,32(a1)
    li s1, 0xd7ab5710cccb9502
    li t1, 0x7926d5b8de163e74
    minu s6,s1,t1
    sd s6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
