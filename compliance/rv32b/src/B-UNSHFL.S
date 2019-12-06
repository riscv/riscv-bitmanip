#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a0, 0x522a1063
    li s5, 0xd2d6b642
    unshfl s6,a0,s5
    sw s6,0(a1)
    li s3, 0x8a671b8c
    li s1, 0x5b4289cf
    unshfl a2,s3,s1
    sw a2,4(a1)
    li a0, 0x02eb0801
    li a6, 0x81920806
    unshfl a5,a0,a6
    sw a5,8(a1)
    li a0, 0x43737b61
    li t0, 0x57861f11
    unshfl s7,a0,t0
    sw s7,12(a1)
    li a2, 0xf20d8a82
    li s0, 0x1ceb0c11
    unshfl t0,a2,s0
    sw t0,16(a1)
    li t0, 0x9543c51a
    li s9, 0x9a48a02c
    unshfl a3,t0,s9
    sw a3,20(a1)
    li s3, 0x00d321db
    li s7, 0x4ae7185c
    unshfl t3,s3,s7
    sw t3,24(a1)
    li s10, 0x0f3ff336
    li t1, 0x4b10a48e
    unshfl s1,s10,t1
    sw s1,28(a1)
    li s4, 0xf807f882
    li s11, 0xa200000e
    unshfl a5,s4,s11
    sw a5,32(a1)
    sw zero,36(a1)
    sw zero,40(a1)
    sw zero,44(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 12,4,-1
RV_COMPLIANCE_DATA_END
