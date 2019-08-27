#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s2, 0x778bd1db
    li t0, 0xdef3c035
    xnor t4,s2,t0
    sw t4,0(a1)
    li s3, 0xffaace79
    li a3, 0x11e15d6b
    xnor t2,s3,a3
    sw t2,4(a1)
    li t6, 0x04bc5eac
    li s1, 0x33397f4e
    xnor s3,t6,s1
    sw s3,8(a1)
    li t6, 0x40ee4840
    li t2, 0x18331b85
    xnor a3,t6,t2
    sw a3,12(a1)
    li a6, 0x5a0d8ae2
    li t1, 0xfaafb8a6
    xnor a5,a6,t1
    sw a5,16(a1)
    li a6, 0xcccb9502
    li t6, 0xde163e74
    xnor t3,a6,t6
    sw t3,20(a1)
    li a7, 0xf7ef0b32
    li a4, 0xebffafa5
    xnor t5,a7,a4
    sw t5,24(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 7,4,-1
RV_COMPLIANCE_DATA_END
