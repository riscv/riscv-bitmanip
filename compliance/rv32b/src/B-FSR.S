#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s0, 0x5dd79cfa
    li a4, 0xc4ed4893
    li a7, 0x987a10dd
    fsr t5,s0,a4,a7
    sw t5,0(a1)
    li a6, 0x9c6f7aa2
    li t0, 0xfcae8655
    li t4, 0x02a2826c
    fsr a0,a6,t0,t4
    sw a0,4(a1)
    li s6, 0xa8a22391
    li s4, 0x1b4286dd
    li s8, 0x988c0022
    fsr t6,s6,s4,s8
    sw t6,8(a1)
    li s2, 0x430b3272
    li s7, 0x2b77485c
    li s0, 0x8b8e8f3e
    fsr a6,s2,s7,s0
    sw a6,12(a1)
    li s7, 0xadd85909
    li s6, 0x116023b7
    li s0, 0x29d882a1
    fsr t1,s7,s6,s0
    sw t1,16(a1)
    li t6, 0x00000000
    li s11, 0x2ba53005
    li a7, 0xb208965f
    fsr a3,t6,s11,a7
    sw a3,20(a1)
    li s9, 0x00001bdd
    li a7, 0x14f1c453
    li t0, 0x000edbdd
    fsr s6,s9,a7,t0
    sw s6,24(a1)
    li a3, 0x09ab16a5
    li s3, 0xf5c6039e
    li t1, 0x738e3634
    fsr a7,a3,s3,t1
    sw a7,28(a1)
    li s7, 0x0f8ac084
    li s0, 0x00000623
    li t1, 0xb8000000
    fsr a4,s7,s0,t1
    sw a4,32(a1)
    li a5, 0x17be70ba
    li s0, 0x8880012c
    li t4, 0x80002f7d
    fsr a7,a5,s0,t4
    sw a7,36(a1)
    li s7, 0x2180cfc6
    li s2, 0x932371df
    li s10, 0x69886888
    fsr a2,s7,s2,s10
    sw a2,40(a1)
    li s10, 0x261b1821
    li s6, 0xffbf0206
    li a5, 0x101a3032
    fsr a7,s10,s6,a5
    sw a7,44(a1)
    li a3, 0x4633c5ff
    li t3, 0xa00f0b00
    li s2, 0xb954001f
    fsr a4,a3,t3,s2
    sw a4,48(a1)
    li t0, 0x7d5dfeff
    li a0, 0x00700251
    li a6, 0x2001fc81
    fsr t5,t0,a0,a6
    sw t5,52(a1)
    li t0, 0x7e5c8f54
    li t2, 0x00f27826
    li a2, 0x1ca80024
    fsr s7,t0,t2,a2
    sw s7,56(a1)
    li s8, 0x8227801f
    li s10, 0x0211d0d9
    li s7, 0x5701ab3f
    fsr t4,s8,s10,s7
    sw t4,60(a1)
    li t4, 0x967270fd
    li t1, 0xffffffd6
    li s1, 0x424bc000
    fsr a6,t4,t1,s1
    sw a6,64(a1)
    li s10, 0x9c8002d4
    li t0, 0x0000009b
    li s3, 0xa4860682
    fsr s2,s10,t0,s3
    sw s2,68(a1)
    li t3, 0xb5b1a381
    li t1, 0xb1a6a107
    li t0, 0x8138d3df
    fsr s11,t3,t1,t0
    sw s11,72(a1)
    li t0, 0xbab70ce0
    li t6, 0x5003b62a
    li s0, 0x0296e280
    fsr t4,t0,t6,s0
    sw t4,76(a1)
    li s0, 0xec52b31a
    li s8, 0x48134b70
    li t1, 0xcf036277
    fsr s6,s0,s8,t1
    sw s6,80(a1)
    li s1, 0xf37e1e5f
    li s10, 0xba4e154b
    li a2, 0x0243a888
    fsr a4,s1,s10,a2
    sw a4,84(a1)
    li s0, 0xfb85ff9d
    li s11, 0x00000417
    li s9, 0x7b84fc1d
    fsr s5,s0,s11,s9
    sw s5,88(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 23,4,-1
RV_COMPLIANCE_DATA_END
