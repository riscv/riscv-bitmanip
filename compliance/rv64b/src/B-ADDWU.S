#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s6, 0xa7b2ca1a778bd1db
    li a4, 0x935b4969def3c035
    addwu a2,s6,a4
    sd a2,0(a1)
    li a4, 0x55f04ca8ffaace79
    li t6, 0x1a785a2011e15d6b
    addwu a0,a4,t6
    sd a0,8(a1)
    li s2, 0xb23279cf04bc5eac
    li a0, 0x2c4cb61533397f4e
    addwu t5,s2,a0
    sd t5,16(a1)
    li s5, 0x6b5ed10440ee4840
    li s11, 0x4aecd4a818331b85
    addwu a7,s5,s11
    sd a7,24(a1)
    li t2, 0x1607b7125a0d8ae2
    li a2, 0x05100ad8faafb8a6
    addwu t1,t2,a2
    sd t1,32(a1)
    li s10, 0xd7ab5710cccb9502
    li s11, 0x7926d5b8de163e74
    addwu t6,s10,s11
    sd t6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
