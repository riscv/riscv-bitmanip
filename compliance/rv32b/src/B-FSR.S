#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s10, 0x5dd79cfa
    li t2, 0xc4ed4893
    li s4, 0x987a10dd
    fsr t1,s10,t2,s4
    sw t1,0(a1)
    li s4, 0x9c6f7aa2
    li a3, 0xfcae8655
    li a0, 0x02a2826c
    fsr t0,s4,a3,a0
    sw t0,4(a1)
    li a6, 0xa8a22391
    li s4, 0x1b4286dd
    li s1, 0x988c0022
    fsr t1,a6,s4,s1
    sw t1,8(a1)
    li a7, 0x430b3272
    li a2, 0x2b77485c
    li t1, 0x8b8e8f3e
    fsr t4,a7,a2,t1
    sw t4,12(a1)
    li a6, 0xadd85909
    li t1, 0x116023b7
    li a0, 0x29d882a1
    fsr s9,a6,t1,a0
    sw s9,16(a1)
    li t2, 0x00000000
    li a0, 0x2ba53005
    li s9, 0xb208965f
    fsr s10,t2,a0,s9
    sw s10,20(a1)
    li t1, 0x00001bdd
    li s1, 0x14f1c453
    li a0, 0x000edbdd
    fsr s10,t1,s1,a0
    sw s10,24(a1)
    li s7, 0x09ab16a5
    li a0, 0xf5c6039e
    li s9, 0x738e3634
    fsr s8,s7,a0,s9
    sw s8,28(a1)
    li t1, 0x0f8ac084
    li s6, 0x00000623
    li s3, 0xb8000000
    fsr t3,t1,s6,s3
    sw t3,32(a1)
    li s3, 0x17be70ba
    li a0, 0x8880012c
    li t4, 0x80002f7d
    fsr s6,s3,a0,t4
    sw s6,36(a1)
    li t3, 0x2180cfc6
    li a5, 0x932371df
    li t0, 0x69886888
    fsr s1,t3,a5,t0
    sw s1,40(a1)
    li s9, 0x261b1821
    li s7, 0xffbf0206
    li s11, 0x101a3032
    fsr a6,s9,s7,s11
    sw a6,44(a1)
    li s4, 0x4633c5ff
    li s5, 0xa00f0b00
    li s9, 0xb954001f
    fsr t0,s4,s5,s9
    sw t0,48(a1)
    li s2, 0x7d5dfeff
    li s8, 0x00700251
    li s4, 0x2001fc81
    fsr t1,s2,s8,s4
    sw t1,52(a1)
    li s11, 0x7e5c8f54
    li t1, 0x00f27826
    li s6, 0x1ca80024
    fsr s4,s11,t1,s6
    sw s4,56(a1)
    li a7, 0x8227801f
    li s2, 0x0211d0d9
    li s6, 0x5701ab3f
    fsr s3,a7,s2,s6
    sw s3,60(a1)
    li s5, 0x967270fd
    li a3, 0xffffffd6
    li a0, 0x424bc000
    fsr a5,s5,a3,a0
    sw a5,64(a1)
    li s11, 0x9c8002d4
    li a3, 0x0000009b
    li s9, 0xa4860682
    fsr a4,s11,a3,s9
    sw a4,68(a1)
    li t3, 0xb5b1a381
    li a2, 0xb1a6a107
    li a7, 0x8138d3df
    fsr s0,t3,a2,a7
    sw s0,72(a1)
    li a3, 0xbab70ce0
    li t3, 0x5003b62a
    li t2, 0x0296e280
    fsr a7,a3,t3,t2
    sw a7,76(a1)
    li s10, 0xec52b31a
    li t0, 0x48134b70
    li s0, 0xcf036277
    fsr a0,s10,t0,s0
    sw a0,80(a1)
    li t1, 0xf37e1e5f
    li t4, 0xba4e154b
    li s10, 0x0243a888
    fsr a7,t1,t4,s10
    sw a7,84(a1)
    li a2, 0xfb85ff9d
    li s7, 0x00000417
    li s9, 0x7b84fc1d
    fsr a5,a2,s7,s9
    sw a5,88(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 23,4,-1
RV_COMPLIANCE_DATA_END
