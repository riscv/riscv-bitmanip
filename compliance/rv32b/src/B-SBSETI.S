#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a7, 0x522a1063
    sbseti t6,a7,3
    sw t6,0(a1)
    li t3, 0x8a671b8c
    sbseti s2,t3,5
    sw s2,4(a1)
    li t2, 0x02eb0801
    sbseti t5,t2,17
    sw t5,8(a1)
    li s4, 0x43737b61
    sbseti s3,s4,24
    sw s3,12(a1)
    li s7, 0xf20d8a82
    sbseti t1,s7,25
    sw t1,16(a1)
    li a0, 0x9543c51a
    sbseti s6,a0,31
    sw s6,20(a1)
    li s4, 0x1014c66e
    sbseti s1,s4,12
    sw s1,24(a1)
    li t3, 0x1a3c3257
    sbseti s5,t3,8
    sw s5,28(a1)
    li a5, 0x88061100
    sbseti t4,a5,2
    sw t4,32(a1)
    li a0, 0xfebefbcc
    sbseti t0,a0,22
    sw t0,36(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 10,4,-1
RV_COMPLIANCE_DATA_END
