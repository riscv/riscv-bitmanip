#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a6, 0x522a1063
    li t2, 0xd2d6b642
    unshfl s0,a6,t2
    sw s0,0(a1)
    li s11, 0x8a671b8c
    li a3, 0x5b4289cf
    unshfl s3,s11,a3
    sw s3,4(a1)
    li t6, 0x02eb0801
    li a0, 0x81920806
    unshfl a3,t6,a0
    sw a3,8(a1)
    li t0, 0x43737b61
    li s4, 0x57861f11
    unshfl s2,t0,s4
    sw s2,12(a1)
    li s10, 0xf20d8a82
    li a0, 0x1ceb0c11
    unshfl t4,s10,a0
    sw t4,16(a1)
    li s11, 0x9543c51a
    li a4, 0x9a48a02c
    unshfl s1,s11,a4
    sw s1,20(a1)
    li s7, 0x00d321db
    li a2, 0x4ae7185c
    unshfl a7,s7,a2
    sw a7,24(a1)
    li s1, 0x0f3ff336
    li a7, 0x4b10a48e
    unshfl a3,s1,a7
    sw a3,28(a1)
    li s3, 0xf807f882
    li t0, 0xa200000e
    unshfl a5,s3,t0
    sw a5,32(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 9,4,-1
RV_COMPLIANCE_DATA_END
