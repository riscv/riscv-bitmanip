#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a4, 0x522a1063
    li s9, 0xd2d6b642
    bdep t0,a4,s9
    sw t0,0(a1)
    li t1, 0x8a671b8c
    li s10, 0x5b4289cf
    bdep s2,t1,s10
    sw s2,4(a1)
    li a5, 0x02eb0801
    li s7, 0x81920806
    bdep a3,a5,s7
    sw a3,8(a1)
    li s4, 0x43737b61
    li s5, 0x57861f11
    bdep s11,s4,s5
    sw s11,12(a1)
    li s2, 0xf20d8a82
    li a0, 0x1ceb0c11
    bdep s7,s2,a0
    sw s7,16(a1)
    li t2, 0x9543c51a
    li s6, 0x9a48a02c
    bdep s0,t2,s6
    sw s0,20(a1)
    li t6, 0x00c106e0
    li s6, 0x096008f1
    bdep s5,t6,s6
    sw s5,24(a1)
    li a7, 0x81008001
    li s5, 0x885d59ad
    bdep a3,a7,s5
    sw a3,28(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 8,4,-1
RV_COMPLIANCE_DATA_END
