#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a4, 0x5dd79cfa
    li a7, 0xc4ed4893
    li s0, 0x987a10dd
    fsl t6,a4,a7,s0
    sw t6,0(a1)
    li s2, 0x9c6f7aa2
    li s0, 0xfcae8655
    li t4, 0x02a2826c
    fsl t5,s2,s0,t4
    sw t5,4(a1)
    li a0, 0xa8a22391
    li a3, 0x1b4286dd
    li t0, 0x988c0022
    fsl s6,a0,a3,t0
    sw s6,8(a1)
    li t6, 0x430b3272
    li s6, 0x2b77485c
    li a4, 0x8b8e8f3e
    fsl s5,t6,s6,a4
    sw s5,12(a1)
    li s11, 0xadd85909
    li t0, 0x116023b7
    li a7, 0x29d882a1
    fsl s5,s11,t0,a7
    sw s5,16(a1)
    li s1, 0x00000000
    li s3, 0x2ba53005
    li s8, 0xb208965f
    fsl t3,s1,s3,s8
    sw t3,20(a1)
    li a0, 0x00001bdd
    li t2, 0x14f1c453
    li s9, 0x000edbdd
    fsl t6,a0,t2,s9
    sw t6,24(a1)
    li a0, 0x09ab16a5
    li s3, 0xf5c6039e
    li s2, 0x738e3634
    fsl t3,a0,s3,s2
    sw t3,28(a1)
    li t3, 0x0f8ac084
    li a3, 0x00000623
    li a4, 0xb8000000
    fsl s8,t3,a3,a4
    sw s8,32(a1)
    li s11, 0x17be70ba
    li s7, 0x8880012c
    li a0, 0x80002f7d
    fsl s9,s11,s7,a0
    sw s9,36(a1)
    li a0, 0x2180cfc6
    li t6, 0x932371df
    li s0, 0x69886888
    fsl s9,a0,t6,s0
    sw s9,40(a1)
    li s1, 0x261b1821
    li t3, 0xffbf0206
    li a3, 0x101a3032
    fsl t4,s1,t3,a3
    sw t4,44(a1)
    li s6, 0x4633c5ff
    li a6, 0xa00f0b00
    li a4, 0xb954001f
    fsl s7,s6,a6,a4
    sw s7,48(a1)
    li s5, 0x7d5dfeff
    li t6, 0x00700251
    li a2, 0x2001fc81
    fsl a7,s5,t6,a2
    sw a7,52(a1)
    li s7, 0x7e5c8f54
    li s4, 0x00f27826
    li s8, 0x1ca80024
    fsl t1,s7,s4,s8
    sw t1,56(a1)
    li t1, 0x8227801f
    li t3, 0x0211d0d9
    li a5, 0x5701ab3f
    fsl s0,t1,t3,a5
    sw s0,60(a1)
    li s1, 0x967270fd
    li t5, 0xffffffd6
    li s10, 0x424bc000
    fsl s2,s1,t5,s10
    sw s2,64(a1)
    li t6, 0x9c8002d4
    li t5, 0x0000009b
    li s0, 0xa4860682
    fsl s8,t6,t5,s0
    sw s8,68(a1)
    li a0, 0xb5b1a381
    li s5, 0xb1a6a107
    li t1, 0x8138d3df
    fsl s2,a0,s5,t1
    sw s2,72(a1)
    li a7, 0xbab70ce0
    li t1, 0x5003b62a
    li t3, 0x0296e280
    fsl s4,a7,t1,t3
    sw s4,76(a1)
    li t6, 0xec52b31a
    li s1, 0x48134b70
    li s3, 0xcf036277
    fsl t5,t6,s1,s3
    sw t5,80(a1)
    li s8, 0xf37e1e5f
    li s7, 0xba4e154b
    li s10, 0x0243a888
    fsl t1,s8,s7,s10
    sw t1,84(a1)
    li s2, 0xfb85ff9d
    li s0, 0x00000417
    li a0, 0x7b84fc1d
    fsl t0,s2,s0,a0
    sw t0,88(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 23,4,-1
RV_COMPLIANCE_DATA_END
