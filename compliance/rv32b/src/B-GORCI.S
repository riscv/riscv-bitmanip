#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s8, 0x522a1063
    gorci s11,s8,3
    sw s11,0(a1)
    li t1, 0x8a671b8c
    gorci a4,t1,5
    sw a4,4(a1)
    li a4, 0x02eb0801
    gorci a3,a4,17
    sw a3,8(a1)
    li t6, 0x43737b61
    gorci a3,t6,24
    sw a3,12(a1)
    li t6, 0xf20d8a82
    gorci s5,t6,25
    sw s5,16(a1)
    li t3, 0x9543c51a
    gorci s2,t3,31
    sw s2,20(a1)
    li s10, 0x00000281
    gorci a0,s10,19
    sw a0,24(a1)
    li s9, 0xc0002800
    gorci a5,s9,28
    sw a5,28(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 8,4,-1
RV_COMPLIANCE_DATA_END
