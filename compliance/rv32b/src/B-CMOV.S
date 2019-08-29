#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t6, 0x5dd79cfa
    li s11, 0xc4ed4893
    li a7, 0x987a10dd
    cmov a3,t6,s11,a7
    sw a3,0(a1)
    li a2, 0x9c6f7aa2
    li a0, 0xfcae8655
    li s7, 0x02a2826c
    cmov s1,a2,a0,s7
    sw s1,4(a1)
    li s4, 0xa8a22391
    li a6, 0x1b4286dd
    li s7, 0x988c0022
    cmov s1,s4,a6,s7
    sw s1,8(a1)
    li t2, 0x430b3272
    li t3, 0x2b77485c
    li t0, 0x8b8e8f3e
    cmov s6,t2,t3,t0
    sw s6,12(a1)
    li s2, 0xadd85909
    li s6, 0x116023b7
    li s3, 0x29d882a1
    cmov t1,s2,s6,s3
    sw t1,16(a1)
    li s6, 0x00000000
    li t2, 0x2ba53005
    li s8, 0xb208965f
    cmov t0,s6,t2,s8
    sw t0,20(a1)
    li s5, 0x00000006
    li t1, 0x00000001
    li a6, 0x00000000
    cmov a0,s5,t1,a6
    sw a0,24(a1)
    li a0, 0x00000000
    li t1, 0x00000010
    li s4, 0xcf621d70
    cmov t0,a0,t1,s4
    sw t0,28(a1)
    li a0, 0x00000000
    li t0, 0x009028c2
    li t4, 0x20000000
    cmov t3,a0,t0,t4
    sw t3,32(a1)
    li s4, 0x00000000
    li s10, 0x10000000
    li s6, 0x00020000
    cmov s2,s4,s10,s6
    sw s2,36(a1)
    li s5, 0x00000080
    li s6, 0x6061f39d
    li t2, 0x6061fb9d
    cmov a7,s5,s6,t2
    sw a7,40(a1)
    li s0, 0x000000c0
    li s4, 0x69345248
    li s6, 0x69345348
    cmov t6,s0,s4,s6
    sw t6,44(a1)
    li a2, 0x00000000
    li s10, 0xf232fb4e
    li s2, 0xf25d0cb2
    cmov s1,a2,s10,s2
    sw s1,48(a1)
    li s10, 0x00000000
    li t0, 0xfdf64be6
    li a0, 0xffe44ba6
    cmov s4,s10,t0,a0
    sw s4,52(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 14,4,-1
RV_COMPLIANCE_DATA_END
