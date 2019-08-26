#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a0, 0x522a1063
    li t2, 0xd2d6b642
    rol s5,a0,t2
    sw s5,0(a1)
    li s1, 0x8a671b8c
    li s9, 0x5b4289cf
    rol s5,s1,s9
    sw s5,4(a1)
    li s0, 0x02eb0801
    li a6, 0x81920806
    rol a4,s0,a6
    sw a4,8(a1)
    li s5, 0x43737b61
    li s1, 0x57861f11
    rol s9,s5,s1
    sw s9,12(a1)
    li t2, 0xf20d8a82
    li s1, 0x1ceb0c11
    rol s2,t2,s1
    sw s2,16(a1)
    li a2, 0x9543c51a
    li s5, 0x9a48a02c
    rol s6,a2,s5
    sw s6,20(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 6,4,-1
RV_COMPLIANCE_DATA_END
