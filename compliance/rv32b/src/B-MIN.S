#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t4, 0x778bd1db
    li s10, 0xdef3c035
    min s6,t4,s10
    sw s6,0(a1)
    li a3, 0xffaace79
    li a5, 0x11e15d6b
    min a2,a3,a5
    sw a2,4(a1)
    li s6, 0x04bc5eac
    li a5, 0x33397f4e
    min a6,s6,a5
    sw a6,8(a1)
    li a6, 0x40ee4840
    li t2, 0x18331b85
    min t0,a6,t2
    sw t0,12(a1)
    li a2, 0x5a0d8ae2
    li a6, 0xfaafb8a6
    min t0,a2,a6
    sw t0,16(a1)
    li t5, 0xcccb9502
    li s3, 0xde163e74
    min a6,t5,s3
    sw a6,20(a1)
    li t6, 0x1051ac9a
    li s11, 0x1051a9d8
    min a5,t6,s11
    sw a5,24(a1)
    li a6, 0x5583d725
    li s4, 0x5513f76d
    min t1,a6,s4
    sw t1,28(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 8,4,-1
RV_COMPLIANCE_DATA_END
