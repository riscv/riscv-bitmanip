#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s7, 0x522a1063
    sbexti s11,s7,3
    sw s11,0(a1)
    li a6, 0x8a671b8c
    sbexti s10,a6,5
    sw s10,4(a1)
    li t3, 0x02eb0801
    sbexti a3,t3,17
    sw a3,8(a1)
    li s9, 0x43737b61
    sbexti t5,s9,24
    sw t5,12(a1)
    li t1, 0xf20d8a82
    sbexti t2,t1,25
    sw t2,16(a1)
    li a6, 0x9543c51a
    sbexti a0,a6,31
    sw a0,20(a1)
    li a5, 0x1014c66e
    sbexti a4,a5,12
    sw a4,24(a1)
    li t2, 0x1a3c3257
    sbexti a6,t2,8
    sw a6,28(a1)
    li t2, 0x88061100
    sbexti a4,t2,2
    sw a4,32(a1)
    li a7, 0xfebefbcc
    sbexti t5,a7,22
    sw t5,36(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 10,4,-1
RV_COMPLIANCE_DATA_END
