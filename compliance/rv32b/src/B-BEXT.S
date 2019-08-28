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
    li a0, 0x201450ef
    li s9, 0xd603fbf5
    bext a7,a0,s9
    sw a7,24(a1)
    li s9, 0x2f197810
    li s3, 0xc410ffc0
    bext a4,s9,s3
    sw a4,28(a1)
    li t0, 0x4e817b27
    li t6, 0xf50f0000
    bext s0,t0,t6
    sw s0,32(a1)
    li a5, 0x52100032
    li t1, 0x72ff06e1
    bext a7,a5,t1
    sw a7,36(a1)
    li a6, 0x62680100
    li s11, 0x8f089018
    bext a3,a6,s11
    sw a3,40(a1)
    li s10, 0x8005f1fb
    li s11, 0xfff8ff00
    bext s4,s10,s11
    sw s4,44(a1)
    li t2, 0x86931fbf
    li a6, 0xa10d0040
    bext t1,t2,a6
    sw t1,48(a1)
    li t5, 0x8948d029
    li s7, 0x00001800
    bext s11,t5,s7
    sw s11,52(a1)
    li s5, 0x89fd4240
    li t1, 0xff4fffbf
    bext a4,s5,t1
    sw a4,56(a1)
    li s7, 0xbec13108
    li s9, 0x85082aff
    bext s5,s7,s9
    sw s5,60(a1)
    li a2, 0xc0a4c2ad
    li a7, 0xbbb0cf0e
    bext s4,a2,a7
    sw s4,64(a1)
    li s5, 0xc205b002
    li s11, 0xbe0bffd5
    bext t0,s5,s11
    sw t0,68(a1)
    li s9, 0xc6400100
    li a3, 0x1c3fc1ff
    bext t3,s9,a3
    sw t3,72(a1)
    li t2, 0xeb96f4e4
    li a7, 0xe0ffffd3
    bext s1,t2,a7
    sw s1,76(a1)
    li t0, 0xf93cffff
    li s6, 0xd706ffff
    bext a3,t0,s6
    sw a3,80(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 21,4,-1
RV_COMPLIANCE_DATA_END
