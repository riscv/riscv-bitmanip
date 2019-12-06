#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s2, 0x5dd79cfa
    li t4, 0xc4ed4893
    li s7, 0x987a10dd
    fsr a2,s2,t4,s7
    sw a2,0(a1)
    li t4, 0x9c6f7aa2
    li t5, 0xfcae8655
    li t0, 0x02a2826c
    fsr t3,t4,t5,t0
    sw t3,4(a1)
    li a2, 0xa8a22391
    li a3, 0x1b4286dd
    li s6, 0x988c0022
    fsr a7,a2,a3,s6
    sw a7,8(a1)
    li a5, 0x430b3272
    li s3, 0x2b77485c
    li s7, 0x8b8e8f3e
    fsr a4,a5,s3,s7
    sw a4,12(a1)
    li a7, 0xadd85909
    li a2, 0x116023b7
    li s9, 0x29d882a1
    fsr s8,a7,a2,s9
    sw s8,16(a1)
    li s2, 0x00000000
    li s6, 0x2ba53005
    li s4, 0xb208965f
    fsr a0,s2,s6,s4
    sw a0,20(a1)
    li a7, 0x00001bdd
    li s2, 0x14f1c453
    li s6, 0x000edbdd
    fsr s3,a7,s2,s6
    sw s3,24(a1)
    li s5, 0x09ab16a5
    li a3, 0xf5c6039e
    li a0, 0x738e3634
    fsr a5,s5,a3,a0
    sw a5,28(a1)
    li s11, 0x0f8ac084
    li a3, 0x00000623
    li s9, 0xb8000000
    fsr a4,s11,a3,s9
    sw a4,32(a1)
    li t3, 0x17be70ba
    li a2, 0x8880012c
    li a7, 0x80002f7d
    fsr s0,t3,a2,a7
    sw s0,36(a1)
    li a3, 0x2180cfc6
    li t3, 0x932371df
    li t2, 0x69886888
    fsr a7,a3,t3,t2
    sw a7,40(a1)
    li s10, 0x261b1821
    li t0, 0xffbf0206
    li s0, 0x101a3032
    fsr a0,s10,t0,s0
    sw a0,44(a1)
    li t1, 0x4633c5ff
    li t4, 0xa00f0b00
    li s10, 0xb954001f
    fsr a7,t1,t4,s10
    sw a7,48(a1)
    li a2, 0x7d5dfeff
    li s7, 0x00700251
    li s9, 0x2001fc81
    fsr a5,a2,s7,s9
    sw a5,52(a1)
    li a0, 0x7e5c8f54
    li a7, 0x00f27826
    li t5, 0x1ca80024
    fsr t1,a0,a7,t5
    sw t1,56(a1)
    li t3, 0x8227801f
    li a7, 0x0211d0d9
    li s2, 0x5701ab3f
    fsr s11,t3,a7,s2
    sw s11,60(a1)
    li s5, 0x967270fd
    li t2, 0xffffffd6
    li s3, 0x424bc000
    fsr a3,s5,t2,s3
    sw a3,64(a1)
    li t0, 0x9c8002d4
    li t2, 0x0000009b
    li a2, 0xa4860682
    fsr a7,t0,t2,a2
    sw a7,68(a1)
    li s5, 0xb5b1a381
    li a3, 0xb1a6a107
    li s11, 0x8138d3df
    fsr t5,s5,a3,s11
    sw t5,72(a1)
    li t3, 0xbab70ce0
    li a7, 0x5003b62a
    li t0, 0x0296e280
    fsr s0,t3,a7,t0
    sw s0,76(a1)
    li t5, 0xec52b31a
    li s4, 0x48134b70
    li s10, 0xcf036277
    fsr a5,t5,s4,s10
    sw a5,80(a1)
    li s4, 0xf37e1e5f
    li s9, 0xba4e154b
    li a5, 0x0243a888
    fsr s7,s4,s9,a5
    sw s7,84(a1)
    li a4, 0xfb85ff9d
    li s9, 0x00000417
    li s10, 0x7b84fc1d
    fsr s8,a4,s9,s10
    sw s8,88(a1)
    sw zero,92(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 24,4,-1
RV_COMPLIANCE_DATA_END
