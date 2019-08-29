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
    li s6, 0x14f1c453
    li s4, 0x000edbdd
    fsl a2,a0,s6,s4
    sw a2,24(a1)
    li a4, 0x09ab16a5
    li t6, 0xf5c6039e
    li s6, 0x738e3634
    fsl a0,a4,t6,s6
    sw a0,28(a1)
    li s3, 0x0f8ac084
    li s0, 0x00000623
    li a4, 0xb8000000
    fsl s1,s3,s0,a4
    sw s1,32(a1)
    li s2, 0x17be70ba
    li a0, 0x8880012c
    li s7, 0x80002f7d
    fsl t5,s2,a0,s7
    sw t5,36(a1)
    li s6, 0x2180cfc6
    li t0, 0x932371df
    li s3, 0x69886888
    fsl a7,s6,t0,s3
    sw a7,40(a1)
    li s5, 0x261b1821
    li s11, 0xffbf0206
    li a3, 0x101a3032
    fsl a7,s5,s11,a3
    sw a7,44(a1)
    li s7, 0x4633c5ff
    li s2, 0xa00f0b00
    li a7, 0xb954001f
    fsl s5,s7,s2,a7
    sw s5,48(a1)
    li t2, 0x7d5dfeff
    li a2, 0x00700251
    li s1, 0x2001fc81
    fsl t1,t2,a2,s1
    sw t1,52(a1)
    li s7, 0x7e5c8f54
    li t6, 0x00f27826
    li t1, 0x1ca80024
    fsl t3,s7,t6,t1
    sw t3,56(a1)
    li s10, 0x8227801f
    li s11, 0x0211d0d9
    li a6, 0x5701ab3f
    fsl t6,s10,s11,a6
    sw t6,60(a1)
    li s7, 0x967270fd
    li a0, 0xffffffd6
    li s8, 0x424bc000
    fsl a4,s7,a0,s8
    sw a4,64(a1)
    li t2, 0x9c8002d4
    li a0, 0x0000009b
    li a7, 0xa4860682
    fsl t6,t2,a0,a7
    sw t6,68(a1)
    li s4, 0xb5b1a381
    li a5, 0xb1a6a107
    li a3, 0x8138d3df
    fsl s6,s4,a5,a3
    sw s6,72(a1)
    li s1, 0xbab70ce0
    li s2, 0x5003b62a
    li s10, 0x0296e280
    fsl a2,s1,s2,s10
    sw a2,76(a1)
    li a5, 0xec52b31a
    li s6, 0x48134b70
    li t6, 0xcf036277
    fsl s2,a5,s6,t6
    sw s2,80(a1)
    li s6, 0xf37e1e5f
    li a4, 0xba4e154b
    li a6, 0x0243a888
    fsl s11,s6,a4,a6
    sw s11,84(a1)
    li t1, 0xfb85ff9d
    li s6, 0x00000417
    li t3, 0x7b84fc1d
    fsl a2,t1,s6,t3
    sw a2,88(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 23,4,-1
RV_COMPLIANCE_DATA_END
