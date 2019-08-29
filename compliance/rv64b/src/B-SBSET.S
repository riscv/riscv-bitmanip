#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s7, 0xa7b2ca1a778bd1db
    li t3, 0x935b4969def3c035
    sbset s6,s7,t3
    sd s6,0(a1)
    li a6, 0x55f04ca8ffaace79
    li t1, 0x1a785a2011e15d6b
    sbset a5,a6,t1
    sd a5,8(a1)
    li t5, 0xb23279cf04bc5eac
    li s3, 0x2c4cb61533397f4e
    sbset a6,t5,s3
    sd a6,16(a1)
    li t6, 0x6b5ed10440ee4840
    li s4, 0x4aecd4a818331b85
    sbset a2,t6,s4
    sd a2,24(a1)
    li s11, 0x1607b7125a0d8ae2
    li a6, 0x05100ad8faafb8a6
    sbset s4,s11,a6
    sd s4,32(a1)
    li t2, 0xd7ab5710cccb9502
    li t1, 0x7926d5b8de163e74
    sbset s2,t2,t1
    sd s2,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
