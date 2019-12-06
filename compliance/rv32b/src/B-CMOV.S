#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s8, 0x5dd79cfa
    li s5, 0xc4ed4893
    li t3, 0x987a10dd
    cmov s4,s8,s5,t3
    sw s4,0(a1)
    li t0, 0x9c6f7aa2
    li s8, 0xfcae8655
    li t6, 0x02a2826c
    cmov a5,t0,s8,t6
    sw a5,4(a1)
    li s10, 0xa8a22391
    li s5, 0x1b4286dd
    li a0, 0x988c0022
    cmov a5,s10,s5,a0
    sw a5,8(a1)
    li a7, 0x430b3272
    li a4, 0x2b77485c
    li s8, 0x8b8e8f3e
    cmov t5,a7,a4,s8
    sw t5,12(a1)
    li s2, 0xadd85909
    li t4, 0x116023b7
    li s7, 0x29d882a1
    cmov a2,s2,t4,s7
    sw a2,16(a1)
    li t4, 0x00000000
    li t5, 0x2ba53005
    li t0, 0xb208965f
    cmov t3,t4,t5,t0
    sw t3,20(a1)
    li a5, 0x00000000
    li t3, 0x00000010
    li s11, 0xcf621d70
    cmov s5,a5,t3,s11
    sw s5,24(a1)
    li s11, 0x00000000
    li a4, 0x009028c2
    li s0, 0x20000000
    cmov s1,s11,a4,s0
    sw s1,28(a1)
    li a7, 0x00000000
    li t2, 0x10000000
    li s2, 0x00020000
    cmov s10,a7,t2,s2
    sw s10,32(a1)
    li t2, 0x00000000
    li a4, 0xf232fb4e
    li a5, 0xf25d0cb2
    cmov s5,t2,a4,a5
    sw s5,36(a1)
    li t2, 0x00000000
    li a5, 0xfdf64be6
    li s11, 0xffe44ba6
    cmov s4,t2,a5,s11
    sw s4,40(a1)
    li s1, 0x00000006
    li t6, 0x00000001
    li t0, 0x00000000
    cmov t2,s1,t6,t0
    sw t2,44(a1)
    li s9, 0x00000080
    li a3, 0x6061f39d
    li s5, 0x6061fb9d
    cmov s11,s9,a3,s5
    sw s11,48(a1)
    li t2, 0x000000c0
    li t4, 0x69345248
    li s7, 0x69345348
    cmov s6,t2,t4,s7
    sw s6,52(a1)
    li t4, 0x00000100
    li t5, 0x00000002
    li a3, 0x00280000
    cmov s9,t4,t5,a3
    sw s9,56(a1)
    li s3, 0x00020000
    li s7, 0x00000080
    li t0, 0x00800080
    cmov a5,s3,s7,t0
    sw a5,60(a1)
    li t3, 0x031c0eea
    li t4, 0xfbf365be
    li a3, 0x34f67ff6
    cmov s11,t3,t4,a3
    sw s11,64(a1)
    li a0, 0x30000000
    li a5, 0x88012009
    li a4, 0x08012009
    cmov s4,a0,a5,a4
    sw s4,68(a1)
    li t6, 0xb2fb7fb8
    li t2, 0xf174028f
    li s1, 0x6308beaf
    cmov a6,t6,t2,s1
    sw a6,72(a1)
    sw zero,76(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 20,4,-1
RV_COMPLIANCE_DATA_END
