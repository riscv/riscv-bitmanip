#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s4, 0xa7b2ca1a778bd1db
    li a5, 0x935b4969def3c035
    addu.w t1,s4,a5
    sd t1,0(a1)
    li t3, 0x55f04ca8ffaace79
    li t2, 0x1a785a2011e15d6b
    addu.w a0,t3,t2
    sd a0,8(a1)
    li s5, 0xb23279cf04bc5eac
    li s2, 0x2c4cb61533397f4e
    addu.w s7,s5,s2
    sd s7,16(a1)
    li s5, 0x6b5ed10440ee4840
    li t3, 0x4aecd4a818331b85
    addu.w t5,s5,t3
    sd t5,24(a1)
    li a7, 0x1607b7125a0d8ae2
    li t5, 0x05100ad8faafb8a6
    addu.w t1,a7,t5
    sd t1,32(a1)
    li t3, 0xd7ab5710cccb9502
    li s5, 0x7926d5b8de163e74
    addu.w s2,t3,s5
    sd s2,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
