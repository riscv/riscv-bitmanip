#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t3, 0xa7b2ca1a778bd1db
    li t5, 0x935b4969def3c035
    packw s11,t3,t5
    sd s11,0(a1)
    li a3, 0x55f04ca8ffaace79
    li t1, 0x1a785a2011e15d6b
    packw a6,a3,t1
    sd a6,8(a1)
    li t0, 0xb23279cf04bc5eac
    li s9, 0x2c4cb61533397f4e
    packw a3,t0,s9
    sd a3,16(a1)
    li a3, 0x6b5ed10440ee4840
    li s1, 0x4aecd4a818331b85
    packw t1,a3,s1
    sd t1,24(a1)
    li s11, 0x1607b7125a0d8ae2
    li a6, 0x05100ad8faafb8a6
    packw t4,s11,a6
    sd t4,32(a1)
    li s8, 0xd7ab5710cccb9502
    li a0, 0x7926d5b8de163e74
    packw a6,s8,a0
    sd a6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
