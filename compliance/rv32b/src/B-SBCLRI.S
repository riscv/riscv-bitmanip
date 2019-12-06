#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t1, 0x522a1063
    sbclri a5,t1,3
    sw a5,0(a1)
    li s4, 0x8a671b8c
    sbclri t5,s4,5
    sw t5,4(a1)
    li s9, 0x02eb0801
    sbclri t1,s9,17
    sw t1,8(a1)
    li s6, 0x43737b61
    sbclri t6,s6,24
    sw t6,12(a1)
    li a4, 0xf20d8a82
    sbclri t6,a4,25
    sw t6,16(a1)
    li s0, 0x9543c51a
    sbclri s2,s0,31
    sw s2,20(a1)
    li a7, 0x1014c66e
    sbclri a3,a7,12
    sw a3,24(a1)
    li t1, 0x1a3c3257
    sbclri s4,t1,8
    sw s4,28(a1)
    li t4, 0x88061100
    sbclri s6,t4,2
    sw s6,32(a1)
    li a4, 0xfebefbcc
    sbclri s10,a4,22
    sw s10,36(a1)
    sw zero,40(a1)
    sw zero,44(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 12,4,-1
RV_COMPLIANCE_DATA_END
