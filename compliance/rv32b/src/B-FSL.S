#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t2, 0x5dd79cfa
    li t6, 0xc4ed4893
    li s3, 0x987a10dd
    fsl s1,t2,t6,s3
    sw s1,0(a1)
    li a0, 0x9c6f7aa2
    li t1, 0xfcae8655
    li t4, 0x02a2826c
    fsl a6,a0,t1,t4
    sw a6,4(a1)
    li s6, 0xa8a22391
    li a6, 0x1b4286dd
    li t3, 0x988c0022
    fsl a5,s6,a6,t3
    sw a5,8(a1)
    li s7, 0x430b3272
    li s4, 0x2b77485c
    li s3, 0x8b8e8f3e
    fsl s2,s7,s4,s3
    sw s2,12(a1)
    li t0, 0xadd85909
    li s1, 0x116023b7
    li s0, 0x29d882a1
    fsl s3,t0,s1,s0
    sw s3,16(a1)
    li a0, 0x00000000
    li s11, 0x2ba53005
    li s10, 0xb208965f
    fsl t4,a0,s11,s10
    sw t4,20(a1)
    li s1, 0x00001bdd
    li s4, 0x14f1c453
    li t6, 0x000edbdd
    fsl s5,s1,s4,t6
    sw s5,24(a1)
    li s3, 0x09ab16a5
    li a6, 0xf5c6039e
    li s4, 0x738e3634
    fsl a5,s3,a6,s4
    sw a5,28(a1)
    li a7, 0x0f8ac084
    li s0, 0x00000623
    li t5, 0xb8000000
    fsl s2,a7,s0,t5
    sw s2,32(a1)
    li a5, 0x17be70ba
    li a0, 0x8880012c
    li t2, 0x80002f7d
    fsl t5,a5,a0,t2
    sw t5,36(a1)
    li t4, 0x2180cfc6
    li t1, 0x932371df
    li t5, 0x69886888
    fsl s5,t4,t1,t5
    sw s5,40(a1)
    li s5, 0x261b1821
    li a0, 0xffbf0206
    li s10, 0x101a3032
    fsl t3,s5,a0,s10
    sw t3,44(a1)
    li a3, 0x4633c5ff
    li s3, 0xa00f0b00
    li s9, 0xb954001f
    fsl s4,a3,s3,s9
    sw s4,48(a1)
    li t4, 0x7d5dfeff
    li s4, 0x00700251
    li s3, 0x2001fc81
    fsl a5,t4,s4,s3
    sw a5,52(a1)
    li a6, 0x7e5c8f54
    li s3, 0x00f27826
    li a3, 0x1ca80024
    fsl a4,a6,s3,a3
    sw a4,56(a1)
    li t0, 0x8227801f
    li s8, 0x0211d0d9
    li s6, 0x5701ab3f
    fsl a2,t0,s8,s6
    sw a2,60(a1)
    li a7, 0x967270fd
    li t6, 0xffffffd6
    li s0, 0x424bc000
    fsl a0,a7,t6,s0
    sw a0,64(a1)
    li s6, 0x9c8002d4
    li a6, 0x0000009b
    li a3, 0xa4860682
    fsl s11,s6,a6,a3
    sw s11,68(a1)
    li s9, 0xb5b1a381
    li t4, 0xb1a6a107
    li s5, 0x8138d3df
    fsl a0,s9,t4,s5
    sw a0,72(a1)
    li s9, 0xbab70ce0
    li a3, 0x5003b62a
    li s4, 0x0296e280
    fsl s0,s9,a3,s4
    sw s0,76(a1)
    li a6, 0xec52b31a
    li s7, 0x48134b70
    li t6, 0xcf036277
    fsl s5,a6,s7,t6
    sw s5,80(a1)
    li s0, 0xf37e1e5f
    li t2, 0xba4e154b
    li s5, 0x0243a888
    fsl s7,s0,t2,s5
    sw s7,84(a1)
    li s2, 0xfb85ff9d
    li t2, 0x00000417
    li t1, 0x7b84fc1d
    fsl s3,s2,t2,t1
    sw s3,88(a1)
    sw zero,92(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 24,4,-1
RV_COMPLIANCE_DATA_END
