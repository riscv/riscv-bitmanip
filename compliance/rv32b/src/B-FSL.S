#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t5, 0x5dd79cfa
    li a5, 0xc4ed4893
    li s2, 0x987a10dd
    fsl s11,t5,a5,s2
    sw s11,0(a1)
    li s6, 0x9c6f7aa2
    li t3, 0xfcae8655
    li s11, 0x02a2826c
    fsl s4,s6,t3,s11
    sw s4,4(a1)
    li t6, 0xa8a22391
    li s11, 0x1b4286dd
    li a6, 0x988c0022
    fsl a5,t6,s11,a6
    sw a5,8(a1)
    li a5, 0x430b3272
    li s11, 0x2b77485c
    li a2, 0x8b8e8f3e
    fsl a0,a5,s11,a2
    sw a0,12(a1)
    li s2, 0xadd85909
    li a7, 0x116023b7
    li s7, 0x29d882a1
    fsl s8,s2,a7,s7
    sw s8,16(a1)
    li s9, 0x00000000
    li t4, 0x2ba53005
    li s10, 0xb208965f
    fsl s7,s9,t4,s10
    sw s7,20(a1)
    li a0, 0x00001bdd
    li s5, 0x14f1c453
    li t1, 0x000edbdd
    fsl s2,a0,s5,t1
    sw s2,24(a1)
    li a7, 0x09ab16a5
    li t1, 0xf5c6039e
    li t3, 0x738e3634
    fsl s4,a7,t1,t3
    sw s4,28(a1)
    li t6, 0x0f8ac084
    li s1, 0x00000623
    li s3, 0xb8000000
    fsl t5,t6,s1,s3
    sw t5,32(a1)
    li s8, 0x17be70ba
    li s7, 0x8880012c
    li s10, 0x80002f7d
    fsl t1,s8,s7,s10
    sw t1,36(a1)
    li s2, 0x2180cfc6
    li s0, 0x932371df
    li a0, 0x69886888
    fsl t0,s2,s0,a0
    sw t0,40(a1)
    li s0, 0x261b1821
    li s2, 0xffbf0206
    li s11, 0x101a3032
    fsl s1,s0,s2,s11
    sw s1,44(a1)
    li s9, 0x4633c5ff
    li s4, 0xa00f0b00
    li s6, 0xb954001f
    fsl a3,s9,s4,s6
    sw a3,48(a1)
    li s1, 0x7d5dfeff
    li t4, 0x00700251
    li s2, 0x2001fc81
    fsl a3,s1,t4,s2
    sw a3,52(a1)
    li t6, 0x7e5c8f54
    li t4, 0x00f27826
    li s2, 0x1ca80024
    fsl a6,t6,t4,s2
    sw a6,56(a1)
    li s1, 0x8227801f
    li s4, 0x0211d0d9
    li t6, 0x5701ab3f
    fsl s5,s1,s4,t6
    sw s5,60(a1)
    li s3, 0x967270fd
    li a6, 0xffffffd6
    li s4, 0x424bc000
    fsl a5,s3,a6,s4
    sw a5,64(a1)
    li a7, 0x9c8002d4
    li s0, 0x0000009b
    li t5, 0xa4860682
    fsl s2,a7,s0,t5
    sw s2,68(a1)
    li a5, 0xb5b1a381
    li a0, 0xb1a6a107
    li t2, 0x8138d3df
    fsl t5,a5,a0,t2
    sw t5,72(a1)
    li t4, 0xbab70ce0
    li t1, 0x5003b62a
    li t5, 0x0296e280
    fsl s5,t4,t1,t5
    sw s5,76(a1)
    li s5, 0xec52b31a
    li a0, 0x48134b70
    li s10, 0xcf036277
    fsl t3,s5,a0,s10
    sw t3,80(a1)
    li a3, 0xf37e1e5f
    li s3, 0xba4e154b
    li s9, 0x0243a888
    fsl s4,a3,s3,s9
    sw s4,84(a1)
    li t4, 0xfb85ff9d
    li s4, 0x00000417
    li s3, 0x7b84fc1d
    fsl a5,t4,s4,s3
    sw a5,88(a1)
    sw zero,92(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 24,4,-1
RV_COMPLIANCE_DATA_END
