#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s7, 0x522a1063
    sbclri t1,s7,3
    sw t1,0(a1)
    li s2, 0x8a671b8c
    sbclri s11,s2,5
    sw s11,4(a1)
    li a3, 0x02eb0801
    sbclri a6,a3,17
    sw a6,8(a1)
    li a6, 0x43737b61
    sbclri s10,a6,24
    sw s10,12(a1)
    li a3, 0xf20d8a82
    sbclri s5,a3,25
    sw s5,16(a1)
    li t2, 0x9543c51a
    sbclri t3,t2,31
    sw t3,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
