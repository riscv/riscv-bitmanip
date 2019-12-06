#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s8, 0xa7b2ca1a778bd1db
    li s10, 0x935b4969def3c035
    subu.w t4,s8,s10
    sd t4,0(a1)
    li s10, 0x55f04ca8ffaace79
    li t0, 0x1a785a2011e15d6b
    subu.w s2,s10,t0
    sd s2,8(a1)
    li t0, 0xb23279cf04bc5eac
    li t6, 0x2c4cb61533397f4e
    subu.w t4,t0,t6
    sd t4,16(a1)
    li s1, 0x6b5ed10440ee4840
    li s10, 0x4aecd4a818331b85
    subu.w a4,s1,s10
    sd a4,24(a1)
    li s5, 0x1607b7125a0d8ae2
    li s11, 0x05100ad8faafb8a6
    subu.w t2,s5,s11
    sd t2,32(a1)
    li a7, 0xd7ab5710cccb9502
    li s0, 0x7926d5b8de163e74
    subu.w t3,a7,s0
    sd t3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
