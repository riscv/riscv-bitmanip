#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t6, 0xa7b2ca1a778bd1db
    li s4, 0x935b4969def3c035
    addwu s9,t6,s4
    sd s9,0(a1)
    li s4, 0x55f04ca8ffaace79
    li a5, 0x1a785a2011e15d6b
    addwu t5,s4,a5
    sd t5,8(a1)
    li t4, 0xb23279cf04bc5eac
    li s5, 0x2c4cb61533397f4e
    addwu a6,t4,s5
    sd a6,16(a1)
    li a4, 0x6b5ed10440ee4840
    li t5, 0x4aecd4a818331b85
    addwu t4,a4,t5
    sd t4,24(a1)
    li s10, 0x1607b7125a0d8ae2
    li s9, 0x05100ad8faafb8a6
    addwu s0,s10,s9
    sd s0,32(a1)
    li s8, 0xd7ab5710cccb9502
    li s10, 0x7926d5b8de163e74
    addwu s11,s8,s10
    sd s11,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
