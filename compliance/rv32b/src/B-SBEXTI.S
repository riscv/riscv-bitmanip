#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s9, 0x522a1063
    sbexti a6,s9,3
    sw a6,0(a1)
    li t5, 0x8a671b8c
    sbexti a2,t5,5
    sw a2,4(a1)
    li t0, 0x02eb0801
    sbexti a4,t0,17
    sw a4,8(a1)
    li s6, 0x43737b61
    sbexti a2,s6,24
    sw a2,12(a1)
    li s5, 0xf20d8a82
    sbexti a5,s5,25
    sw a5,16(a1)
    li s4, 0x9543c51a
    sbexti s1,s4,31
    sw s1,20(a1)
    li a2, 0x1014c66e
    sbexti s11,a2,12
    sw s11,24(a1)
    li t6, 0x1a3c3257
    sbexti s2,t6,8
    sw s2,28(a1)
    li s10, 0x88061100
    sbexti s2,s10,2
    sw s2,32(a1)
    li t6, 0xfebefbcc
    sbexti s0,t6,22
    sw s0,36(a1)
    sw zero,40(a1)
    sw zero,44(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 12,4,-1
RV_COMPLIANCE_DATA_END
