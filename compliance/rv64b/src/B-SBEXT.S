#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a2, 0xa7b2ca1a778bd1db
    li a6, 0x935b4969def3c035
    sbext t0,a2,a6
    sd t0,0(a1)
    li t6, 0x55f04ca8ffaace79
    li a7, 0x1a785a2011e15d6b
    sbext s2,t6,a7
    sd s2,8(a1)
    li t1, 0xb23279cf04bc5eac
    li a5, 0x2c4cb61533397f4e
    sbext t5,t1,a5
    sd t5,16(a1)
    li a5, 0x6b5ed10440ee4840
    li s7, 0x4aecd4a818331b85
    sbext a3,a5,s7
    sd a3,24(a1)
    li t2, 0x1607b7125a0d8ae2
    li s1, 0x05100ad8faafb8a6
    sbext s2,t2,s1
    sd s2,32(a1)
    li a0, 0xd7ab5710cccb9502
    li a6, 0x7926d5b8de163e74
    sbext a5,a0,a6
    sd a5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
