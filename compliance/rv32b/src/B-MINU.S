#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a3, 0x778bd1db
    li t6, 0xdef3c035
    minu a6,a3,t6
    sw a6,0(a1)
    li a4, 0xffaace79
    li t2, 0x11e15d6b
    minu a3,a4,t2
    sw a3,4(a1)
    li a5, 0x04bc5eac
    li s0, 0x33397f4e
    minu t3,a5,s0
    sw t3,8(a1)
    li t1, 0x40ee4840
    li s6, 0x18331b85
    minu s7,t1,s6
    sw s7,12(a1)
    li s3, 0x5a0d8ae2
    li t0, 0xfaafb8a6
    minu s9,s3,t0
    sw s9,16(a1)
    li s10, 0xcccb9502
    li t6, 0xde163e74
    minu s5,s10,t6
    sw s5,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
