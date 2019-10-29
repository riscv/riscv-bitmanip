#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a6, 0xa7b2ca1a778bd1db
    li t2, 0x935b4969def3c035
    orn t0,a6,t2
    sd t0,0(a1)
    li t0, 0x55f04ca8ffaace79
    li a2, 0x1a785a2011e15d6b
    orn s8,t0,a2
    sd s8,8(a1)
    li s2, 0xb23279cf04bc5eac
    li t6, 0x2c4cb61533397f4e
    orn s9,s2,t6
    sd s9,16(a1)
    li a5, 0x6b5ed10440ee4840
    li s3, 0x4aecd4a818331b85
    orn a3,a5,s3
    sd a3,24(a1)
    li s1, 0x1607b7125a0d8ae2
    li t1, 0x05100ad8faafb8a6
    orn s6,s1,t1
    sd s6,32(a1)
    li t0, 0xd7ab5710cccb9502
    li s4, 0x7926d5b8de163e74
    orn s2,t0,s4
    sd s2,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
