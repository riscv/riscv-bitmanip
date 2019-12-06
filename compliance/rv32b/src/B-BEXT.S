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
    li a5, 0x201450ef
    li a2, 0xd603fbf5
    bext s3,a5,a2
    sw s3,24(a1)
    li a0, 0x2f197810
    li t2, 0xc410ffc0
    bext a5,a0,t2
    sw a5,28(a1)
    li t6, 0x3c010000
    li s8, 0xc0e71b2f
    bext a2,t6,s8
    sw a2,32(a1)
    li s8, 0x4e817b27
    li s5, 0xf50f0000
    bext t0,s8,s5
    sw t0,36(a1)
    li s1, 0x52100032
    li s11, 0x72ff06e1
    bext a5,s1,s11
    sw a5,40(a1)
    li s10, 0x62680100
    li a4, 0x8f089018
    bext a5,s10,a4
    sw a5,44(a1)
    li t2, 0x8005f1fb
    li a7, 0xfff8ff00
    bext a4,t2,a7
    sw a4,48(a1)
    li s4, 0x86931fbf
    li a3, 0xa10d0040
    bext t2,s4,a3
    sw t2,52(a1)
    li s3, 0x8948d029
    li t0, 0x00001800
    bext s0,s3,t0
    sw s0,56(a1)
    li s4, 0x89fd4240
    li t0, 0xff4fffbf
    bext s2,s4,t0
    sw s2,60(a1)
    li t2, 0xbec13108
    li a5, 0x85082aff
    bext s10,t2,a5
    sw s10,64(a1)
    li s9, 0xc0a4c2ad
    li a0, 0xbbb0cf0e
    bext t2,s9,a0
    sw t2,68(a1)
    li s9, 0xc205b002
    li t2, 0xbe0bffd5
    bext s0,s9,t2
    sw s0,72(a1)
    li t2, 0xc6400100
    li s8, 0x1c3fc1ff
    bext a4,t2,s8
    sw a4,76(a1)
    li t0, 0xeb96f4e4
    li t2, 0xe0ffffd3
    bext s9,t0,t2
    sw s9,80(a1)
    li s2, 0xf93cffff
    li a5, 0xd706ffff
    bext a3,s2,a5
    sw a3,84(a1)
    sw zero,88(a1)
    sw zero,92(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 24,4,-1
RV_COMPLIANCE_DATA_END
