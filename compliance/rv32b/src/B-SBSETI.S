#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s9, 0x522a1063
    sbseti s7,s9,3
    sw s7,0(a1)
    li t3, 0x8a671b8c
    sbseti s11,t3,5
    sw s11,4(a1)
    li s7, 0x02eb0801
    sbseti s11,s7,17
    sw s11,8(a1)
    li a5, 0x43737b61
    sbseti t2,a5,24
    sw t2,12(a1)
    li t1, 0xf20d8a82
    sbseti t3,t1,25
    sw t3,16(a1)
    li s9, 0x9543c51a
    sbseti a6,s9,31
    sw a6,20(a1)
    li s4, 0x1014c66e
    sbseti a4,s4,12
    sw a4,24(a1)
    li s9, 0x1a3c3257
    sbseti s6,s9,8
    sw s6,28(a1)
    li a3, 0x88061100
    sbseti a0,a3,2
    sw a0,32(a1)
    li s5, 0xfebefbcc
    sbseti s6,s5,22
    sw s6,36(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 10,4,-1
RV_COMPLIANCE_DATA_END
