#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s0, 0xa7b2ca1a778bd1db
    li t4, 0x935b4969def3c035
    maxu s7,s0,t4
    sd s7,0(a1)
    li t5, 0x55f04ca8ffaace79
    li s3, 0x1a785a2011e15d6b
    maxu a6,t5,s3
    sd a6,8(a1)
    li s10, 0xb23279cf04bc5eac
    li s2, 0x2c4cb61533397f4e
    maxu a4,s10,s2
    sd a4,16(a1)
    li t1, 0x6b5ed10440ee4840
    li a7, 0x4aecd4a818331b85
    maxu s10,t1,a7
    sd s10,24(a1)
    li s7, 0x1607b7125a0d8ae2
    li t4, 0x05100ad8faafb8a6
    maxu a6,s7,t4
    sd a6,32(a1)
    li t1, 0xd7ab5710cccb9502
    li a2, 0x7926d5b8de163e74
    maxu s5,t1,a2
    sd s5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
