#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a7, 0xa7b2ca1a778bd1db
    addiwu s1,a7,53
    sd s1,0(a1)
    li a0, 0x55f04ca8ffaace79
    addiwu a7,a0,3435
    sd a7,8(a1)
    li s9, 0xb23279cf04bc5eac
    addiwu a4,s9,3918
    sd a4,16(a1)
    li t0, 0x6b5ed10440ee4840
    addiwu s0,t0,2949
    sd s0,24(a1)
    li a5, 0x1607b7125a0d8ae2
    addiwu a7,a5,2214
    sd a7,32(a1)
    li a6, 0xd7ab5710cccb9502
    addiwu a3,a6,3700
    sd a3,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
