#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t2, 0xa7b2ca1a778bd1db
    addiwu t6,t2,53
    sd t6,0(a1)
    li t1, 0x55f04ca8ffaace79
    addiwu a2,t1,-661
    sd a2,8(a1)
    li s4, 0xb23279cf04bc5eac
    addiwu s6,s4,-178
    sd s6,16(a1)
    li s10, 0x6b5ed10440ee4840
    addiwu t1,s10,-1147
    sd t1,24(a1)
    li s1, 0x1607b7125a0d8ae2
    addiwu a2,s1,-1882
    sd a2,32(a1)
    li s6, 0xd7ab5710cccb9502
    addiwu s8,s6,-396
    sd s8,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
