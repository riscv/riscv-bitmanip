#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t3, 0xa7b2ca1a778bd1db
    li t4, 0x935b4969def3c035
    subu.w s11,t3,t4
    sd s11,0(a1)
    li s6, 0x55f04ca8ffaace79
    li s10, 0x1a785a2011e15d6b
    subu.w s0,s6,s10
    sd s0,8(a1)
    li a0, 0xb23279cf04bc5eac
    li s1, 0x2c4cb61533397f4e
    subu.w s6,a0,s1
    sd s6,16(a1)
    li a6, 0x6b5ed10440ee4840
    li s7, 0x4aecd4a818331b85
    subu.w a3,a6,s7
    sd a3,24(a1)
    li s11, 0x1607b7125a0d8ae2
    li s1, 0x05100ad8faafb8a6
    subu.w s10,s11,s1
    sd s10,32(a1)
    li s4, 0xd7ab5710cccb9502
    li s1, 0x7926d5b8de163e74
    subu.w t4,s4,s1
    sd t4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
