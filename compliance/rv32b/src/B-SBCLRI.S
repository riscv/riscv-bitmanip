#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s1, 0x522a1063
    sbclri t2,s1,3
    sw t2,0(a1)
    li a7, 0x8a671b8c
    sbclri s3,a7,5
    sw s3,4(a1)
    li t1, 0x02eb0801
    sbclri t3,t1,17
    sw t3,8(a1)
    li t2, 0x43737b61
    sbclri t3,t2,24
    sw t3,12(a1)
    li s8, 0xf20d8a82
    sbclri s11,s8,25
    sw s11,16(a1)
    li t1, 0x9543c51a
    sbclri a4,t1,31
    sw a4,20(a1)
    li a3, 0x1014c66e
    sbclri s6,a3,12
    sw s6,24(a1)
    li a2, 0x1a3c3257
    sbclri s6,a2,8
    sw s6,28(a1)
    li s6, 0x88061100
    sbclri s7,s6,2
    sw s7,32(a1)
    li t0, 0xfebefbcc
    sbclri a5,t0,22
    sw a5,36(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 10,4,-1
RV_COMPLIANCE_DATA_END
