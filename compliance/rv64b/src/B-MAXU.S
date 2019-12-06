#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s8, 0xa7b2ca1a778bd1db
    li a2, 0x935b4969def3c035
    maxu t2,s8,a2
    sd t2,0(a1)
    li s6, 0x55f04ca8ffaace79
    li t5, 0x1a785a2011e15d6b
    maxu a4,s6,t5
    sd a4,8(a1)
    li s6, 0xb23279cf04bc5eac
    li s5, 0x2c4cb61533397f4e
    maxu t0,s6,s5
    sd t0,16(a1)
    li t0, 0x6b5ed10440ee4840
    li a0, 0x4aecd4a818331b85
    maxu t1,t0,a0
    sd t1,24(a1)
    li a7, 0x1607b7125a0d8ae2
    li s0, 0x05100ad8faafb8a6
    maxu a6,a7,s0
    sd a6,32(a1)
    li s7, 0xd7ab5710cccb9502
    li s8, 0x7926d5b8de163e74
    maxu t1,s7,s8
    sd t1,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
