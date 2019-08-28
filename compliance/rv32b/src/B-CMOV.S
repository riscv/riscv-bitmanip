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
    li t3, 0x00000001
    li a5, 0x00000006
    li t0, 0x00000000
    cmov s8,t3,a5,t0
    sw s8,24(a1)
    li s1, 0x00000010
    li s3, 0x00000000
    li a3, 0xcf621d70
    cmov t1,s1,s3,a3
    sw t1,28(a1)
    li s5, 0x009028c2
    li t3, 0x00000000
    li s0, 0x20000000
    cmov t5,s5,t3,s0
    sw t5,32(a1)
    li t3, 0x10000000
    li a4, 0x00000000
    li s7, 0x00020000
    cmov s3,t3,a4,s7
    sw s3,36(a1)
    li t6, 0x6061f39d
    li s10, 0x00000080
    li s5, 0x6061fb9d
    cmov s7,t6,s10,s5
    sw s7,40(a1)
    li t0, 0x69345248
    li a2, 0x000000c0
    li s6, 0x69345348
    cmov a3,t0,a2,s6
    sw a3,44(a1)
    li a7, 0xf232fb4e
    li t5, 0x00000000
    li t4, 0xf25d0cb2
    cmov t1,a7,t5,t4
    sw t1,48(a1)
    li t1, 0xfdf64be6
    li s11, 0x00000000
    li s2, 0xffe44ba6
    cmov s9,t1,s11,s2
    sw s9,52(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 14,4,-1
RV_COMPLIANCE_DATA_END
