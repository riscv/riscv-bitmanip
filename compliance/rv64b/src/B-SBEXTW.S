#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t3, 0xa7b2ca1a778bd1db
    li s9, 0x935b4969def3c035
    sbextw s4,t3,s9
    sd s4,0(a1)
    li s4, 0x55f04ca8ffaace79
    li s5, 0x1a785a2011e15d6b
    sbextw s11,s4,s5
    sd s11,8(a1)
    li t2, 0xb23279cf04bc5eac
    li s1, 0x2c4cb61533397f4e
    sbextw s2,t2,s1
    sd s2,16(a1)
    li s3, 0x6b5ed10440ee4840
    li s1, 0x4aecd4a818331b85
    sbextw a2,s3,s1
    sd a2,24(a1)
    li s0, 0x1607b7125a0d8ae2
    li t4, 0x05100ad8faafb8a6
    sbextw s10,s0,t4
    sd s10,32(a1)
    li a6, 0xd7ab5710cccb9502
    li s6, 0x7926d5b8de163e74
    sbextw s9,a6,s6
    sd s9,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
