#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t0, 0xa7b2ca1a778bd1db
    li t2, 0x935b4969def3c035
    subwu s7,t0,t2
    sd s7,0(a1)
    li t4, 0x55f04ca8ffaace79
    li t1, 0x1a785a2011e15d6b
    subwu a6,t4,t1
    sd a6,8(a1)
    li t3, 0xb23279cf04bc5eac
    li t1, 0x2c4cb61533397f4e
    subwu s11,t3,t1
    sd s11,16(a1)
    li s0, 0x6b5ed10440ee4840
    li s8, 0x4aecd4a818331b85
    subwu s6,s0,s8
    sd s6,24(a1)
    li s0, 0x1607b7125a0d8ae2
    li s11, 0x05100ad8faafb8a6
    subwu s5,s0,s11
    sd s5,32(a1)
    li s1, 0xd7ab5710cccb9502
    li t1, 0x7926d5b8de163e74
    subwu s6,s1,t1
    sd s6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
