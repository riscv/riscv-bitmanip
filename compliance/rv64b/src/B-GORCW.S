#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t0, 0xa7b2ca1a778bd1db
    li s7, 0x935b4969def3c035
    gorcw s1,t0,s7
    sd s1,0(a1)
    li t1, 0x55f04ca8ffaace79
    li t3, 0x1a785a2011e15d6b
    gorcw a0,t1,t3
    sd a0,8(a1)
    li s11, 0xb23279cf04bc5eac
    li s3, 0x2c4cb61533397f4e
    gorcw s6,s11,s3
    sd s6,16(a1)
    li a6, 0x6b5ed10440ee4840
    li s3, 0x4aecd4a818331b85
    gorcw s6,a6,s3
    sd s6,24(a1)
    li s5, 0x1607b7125a0d8ae2
    li s11, 0x05100ad8faafb8a6
    gorcw t3,s5,s11
    sd t3,32(a1)
    li a5, 0xd7ab5710cccb9502
    li t2, 0x7926d5b8de163e74
    gorcw s4,a5,t2
    sd s4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
