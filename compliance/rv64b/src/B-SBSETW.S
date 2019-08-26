#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s1, 0xa7b2ca1a778bd1db
    li s4, 0x935b4969def3c035
    sbsetw a0,s1,s4
    sd a0,0(a1)
    li t0, 0x55f04ca8ffaace79
    li a0, 0x1a785a2011e15d6b
    sbsetw t1,t0,a0
    sd t1,8(a1)
    li s1, 0xb23279cf04bc5eac
    li t4, 0x2c4cb61533397f4e
    sbsetw t0,s1,t4
    sd t0,16(a1)
    li s2, 0x6b5ed10440ee4840
    li t3, 0x4aecd4a818331b85
    sbsetw s8,s2,t3
    sd s8,24(a1)
    li s10, 0x1607b7125a0d8ae2
    li a2, 0x05100ad8faafb8a6
    sbsetw a0,s10,a2
    sd a0,32(a1)
    li s10, 0xd7ab5710cccb9502
    li a0, 0x7926d5b8de163e74
    sbsetw t4,s10,a0
    sd t4,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
