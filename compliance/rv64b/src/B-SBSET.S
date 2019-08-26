#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a0, 0xa7b2ca1a778bd1db
    li s7, 0x935b4969def3c035
    sbset t2,a0,s7
    sd t2,0(a1)
    li a7, 0x55f04ca8ffaace79
    li a5, 0x1a785a2011e15d6b
    sbset t2,a7,a5
    sd t2,8(a1)
    li s8, 0xb23279cf04bc5eac
    li a2, 0x2c4cb61533397f4e
    sbset t2,s8,a2
    sd t2,16(a1)
    li s2, 0x6b5ed10440ee4840
    li t6, 0x4aecd4a818331b85
    sbset s9,s2,t6
    sd s9,24(a1)
    li t1, 0x1607b7125a0d8ae2
    li a5, 0x05100ad8faafb8a6
    sbset t5,t1,a5
    sd t5,32(a1)
    li t1, 0xd7ab5710cccb9502
    li a7, 0x7926d5b8de163e74
    sbset s10,t1,a7
    sd s10,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
