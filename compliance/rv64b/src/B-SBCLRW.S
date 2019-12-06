#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t1, 0xa7b2ca1a778bd1db
    li t3, 0x935b4969def3c035
    sbclrw a0,t1,t3
    sd a0,0(a1)
    li s11, 0x55f04ca8ffaace79
    li s3, 0x1a785a2011e15d6b
    sbclrw s6,s11,s3
    sd s6,8(a1)
    li a6, 0xb23279cf04bc5eac
    li s3, 0x2c4cb61533397f4e
    sbclrw s6,a6,s3
    sd s6,16(a1)
    li s5, 0x6b5ed10440ee4840
    li s11, 0x4aecd4a818331b85
    sbclrw t3,s5,s11
    sd t3,24(a1)
    li a5, 0x1607b7125a0d8ae2
    li t2, 0x05100ad8faafb8a6
    sbclrw s4,a5,t2
    sd s4,32(a1)
    li s0, 0xd7ab5710cccb9502
    li a4, 0x7926d5b8de163e74
    sbclrw t5,s0,a4
    sd t5,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
