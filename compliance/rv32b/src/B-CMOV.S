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
    li a4, 0x00000000
    li s4, 0x00000010
    li t1, 0xcf621d70
    cmov s9,a4,s4,t1
    sw s9,24(a1)
    li s9, 0x00000000
    li a3, 0x009028c2
    li s5, 0x20000000
    cmov s10,s9,a3,s5
    sw s10,28(a1)
    li t3, 0x00000000
    li a2, 0x10000000
    li s1, 0x00020000
    cmov a3,t3,a2,s1
    sw a3,32(a1)
    li s5, 0x00000000
    li s2, 0xf232fb4e
    li t1, 0xf25d0cb2
    cmov a7,s5,s2,t1
    sw a7,36(a1)
    li a3, 0x00000000
    li s7, 0xfdf64be6
    li a5, 0xffe44ba6
    cmov t4,a3,s7,a5
    sw t4,40(a1)
    li a3, 0x00000006
    li t4, 0x00000001
    li t1, 0x00000000
    cmov s7,a3,t4,t1
    sw s7,44(a1)
    li a5, 0x00000080
    li s6, 0x6061f39d
    li t5, 0x6061fb9d
    cmov s4,a5,s6,t5
    sw s4,48(a1)
    li t5, 0x000000c0
    li s11, 0x69345248
    li t0, 0x69345348
    cmov a3,t5,s11,t0
    sw a3,52(a1)
    li s7, 0x00000100
    li s11, 0x00000002
    li t0, 0x00280000
    cmov a4,s7,s11,t0
    sw a4,56(a1)
    li a3, 0x00020000
    li s0, 0x00000080
    li t2, 0x00800080
    cmov t3,a3,s0,t2
    sw t3,60(a1)
    li s2, 0x031c0eea
    li a0, 0xfbf365be
    li t5, 0x34f67ff6
    cmov s0,s2,a0,t5
    sw s0,64(a1)
    li s1, 0x30000000
    li s2, 0x88012009
    li a2, 0x08012009
    cmov s8,s1,s2,a2
    sw s8,68(a1)
    li s6, 0xb2fb7fb8
    li s8, 0xf174028f
    li a3, 0x6308beaf
    cmov a2,s6,s8,a3
    sw a2,72(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 19,4,-1
RV_COMPLIANCE_DATA_END
