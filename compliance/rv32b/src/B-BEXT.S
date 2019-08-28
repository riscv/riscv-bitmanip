#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t6, 0x522a1063
    li s4, 0xd2d6b642
    bext a2,t6,s4
    sw a2,0(a1)
    li a6, 0x8a671b8c
    li t2, 0x5b4289cf
    bext s0,a6,t2
    sw s0,4(a1)
    li s11, 0x02eb0801
    li a3, 0x81920806
    bext s3,s11,a3
    sw s3,8(a1)
    li t6, 0x43737b61
    li a0, 0x57861f11
    bext a3,t6,a0
    sw a3,12(a1)
    li t0, 0xf20d8a82
    li s4, 0x1ceb0c11
    bext s2,t0,s4
    sw s2,16(a1)
    li s10, 0x9543c51a
    li a0, 0x9a48a02c
    bext t4,s10,a0
    sw t4,20(a1)
    li a5, 0x201450ef
    li s3, 0xd603fbf5
    bext a4,a5,s3
    sw a4,24(a1)
    li s2, 0x2f197810
    li a6, 0xc410ffc0
    bext t3,s2,a6
    sw t3,28(a1)
    li a0, 0x4e817b27
    li t4, 0xf50f0000
    bext t5,a0,t4
    sw t5,32(a1)
    li t0, 0x52100032
    li s1, 0x72ff06e1
    bext s3,t0,s1
    sw s3,36(a1)
    li a7, 0x62680100
    li a2, 0x8f089018
    bext s8,a7,a2
    sw s8,40(a1)
    li s5, 0x8005f1fb
    li s1, 0xfff8ff00
    bext s9,s5,s1
    sw s9,44(a1)
    li t4, 0x86931fbf
    li t3, 0xa10d0040
    bext a5,t4,t3
    sw a5,48(a1)
    li a0, 0x8948d029
    li s11, 0x00001800
    bext t4,a0,s11
    sw t4,52(a1)
    li s2, 0x89fd4240
    li s6, 0xff4fffbf
    bext a0,s2,s6
    sw a0,56(a1)
    li t0, 0xbec13108
    li s11, 0x85082aff
    bext t3,t0,s11
    sw t3,60(a1)
    li s11, 0xc0a4c2ad
    li t5, 0xbbb0cf0e
    bext s10,s11,t5
    sw s10,64(a1)
    li t5, 0xc205b002
    li t3, 0xbe0bffd5
    bext t2,t5,t3
    sw t2,68(a1)
    li a3, 0xc6400100
    li s6, 0x1c3fc1ff
    bext t0,a3,s6
    sw t0,72(a1)
    li t1, 0xeb96f4e4
    li s1, 0xe0ffffd3
    bext a5,t1,s1
    sw a5,76(a1)
    li s3, 0xf93cffff
    li t1, 0xd706ffff
    bext s7,s3,t1
    sw s7,80(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 21,4,-1
RV_COMPLIANCE_DATA_END
