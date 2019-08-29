#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s2, 0x522a1063
    grevi s11,s2,3
    sw s11,0(a1)
    li a7, 0x8a671b8c
    grevi a4,a7,5
    sw a4,4(a1)
    li a3, 0x02eb0801
    grevi t6,a3,17
    sw t6,8(a1)
    li a7, 0x43737b61
    grevi a0,a7,24
    sw a0,12(a1)
    li s10, 0xf20d8a82
    grevi t4,s10,25
    sw t4,16(a1)
    li t5, 0x9543c51a
    grevi s4,t5,31
    sw s4,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
