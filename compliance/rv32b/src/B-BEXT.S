#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t1, 0x522a1063
    li s10, 0xd2d6b642
    bext s2,t1,s10
    sw s2,0(a1)
    li a5, 0x8a671b8c
    li s7, 0x5b4289cf
    bext a3,a5,s7
    sw a3,4(a1)
    li s4, 0x02eb0801
    li s5, 0x81920806
    bext s11,s4,s5
    sw s11,8(a1)
    li s2, 0x43737b61
    li a0, 0x57861f11
    bext s7,s2,a0
    sw s7,12(a1)
    li t2, 0xf20d8a82
    li s6, 0x1ceb0c11
    bext s0,t2,s6
    sw s0,16(a1)
    li t0, 0x9543c51a
    li s7, 0x9a48a02c
    bext s1,t0,s7
    sw s1,20(a1)
    li a6, 0x201450ef
    li t3, 0xd603fbf5
    bext a3,a6,t3
    sw a3,24(a1)
    li t3, 0x2f197810
    li s8, 0xc410ffc0
    bext a6,t3,s8
    sw a6,28(a1)
    li a7, 0x4e817b27
    li s10, 0xf50f0000
    bext t5,a7,s10
    sw t5,32(a1)
    li s6, 0x52100032
    li s3, 0x72ff06e1
    bext t3,s6,s3
    sw t3,36(a1)
    li a3, 0x62680100
    li t3, 0x8f089018
    bext s6,a3,t3
    sw s6,40(a1)
    li t5, 0x8005f1fb
    li s3, 0xfff8ff00
    bext a0,t5,s3
    sw a0,44(a1)
    li s0, 0x86931fbf
    li s6, 0xa10d0040
    bext t1,s0,s6
    sw t1,48(a1)
    li s0, 0x8948d029
    li a4, 0x00001800
    bext a2,s0,a4
    sw a2,52(a1)
    li a6, 0x89fd4240
    li s11, 0xff4fffbf
    bext s6,a6,s11
    sw s6,56(a1)
    li a6, 0xbec13108
    li t2, 0x85082aff
    bext a7,a6,t2
    sw a7,60(a1)
    li a6, 0xc0a4c2ad
    li t4, 0xbbb0cf0e
    bext s1,a6,t4
    sw s1,64(a1)
    li s11, 0xc205b002
    li s2, 0xbe0bffd5
    bext s5,s11,s2
    sw s5,68(a1)
    li t2, 0xc6400100
    li s9, 0x1c3fc1ff
    bext s11,t2,s9
    sw s11,72(a1)
    li t1, 0xeb96f4e4
    li s10, 0xe0ffffd3
    bext a3,t1,s10
    sw a3,76(a1)
    li a3, 0xf93cffff
    li a7, 0xd706ffff
    bext s10,a3,a7
    sw s10,80(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 21,4,-1
RV_COMPLIANCE_DATA_END
