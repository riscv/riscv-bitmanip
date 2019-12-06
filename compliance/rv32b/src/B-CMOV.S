#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t2, 0x5dd79cfa
    li a0, 0xc4ed4893
    li s9, 0x987a10dd
    cmov s10,t2,a0,s9
    sw s10,0(a1)
    li s1, 0x9c6f7aa2
    li s0, 0xfcae8655
    li t1, 0x02a2826c
    cmov s3,s1,s0,t1
    sw s3,4(a1)
    li t5, 0xa8a22391
    li s6, 0x1b4286dd
    li s4, 0x988c0022
    cmov a7,t5,s6,s4
    sw a7,8(a1)
    li a0, 0x430b3272
    li t4, 0x2b77485c
    li a4, 0x8b8e8f3e
    cmov t5,a0,t4,a4
    sw t5,12(a1)
    li t4, 0xadd85909
    li t3, 0x116023b7
    li s2, 0x29d882a1
    cmov a5,t4,t3,s2
    sw a5,16(a1)
    li s11, 0x00000000
    li t5, 0x2ba53005
    li a0, 0xb208965f
    cmov s10,s11,t5,a0
    sw s10,20(a1)
    li a0, 0x00000000
    li s1, 0x00000010
    li s7, 0xcf621d70
    cmov s6,a0,s1,s7
    sw s6,24(a1)
    li t5, 0x00000000
    li t4, 0x009028c2
    li a5, 0x20000000
    cmov s6,t5,t4,a5
    sw s6,28(a1)
    li a0, 0x00000000
    li s5, 0x10000000
    li s2, 0x00020000
    cmov s3,a0,s5,s2
    sw s3,32(a1)
    li s8, 0x00000000
    li s3, 0xf232fb4e
    li a3, 0xf25d0cb2
    cmov t5,s8,s3,a3
    sw t5,36(a1)
    li a6, 0x00000000
    li s7, 0xfdf64be6
    li a7, 0xffe44ba6
    cmov a3,a6,s7,a7
    sw a3,40(a1)
    li s0, 0x00000006
    li s8, 0x00000001
    li t0, 0x00000000
    cmov t3,s0,s8,t0
    sw t3,44(a1)
    li a4, 0x00000080
    li s4, 0x6061f39d
    li a2, 0x6061fb9d
    cmov t5,a4,s4,a2
    sw t5,48(a1)
    li s4, 0x000000c0
    li a2, 0x69345248
    li t5, 0x69345348
    cmov t3,s4,a2,t5
    sw t3,52(a1)
    li s11, 0x00000100
    li s1, 0x00000002
    li s3, 0x00280000
    cmov s10,s11,s1,s3
    sw s10,56(a1)
    li t4, 0x00020000
    li a5, 0x00000080
    li s2, 0x00800080
    cmov t6,t4,a5,s2
    sw t6,60(a1)
    li s2, 0x031c0eea
    li s3, 0xfbf365be
    li a0, 0x34f67ff6
    cmov t4,s2,s3,a0
    sw t4,64(a1)
    li a2, 0x30000000
    li s5, 0x88012009
    li s8, 0x08012009
    cmov t0,a2,s5,s8
    sw t0,68(a1)
    li s4, 0xb2fb7fb8
    li s1, 0xf174028f
    li s0, 0x6308beaf
    cmov t4,s4,s1,s0
    sw t4,72(a1)
    sw zero,76(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 20,4,-1
RV_COMPLIANCE_DATA_END
