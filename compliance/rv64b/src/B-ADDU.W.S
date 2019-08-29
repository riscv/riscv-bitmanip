#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t2, 0xa7b2ca1a778bd1db
    li a7, 0x935b4969def3c035
    addu.w s1,t2,a7
    sd s1,0(a1)
    li a3, 0x55f04ca8ffaace79
    li t3, 0x1a785a2011e15d6b
    addu.w s11,a3,t3
    sd s11,8(a1)
    li a3, 0xb23279cf04bc5eac
    li s7, 0x2c4cb61533397f4e
    addu.w s5,a3,s7
    sd s5,16(a1)
    li s4, 0x6b5ed10440ee4840
    li t2, 0x4aecd4a818331b85
    addu.w s6,s4,t2
    sd s6,24(a1)
    li t5, 0x1607b7125a0d8ae2
    li a6, 0x05100ad8faafb8a6
    addu.w s9,t5,a6
    sd s9,32(a1)
    li s5, 0xd7ab5710cccb9502
    li t6, 0x7926d5b8de163e74
    addu.w a0,s5,t6
    sd a0,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
