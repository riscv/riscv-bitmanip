#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s7, 0xa7b2ca1a778bd1db
    li a3, 0x935b4969def3c035
    sbclrw t6,s7,a3
    sd t6,0(a1)
    li t6, 0x55f04ca8ffaace79
    li a4, 0x1a785a2011e15d6b
    sbclrw t0,t6,a4
    sd t0,8(a1)
    li s10, 0xb23279cf04bc5eac
    li a0, 0x2c4cb61533397f4e
    sbclrw t4,s10,a0
    sd t4,16(a1)
    li t0, 0x6b5ed10440ee4840
    li s1, 0x4aecd4a818331b85
    sbclrw t3,t0,s1
    sd t3,24(a1)
    li s2, 0x1607b7125a0d8ae2
    li s0, 0x05100ad8faafb8a6
    sbclrw t0,s2,s0
    sd t0,32(a1)
    li a2, 0xd7ab5710cccb9502
    li s0, 0x7926d5b8de163e74
    sbclrw t0,a2,s0
    sd t0,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
