#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t6, 0x522a1063
    li s4, 0xd2d6b642
    bext a2,t6,s4
    sw a2,0(a1)
    li a6, 0x8a671b8c
    li t2, 0x5b4289cf
    bext s0,a6,t2
    sw s0,4(a1)
    li s11, 0x02eb0801
    li a3, 0x81920806
    bext s3,s11,a3
    sw s3,8(a1)
    li t6, 0x43737b61
    li a0, 0x57861f11
    bext a3,t6,a0
    sw a3,12(a1)
    li t0, 0xf20d8a82
    li s4, 0x1ceb0c11
    bext s2,t0,s4
    sw s2,16(a1)
    li s10, 0x9543c51a
    li a0, 0x9a48a02c
    bext t4,s10,a0
    sw t4,20(a1)
    li s3, 0x8005f1fb
    li s5, 0xfff8ff00
    bext s7,s3,s5
    sw s7,24(a1)
    li t2, 0xbec13108
    li t3, 0x85082aff
    bext s6,t2,t3
    sw s6,28(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 8,4,-1
RV_COMPLIANCE_DATA_END
