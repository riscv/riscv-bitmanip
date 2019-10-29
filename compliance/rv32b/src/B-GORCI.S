#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t1, 0x522a1063
    gorci t3,t1,3
    sw t3,0(a1)
    li t2, 0x8a671b8c
    gorci t3,t2,5
    sw t3,4(a1)
    li s8, 0x02eb0801
    gorci s11,s8,17
    sw s11,8(a1)
    li t1, 0x43737b61
    gorci a4,t1,24
    sw a4,12(a1)
    li a4, 0xf20d8a82
    gorci a3,a4,25
    sw a3,16(a1)
    li t6, 0x9543c51a
    gorci a3,t6,31
    sw a3,20(a1)
    li s8, 0x00000281
    gorci s7,s8,19
    sw s7,24(a1)
    li t1, 0xc0002800
    gorci s10,t1,28
    sw s10,28(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 8,4,-1
RV_COMPLIANCE_DATA_END
