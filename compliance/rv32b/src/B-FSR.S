#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t3, 0x5dd79cfa
    li s10, 0xc4ed4893
    li s1, 0x987a10dd
    fsr a7,t3,s10,s1
    sw a7,0(a1)
    li s7, 0x9c6f7aa2
    li s4, 0xfcae8655
    li a2, 0x02a2826c
    fsr s5,s7,s4,a2
    sw s5,4(a1)
    li s0, 0xa8a22391
    li a6, 0x1b4286dd
    li a5, 0x988c0022
    fsr s2,s0,a6,a5
    sw s2,8(a1)
    li a7, 0x430b3272
    li s5, 0x2b77485c
    li t4, 0x8b8e8f3e
    fsr a3,a7,s5,t4
    sw a3,12(a1)
    li t6, 0xadd85909
    li s5, 0x116023b7
    li a7, 0x29d882a1
    fsr t2,t6,s5,a7
    sw t2,16(a1)
    li t3, 0x00000000
    li t5, 0x2ba53005
    li a0, 0xb208965f
    fsr s2,t3,t5,a0
    sw s2,20(a1)
    li a3, 0x00001bdd
    li a5, 0x14f1c453
    li s7, 0x000edbdd
    fsr s8,a3,a5,s7
    sw s8,24(a1)
    li a7, 0x09ab16a5
    li s5, 0xf5c6039e
    li a2, 0x738e3634
    fsr t0,a7,s5,a2
    sw t0,28(a1)
    li a4, 0x0f8ac084
    li t1, 0x00000623
    li a6, 0xb8000000
    fsr t5,a4,t1,a6
    sw t5,32(a1)
    li a2, 0x17be70ba
    li s11, 0x8880012c
    li s7, 0x80002f7d
    fsr s8,a2,s11,s7
    sw s8,36(a1)
    li t1, 0x2180cfc6
    li s11, 0x932371df
    li s3, 0x69886888
    fsr t6,t1,s11,s3
    sw t6,40(a1)
    li a6, 0x261b1821
    li s1, 0xffbf0206
    li s10, 0x101a3032
    fsr t5,a6,s1,s10
    sw t5,44(a1)
    li s5, 0x4633c5ff
    li t1, 0xa00f0b00
    li t0, 0xb954001f
    fsr a2,s5,t1,t0
    sw a2,48(a1)
    li a0, 0x7d5dfeff
    li s10, 0x00700251
    li s3, 0x2001fc81
    fsr t5,a0,s10,s3
    sw t5,52(a1)
    li s4, 0x7e5c8f54
    li s0, 0x00f27826
    li a4, 0x1ca80024
    fsr s7,s4,s0,a4
    sw s7,56(a1)
    li a5, 0x8227801f
    li a4, 0x0211d0d9
    li s3, 0x5701ab3f
    fsr s2,a5,a4,s3
    sw s2,60(a1)
    li a2, 0x967270fd
    li s10, 0xffffffd6
    li a6, 0x424bc000
    fsr s7,a2,s10,a6
    sw s7,64(a1)
    li t2, 0x9c8002d4
    li s2, 0x0000009b
    li a0, 0xa4860682
    fsr a6,t2,s2,a0
    sw a6,68(a1)
    li t1, 0xb5b1a381
    li s1, 0xb1a6a107
    li a0, 0x8138d3df
    fsr s10,t1,s1,a0
    sw s10,72(a1)
    li s7, 0xbab70ce0
    li a0, 0x5003b62a
    li s9, 0x0296e280
    fsr s8,s7,a0,s9
    sw s8,76(a1)
    li t1, 0xec52b31a
    li s6, 0x48134b70
    li s3, 0xcf036277
    fsr t3,t1,s6,s3
    sw t3,80(a1)
    li s3, 0xf37e1e5f
    li a0, 0xba4e154b
    li t4, 0x0243a888
    fsr s6,s3,a0,t4
    sw s6,84(a1)
    li t3, 0xfb85ff9d
    li a5, 0x00000417
    li t0, 0x7b84fc1d
    fsr s1,t3,a5,t0
    sw s1,88(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 23,4,-1
RV_COMPLIANCE_DATA_END
