#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s9, 0x5dd79cfa
    li a4, 0xc4ed4893
    li a2, 0x987a10dd
    fsl t1,s9,a4,a2
    sw t1,0(a1)
    li s0, 0x9c6f7aa2
    li a0, 0xfcae8655
    li t5, 0x02a2826c
    fsl a3,s0,a0,t5
    sw a3,4(a1)
    li s4, 0xa8a22391
    li a5, 0x1b4286dd
    li t2, 0x988c0022
    fsl s3,s4,a5,t2
    sw s3,8(a1)
    li a4, 0x430b3272
    li s2, 0x2b77485c
    li t0, 0x8b8e8f3e
    fsl a3,a4,s2,t0
    sw a3,12(a1)
    li s6, 0xadd85909
    li t1, 0x116023b7
    li a5, 0x29d882a1
    fsl s9,s6,t1,a5
    sw s9,16(a1)
    li s5, 0x00000000
    li a2, 0x2ba53005
    li s7, 0xb208965f
    fsl a5,s5,a2,s7
    sw a5,20(a1)
    li t0, 0x00001bdd
    li s6, 0x14f1c453
    li s3, 0x000edbdd
    fsl s5,t0,s6,s3
    sw s5,24(a1)
    li t3, 0x09ab16a5
    li s5, 0xf5c6039e
    li s8, 0x738e3634
    fsl s2,t3,s5,s8
    sw s2,28(a1)
    li t5, 0x0f8ac084
    li s5, 0x00000623
    li t0, 0xb8000000
    fsl a6,t5,s5,t0
    sw a6,32(a1)
    li t2, 0x17be70ba
    li s8, 0x8880012c
    li s1, 0x80002f7d
    fsl s3,t2,s8,s1
    sw s3,36(a1)
    li s6, 0x2180cfc6
    li s0, 0x932371df
    li s8, 0x69886888
    fsl a6,s6,s0,s8
    sw a6,40(a1)
    li t5, 0x261b1821
    li t2, 0xffbf0206
    li s3, 0x101a3032
    fsl s6,t5,t2,s3
    sw s6,44(a1)
    li s10, 0x4633c5ff
    li a5, 0xa00f0b00
    li a6, 0xb954001f
    fsl s6,s10,a5,a6
    sw s6,48(a1)
    li s6, 0x7d5dfeff
    li s4, 0x00700251
    li t3, 0x2001fc81
    fsl s5,s6,s4,t3
    sw s5,52(a1)
    li s6, 0x7e5c8f54
    li a4, 0x00f27826
    li t2, 0x1ca80024
    fsl a2,s6,a4,t2
    sw a2,56(a1)
    li a0, 0x8227801f
    li s6, 0x0211d0d9
    li s4, 0x5701ab3f
    fsl a2,a0,s6,s4
    sw a2,60(a1)
    li a4, 0x967270fd
    li t6, 0xffffffd6
    li s6, 0x424bc000
    fsl a0,a4,t6,s6
    sw a0,64(a1)
    li s3, 0x9c8002d4
    li s0, 0x0000009b
    li a4, 0xa4860682
    fsl s1,s3,s0,a4
    sw s1,68(a1)
    li s2, 0xb5b1a381
    li a0, 0xb1a6a107
    li s7, 0x8138d3df
    fsl t5,s2,a0,s7
    sw t5,72(a1)
    li s6, 0xbab70ce0
    li t0, 0x5003b62a
    li s3, 0x0296e280
    fsl a7,s6,t0,s3
    sw a7,76(a1)
    li s5, 0xec52b31a
    li s11, 0x48134b70
    li a3, 0xcf036277
    fsl a7,s5,s11,a3
    sw a7,80(a1)
    li s7, 0xf37e1e5f
    li s2, 0xba4e154b
    li a7, 0x0243a888
    fsl s5,s7,s2,a7
    sw s5,84(a1)
    li t2, 0xfb85ff9d
    li a2, 0x00000417
    li s1, 0x7b84fc1d
    fsl t1,t2,a2,s1
    sw t1,88(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 23,4,-1
RV_COMPLIANCE_DATA_END
