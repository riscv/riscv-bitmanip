#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t5, 0xa7b2ca1a778bd1db
    addiwu a6,t5,53
    sd a6,0(a1)
    li s7, 0x55f04ca8ffaace79
    addiwu a4,s7,-661
    sd a4,8(a1)
    li t2, 0xb23279cf04bc5eac
    addiwu s3,t2,-178
    sd s3,16(a1)
    li a5, 0x6b5ed10440ee4840
    addiwu a7,a5,-1147
    sd a7,24(a1)
    li s6, 0x1607b7125a0d8ae2
    addiwu a6,s6,-1882
    sd a6,32(a1)
    li s7, 0xd7ab5710cccb9502
    addiwu a2,s7,-396
    sd a2,40(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,8,-1
RV_COMPLIANCE_DATA_END
