#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t4, 0xa7b2ca1a778bd1db
    addiwu s2,t4,53
    sd s2,0(a1)
    li a4, 0x55f04ca8ffaace79
    addiwu s11,a4,3435
    sd s11,8(a1)
    li s4, 0xb23279cf04bc5eac
    addiwu s8,s4,3918
    sd s8,16(a1)
    li s0, 0x6b5ed10440ee4840
    addiwu s11,s0,2949
    sd s11,24(a1)
    li a3, 0x1607b7125a0d8ae2
    addiwu s3,a3,2214
    sd s3,32(a1)
    li a6, 0xd7ab5710cccb9502
    addiwu s6,a6,3700
    sd s6,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
