#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a2, 0xa7b2ca1a778bd1db
    li s0, 0x935b4969def3c035
    gorcw t0,a2,s0
    sd t0,0(a1)
    li a5, 0x55f04ca8ffaace79
    li a0, 0x1a785a2011e15d6b
    gorcw t2,a5,a0
    sd t2,8(a1)
    li a3, 0xb23279cf04bc5eac
    li a6, 0x2c4cb61533397f4e
    gorcw s5,a3,a6
    sd s5,16(a1)
    li s3, 0x6b5ed10440ee4840
    li s10, 0x4aecd4a818331b85
    gorcw s7,s3,s10
    sd s7,24(a1)
    li s3, 0x1607b7125a0d8ae2
    li a0, 0x05100ad8faafb8a6
    gorcw a4,s3,a0
    sd a4,32(a1)
    li s0, 0xd7ab5710cccb9502
    li a0, 0x7926d5b8de163e74
    gorcw a3,s0,a0
    sd a3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
