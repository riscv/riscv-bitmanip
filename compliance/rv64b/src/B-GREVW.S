#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s7, 0xa7b2ca1a778bd1db
    li a4, 0x935b4969def3c035
    grevw s11,s7,a4
    sd s11,0(a1)
    li a6, 0x55f04ca8ffaace79
    li t5, 0x1a785a2011e15d6b
    grevw s10,a6,t5
    sd s10,8(a1)
    li t3, 0xb23279cf04bc5eac
    li s10, 0x2c4cb61533397f4e
    grevw a3,t3,s10
    sd a3,16(a1)
    li s9, 0x6b5ed10440ee4840
    li a6, 0x4aecd4a818331b85
    grevw t5,s9,a6
    sd t5,24(a1)
    li t1, 0x1607b7125a0d8ae2
    li a0, 0x05100ad8faafb8a6
    grevw t2,t1,a0
    sd t2,32(a1)
    li a6, 0xd7ab5710cccb9502
    li t0, 0x7926d5b8de163e74
    grevw a0,a6,t0
    sd a0,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
