#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t2, 0xa7b2ca1a778bd1db
    li t4, 0x935b4969def3c035
    addwu s6,t2,t4
    sd s6,0(a1)
    li a0, 0x55f04ca8ffaace79
    li a5, 0x1a785a2011e15d6b
    addwu s4,a0,a5
    sd s4,8(a1)
    li t1, 0xb23279cf04bc5eac
    li s8, 0x2c4cb61533397f4e
    addwu s9,t1,s8
    sd s9,16(a1)
    li t5, 0x6b5ed10440ee4840
    li t4, 0x4aecd4a818331b85
    addwu s6,t5,t4
    sd s6,24(a1)
    li s0, 0x1607b7125a0d8ae2
    li s8, 0x05100ad8faafb8a6
    addwu t3,s0,s8
    sd t3,32(a1)
    li t4, 0xd7ab5710cccb9502
    li a5, 0x7926d5b8de163e74
    addwu t6,t4,a5
    sd t6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
