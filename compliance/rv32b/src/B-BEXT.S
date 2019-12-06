#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s7, 0x522a1063
    li t4, 0xd2d6b642
    bext a6,s7,t4
    sw a6,0(a1)
    li t6, 0x8a671b8c
    li a4, 0x5b4289cf
    bext t0,t6,a4
    sw t0,4(a1)
    li a6, 0x02eb0801
    li s6, 0x81920806
    bext s9,a6,s6
    sw s9,8(a1)
    li a0, 0x43737b61
    li s9, 0x57861f11
    bext s8,a0,s9
    sw s8,12(a1)
    li s7, 0xf20d8a82
    li a4, 0x1ceb0c11
    bext s11,s7,a4
    sw s11,16(a1)
    li a3, 0x9543c51a
    li s9, 0x9a48a02c
    bext t6,a3,s9
    sw t6,20(a1)
    li s4, 0x201450ef
    li s0, 0xd603fbf5
    bext a3,s4,s0
    sw a3,24(a1)
    li s0, 0x2f197810
    li s1, 0xc410ffc0
    bext s10,s0,s1
    sw s10,28(a1)
    li a0, 0x3c010000
    li s8, 0xc0e71b2f
    bext s10,a0,s8
    sw s10,32(a1)
    li s7, 0x4e817b27
    li t4, 0xf50f0000
    bext a7,s7,t4
    sw a7,36(a1)
    li a4, 0x52100032
    li t6, 0x72ff06e1
    bext t2,a4,t6
    sw t2,40(a1)
    li t2, 0x62680100
    li s5, 0x8f089018
    bext s3,t2,s5
    sw s3,44(a1)
    li t3, 0x8005f1fb
    li t0, 0xfff8ff00
    bext s4,t3,t0
    sw s4,48(a1)
    li s5, 0x86931fbf
    li s8, 0xa10d0040
    bext t1,s5,s8
    sw t1,52(a1)
    li t3, 0x8948d029
    li t4, 0x00001800
    bext s7,t3,t4
    sw s7,56(a1)
    li a3, 0x89fd4240
    li a4, 0xff4fffbf
    bext a0,a3,a4
    sw a0,60(a1)
    li s10, 0xbec13108
    li a2, 0x85082aff
    bext a4,s10,a2
    sw a4,64(a1)
    li s0, 0xc0a4c2ad
    li t4, 0xbbb0cf0e
    bext a2,s0,t4
    sw a2,68(a1)
    li s9, 0xc205b002
    li t1, 0xbe0bffd5
    bext s5,s9,t1
    sw s5,72(a1)
    li t6, 0xc6400100
    li t5, 0x1c3fc1ff
    bext a0,t6,t5
    sw a0,76(a1)
    li a0, 0xeb96f4e4
    li s9, 0xe0ffffd3
    bext a4,a0,s9
    sw a4,80(a1)
    li a0, 0xf93cffff
    li s2, 0xd706ffff
    bext s7,a0,s2
    sw s7,84(a1)
    sw zero,88(a1)
    sw zero,92(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 24,4,-1
RV_COMPLIANCE_DATA_END
