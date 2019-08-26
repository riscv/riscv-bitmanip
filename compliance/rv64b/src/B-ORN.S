#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a5, 0xa7b2ca1a778bd1db
    li s0, 0x935b4969def3c035
    orn t3,a5,s0
    sd t3,0(a1)
    li t1, 0x55f04ca8ffaace79
    li s6, 0x1a785a2011e15d6b
    orn s7,t1,s6
    sd s7,8(a1)
    li s3, 0xb23279cf04bc5eac
    li t0, 0x2c4cb61533397f4e
    orn s9,s3,t0
    sd s9,16(a1)
    li s10, 0x6b5ed10440ee4840
    li t6, 0x4aecd4a818331b85
    orn s5,s10,t6
    sd s5,24(a1)
    li t0, 0x1607b7125a0d8ae2
    li a3, 0x05100ad8faafb8a6
    orn s2,t0,a3
    sd s2,32(a1)
    li t1, 0xd7ab5710cccb9502
    li s10, 0x7926d5b8de163e74
    orn s2,t1,s10
    sd s2,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
