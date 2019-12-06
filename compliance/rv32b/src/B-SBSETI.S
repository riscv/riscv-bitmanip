#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t2, 0x522a1063
    sbseti t5,t2,3
    sw t5,0(a1)
    li s4, 0x8a671b8c
    sbseti s3,s4,5
    sw s3,4(a1)
    li s7, 0x02eb0801
    sbseti t1,s7,17
    sw t1,8(a1)
    li a0, 0x43737b61
    sbseti s6,a0,24
    sw s6,12(a1)
    li t6, 0xf20d8a82
    sbseti t2,t6,25
    sw t2,16(a1)
    li a6, 0x9543c51a
    sbseti s4,a6,31
    sw s4,20(a1)
    li s10, 0x1014c66e
    sbseti s1,s10,12
    sw s1,24(a1)
    li a2, 0x1a3c3257
    sbseti s6,a2,8
    sw s6,28(a1)
    li a7, 0x88061100
    sbseti s10,a7,2
    sw s10,32(a1)
    li s7, 0xfebefbcc
    sbseti a7,s7,22
    sw a7,36(a1)
    sw zero,40(a1)
    sw zero,44(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 12,4,-1
RV_COMPLIANCE_DATA_END
