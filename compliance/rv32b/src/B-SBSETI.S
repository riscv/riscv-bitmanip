#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s7, 0x522a1063
    sbseti a5,s7,3
    sw a5,0(a1)
    li s3, 0x8a671b8c
    sbseti t6,s3,5
    sw t6,4(a1)
    li a5, 0x02eb0801
    sbseti s11,a5,17
    sw s11,8(a1)
    li s9, 0x43737b61
    sbseti a6,s9,24
    sw a6,12(a1)
    li t5, 0xf20d8a82
    sbseti a2,t5,25
    sw a2,16(a1)
    li t0, 0x9543c51a
    sbseti a4,t0,31
    sw a4,20(a1)
    li a7, 0x1014c66e
    sbseti s6,a7,12
    sw s6,24(a1)
    li t3, 0x1a3c3257
    sbseti s3,t3,8
    sw s3,28(a1)
    li t4, 0x88061100
    sbseti t3,t4,2
    sw t3,32(a1)
    li t6, 0xfebefbcc
    sbseti a6,t6,22
    sw a6,36(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 10,4,-1
RV_COMPLIANCE_DATA_END
