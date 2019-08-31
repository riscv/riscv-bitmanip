#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t3, 0x522a1063
    gorci s11,t3,3
    sw s11,0(a1)
    li a3, 0x8a671b8c
    gorci a6,a3,5
    sw a6,4(a1)
    li t0, 0x02eb0801
    gorci a3,t0,17
    sw a3,8(a1)
    li a3, 0x43737b61
    gorci t1,a3,24
    sw t1,12(a1)
    li s11, 0xf20d8a82
    gorci t4,s11,25
    sw t4,16(a1)
    li s8, 0x9543c51a
    gorci a6,s8,31
    sw a6,20(a1)
    li a2, 0x00000281
    gorci a5,a2,19
    sw a5,24(a1)
    li a0, 0xc0002800
    gorci t1,a0,28
    sw t1,28(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 8,4,-1
RV_COMPLIANCE_DATA_END
