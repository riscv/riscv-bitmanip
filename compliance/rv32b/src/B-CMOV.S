#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t1, 0x5dd79cfa
    li s11, 0xc4ed4893
    li t6, 0x987a10dd
    cmov a4,t1,s11,t6
    sw a4,0(a1)
    li a3, 0x9c6f7aa2
    li s6, 0xfcae8655
    li s1, 0x02a2826c
    cmov s0,a3,s6,s1
    sw s0,4(a1)
    li s6, 0xa8a22391
    li t2, 0x1b4286dd
    li a5, 0x988c0022
    cmov a2,s6,t2,a5
    sw a2,8(a1)
    li s9, 0x430b3272
    li a7, 0x2b77485c
    li a2, 0x8b8e8f3e
    cmov s3,s9,a7,a2
    sw s3,12(a1)
    li t3, 0xadd85909
    li s10, 0x116023b7
    li s1, 0x29d882a1
    cmov a7,t3,s10,s1
    sw a7,16(a1)
    li s7, 0x00000000
    li s4, 0x2ba53005
    li a2, 0xb208965f
    cmov s5,s7,s4,a2
    sw s5,20(a1)
    li s7, 0x00000006
    li t4, 0x00000001
    li a4, 0x00000000
    cmov a7,s7,t4,a4
    sw a7,24(a1)
    li a4, 0x00000000
    li t6, 0x00000010
    li t5, 0xcf621d70
    cmov t2,a4,t6,t5
    sw t2,28(a1)
    li t2, 0x00000000
    li s5, 0x009028c2
    li s9, 0x20000000
    cmov s3,t2,s5,s9
    sw s3,32(a1)
    li t3, 0x00000000
    li t0, 0x10000000
    li s2, 0x00020000
    cmov s4,t3,t0,s2
    sw s4,36(a1)
    li s5, 0x00000080
    li s8, 0x6061f39d
    li t3, 0x6061fb9d
    cmov t1,s5,s8,t3
    sw t1,40(a1)
    li t3, 0x000000c0
    li t4, 0x69345248
    li t5, 0x69345348
    cmov s7,t3,t4,t5
    sw s7,44(a1)
    li a3, 0x00000000
    li a4, 0xf232fb4e
    li t1, 0xf25d0cb2
    cmov a0,a3,a4,t1
    sw a0,48(a1)
    li s10, 0x00000000
    li a2, 0xfdf64be6
    li t6, 0xffe44ba6
    cmov a4,s10,a2,t6
    sw a4,52(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 14,4,-1
RV_COMPLIANCE_DATA_END
