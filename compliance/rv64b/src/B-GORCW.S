#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s4, 0xa7b2ca1a778bd1db
    li s0, 0x935b4969def3c035
    gorcw t1,s4,s0
    sd t1,0(a1)
    li s3, 0x55f04ca8ffaace79
    li s9, 0x1a785a2011e15d6b
    gorcw s7,s3,s9
    sd s7,8(a1)
    li a6, 0xb23279cf04bc5eac
    li s6, 0x2c4cb61533397f4e
    gorcw s9,a6,s6
    sd s9,16(a1)
    li s11, 0x6b5ed10440ee4840
    li a4, 0x4aecd4a818331b85
    gorcw s1,s11,a4
    sd s1,24(a1)
    li a7, 0x1607b7125a0d8ae2
    li t2, 0x05100ad8faafb8a6
    gorcw a4,a7,t2
    sd a4,32(a1)
    li a7, 0xd7ab5710cccb9502
    li s4, 0x7926d5b8de163e74
    gorcw a4,a7,s4
    sd a4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
