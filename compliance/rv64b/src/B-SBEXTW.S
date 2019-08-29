#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s8, 0xa7b2ca1a778bd1db
    li a3, 0x935b4969def3c035
    sbextw s11,s8,a3
    sd s11,0(a1)
    li s10, 0x55f04ca8ffaace79
    li a2, 0x1a785a2011e15d6b
    sbextw a0,s10,a2
    sd a0,8(a1)
    li a0, 0xb23279cf04bc5eac
    li a6, 0x2c4cb61533397f4e
    sbextw a5,a0,a6
    sd a5,16(a1)
    li s7, 0x6b5ed10440ee4840
    li s8, 0x4aecd4a818331b85
    sbextw t1,s7,s8
    sd t1,24(a1)
    li s2, 0x1607b7125a0d8ae2
    li s7, 0x05100ad8faafb8a6
    sbextw s11,s2,s7
    sd s11,32(a1)
    li a3, 0xd7ab5710cccb9502
    li t1, 0x7926d5b8de163e74
    sbextw a6,a3,t1
    sd a6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
