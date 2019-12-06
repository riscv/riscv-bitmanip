#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s0, 0x522a1063
    sbinvi t5,s0,3
    sw t5,0(a1)
    li t3, 0x8a671b8c
    sbinvi t0,t3,5
    sw t0,4(a1)
    li t3, 0x02eb0801
    sbinvi a7,t3,17
    sw a7,8(a1)
    li s11, 0x43737b61
    sbinvi a6,s11,24
    sw a6,12(a1)
    li s2, 0xf20d8a82
    sbinvi t1,s2,25
    sw t1,16(a1)
    li s6, 0x9543c51a
    sbinvi s4,s6,31
    sw s4,20(a1)
    li s11, 0x1014c66e
    sbinvi s4,s11,12
    sw s4,24(a1)
    li s8, 0x1a3c3257
    sbinvi a5,s8,8
    sw a5,28(a1)
    li s0, 0x88061100
    sbinvi s10,s0,2
    sw s10,32(a1)
    li s6, 0xfebefbcc
    sbinvi s9,s6,22
    sw s9,36(a1)
    sw zero,40(a1)
    sw zero,44(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 12,4,-1
RV_COMPLIANCE_DATA_END
