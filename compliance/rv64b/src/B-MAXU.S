#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a0, 0xa7b2ca1a778bd1db
    li s7, 0x935b4969def3c035
    maxu t2,a0,s7
    sd t2,0(a1)
    li s9, 0x55f04ca8ffaace79
    li s10, 0x1a785a2011e15d6b
    maxu a6,s9,s10
    sd a6,8(a1)
    li a5, 0xb23279cf04bc5eac
    li a4, 0x2c4cb61533397f4e
    maxu t4,a5,a4
    sd t4,16(a1)
    li t0, 0x6b5ed10440ee4840
    li a3, 0x4aecd4a818331b85
    maxu s2,t0,a3
    sd s2,24(a1)
    li s6, 0x1607b7125a0d8ae2
    li s5, 0x05100ad8faafb8a6
    maxu t0,s6,s5
    sd t0,32(a1)
    li s5, 0xd7ab5710cccb9502
    li s1, 0x7926d5b8de163e74
    maxu s9,s5,s1
    sd s9,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
