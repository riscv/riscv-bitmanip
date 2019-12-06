#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s2, 0xa7b2ca1a778bd1db
    li s7, 0x935b4969def3c035
    packuw s11,s2,s7
    sd s11,0(a1)
    li a7, 0x55f04ca8ffaace79
    li s4, 0x1a785a2011e15d6b
    packuw a4,a7,s4
    sd a4,8(a1)
    li a3, 0xb23279cf04bc5eac
    li s9, 0x2c4cb61533397f4e
    packuw t6,a3,s9
    sd t6,16(a1)
    li a7, 0x6b5ed10440ee4840
    li s4, 0x4aecd4a818331b85
    packuw a0,a7,s4
    sd a0,24(a1)
    li s10, 0x1607b7125a0d8ae2
    li t3, 0x05100ad8faafb8a6
    packuw t4,s10,t3
    sd t4,32(a1)
    li t5, 0xd7ab5710cccb9502
    li s10, 0x7926d5b8de163e74
    packuw s4,t5,s10
    sd s4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
