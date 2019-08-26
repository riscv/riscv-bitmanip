#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s7, 0xa7b2ca1a778bd1db
    li s10, 0x935b4969def3c035
    sbclrw s4,s7,s10
    sd s4,0(a1)
    li a7, 0x55f04ca8ffaace79
    li s10, 0x1a785a2011e15d6b
    sbclrw s4,a7,s10
    sd s4,8(a1)
    li s8, 0xb23279cf04bc5eac
    li s1, 0x2c4cb61533397f4e
    sbclrw s5,s8,s1
    sd s5,16(a1)
    li t0, 0x6b5ed10440ee4840
    li s4, 0x4aecd4a818331b85
    sbclrw s2,t0,s4
    sd s2,24(a1)
    li s3, 0x1607b7125a0d8ae2
    li s9, 0x05100ad8faafb8a6
    sbclrw s7,s3,s9
    sd s7,32(a1)
    li t2, 0xd7ab5710cccb9502
    li s6, 0x7926d5b8de163e74
    sbclrw s0,t2,s6
    sd s0,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
