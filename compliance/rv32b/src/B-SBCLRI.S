#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s9, 0x522a1063
    sbclri t1,s9,3
    sw t1,0(a1)
    li s6, 0x8a671b8c
    sbclri t6,s6,5
    sw t6,4(a1)
    li a4, 0x02eb0801
    sbclri t6,a4,17
    sw t6,8(a1)
    li s0, 0x43737b61
    sbclri s2,s0,24
    sw s2,12(a1)
    li t0, 0xf20d8a82
    sbclri a4,t0,25
    sw a4,16(a1)
    li s8, 0x9543c51a
    sbclri s4,s8,31
    sw s4,20(a1)
    li s7, 0x1014c66e
    sbclri s9,s7,12
    sw s9,24(a1)
    li a7, 0x1a3c3257
    sbclri t2,a7,8
    sw t2,28(a1)
    li s4, 0x88061100
    sbclri a3,s4,2
    sw a3,32(a1)
    li t4, 0xfebefbcc
    sbclri s7,t4,22
    sw s7,36(a1)
    sw zero,40(a1)
    sw zero,44(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 12,4,-1
RV_COMPLIANCE_DATA_END
