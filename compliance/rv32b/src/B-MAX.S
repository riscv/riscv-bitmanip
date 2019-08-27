#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t4, 0x778bd1db
    li s9, 0xdef3c035
    max s3,t4,s9
    sw s3,0(a1)
    li s6, 0xffaace79
    li a0, 0x11e15d6b
    max s5,s6,a0
    sw s5,4(a1)
    li s4, 0x04bc5eac
    li a2, 0x33397f4e
    max t6,s4,a2
    sw t6,8(a1)
    li s10, 0x40ee4840
    li t6, 0x18331b85
    max s3,s10,t6
    sw s3,12(a1)
    li a4, 0x5a0d8ae2
    li s8, 0xfaafb8a6
    max t4,a4,s8
    sw t4,16(a1)
    li a7, 0xcccb9502
    li t0, 0xde163e74
    max a6,a7,t0
    sw a6,20(a1)
    li t5, 0x382e991b
    li a5, 0x382e999b
    max s11,t5,a5
    sw s11,24(a1)
    li s10, 0x41040098
    li t2, 0x41000098
    max t1,s10,t2
    sw t1,28(a1)
    li a6, 0xde7ca325
    li t5, 0xde7ca724
    max s4,a6,t5
    sw s4,32(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 9,4,-1
RV_COMPLIANCE_DATA_END
