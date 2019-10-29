#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t3, 0xa7b2ca1a778bd1db
    addiwu s8,t3,53
    sd s8,0(a1)
    li s1, 0x55f04ca8ffaace79
    addiwu t1,s1,3435
    sd t1,8(a1)
    li s5, 0xb23279cf04bc5eac
    addiwu t5,s5,3918
    sd t5,16(a1)
    li t3, 0x6b5ed10440ee4840
    addiwu s3,t3,2949
    sd s3,24(a1)
    li t6, 0x1607b7125a0d8ae2
    addiwu s7,t6,2214
    sd s7,32(a1)
    li t0, 0xd7ab5710cccb9502
    addiwu a3,t0,3700
    sd a3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
