#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s5, 0x522a1063
    sbinvi t3,s5,3
    sw t3,0(a1)
    li a5, 0x8a671b8c
    sbinvi s4,a5,5
    sw s4,4(a1)
    li s0, 0x02eb0801
    sbinvi t5,s0,17
    sw t5,8(a1)
    li t3, 0x43737b61
    sbinvi t0,t3,24
    sw t0,12(a1)
    li t3, 0xf20d8a82
    sbinvi a7,t3,25
    sw a7,16(a1)
    li s11, 0x9543c51a
    sbinvi a6,s11,31
    sw a6,20(a1)
    li s8, 0x1014c66e
    sbinvi t3,s8,12
    sw t3,24(a1)
    li s2, 0x1a3c3257
    sbinvi t3,s2,8
    sw t3,28(a1)
    li s6, 0x88061100
    sbinvi a0,s6,2
    sw a0,32(a1)
    li s0, 0xfebefbcc
    sbinvi s1,s0,22
    sw s1,36(a1)
    sw zero,40(a1)
    sw zero,44(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 12,4,-1
RV_COMPLIANCE_DATA_END
