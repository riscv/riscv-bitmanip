#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t0, 0x522a1063
    sbexti a4,t0,3
    sw a4,0(a1)
    li s6, 0x8a671b8c
    sbexti a2,s6,5
    sw a2,4(a1)
    li s5, 0x02eb0801
    sbexti a5,s5,17
    sw a5,8(a1)
    li s4, 0x43737b61
    sbexti s1,s4,24
    sw s1,12(a1)
    li s1, 0xf20d8a82
    sbexti t3,s1,25
    sw t3,16(a1)
    li s4, 0x9543c51a
    sbexti t0,s4,31
    sw t0,20(a1)
    li s4, 0x1014c66e
    sbexti a5,s4,12
    sw a5,24(a1)
    li s3, 0x1a3c3257
    sbexti a5,s3,8
    sw a5,28(a1)
    li a7, 0x88061100
    sbexti s2,a7,2
    sw s2,32(a1)
    li t0, 0xfebefbcc
    sbexti s2,t0,22
    sw s2,36(a1)
    sw zero,40(a1)
    sw zero,44(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 12,4,-1
RV_COMPLIANCE_DATA_END
