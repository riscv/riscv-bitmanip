#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s1, 0x522a1063
    li t4, 0xd2d6b642
    bdep t0,s1,t4
    sw t0,0(a1)
    li a7, 0x8a671b8c
    li s0, 0x5b4289cf
    bdep a6,a7,s0
    sw a6,4(a1)
    li s4, 0x02eb0801
    li t6, 0x81920806
    bdep a0,s4,t6
    sw a0,8(a1)
    li a3, 0x43737b61
    li s11, 0x57861f11
    bdep s9,a3,s11
    sw s9,12(a1)
    li a3, 0xf20d8a82
    li t1, 0x1ceb0c11
    bdep a6,a3,t1
    sw a6,16(a1)
    li s3, 0x9543c51a
    li t5, 0x9a48a02c
    bdep s5,s3,t5
    sw s5,20(a1)
    li a0, 0x00446020
    li s11, 0x800cbfff
    bdep s9,a0,s11
    sw s9,24(a1)
    li a6, 0x00c106e0
    li t3, 0x096008f1
    bdep a3,a6,t3
    sw a3,28(a1)
    li t3, 0x0118b98f
    li s8, 0x7f0d5000
    bdep a6,t3,s8
    sw a6,32(a1)
    li a7, 0x02900320
    li s10, 0xe8b8f93a
    bdep t5,a7,s10
    sw t5,36(a1)
    li s6, 0x0396d751
    li s3, 0xaefc6000
    bdep t3,s6,s3
    sw t3,40(a1)
    li a3, 0x1474e58c
    li t3, 0xa7833f8c
    bdep s6,a3,t3
    sw s6,44(a1)
    li t5, 0x2e00975c
    li s3, 0xbeffffe9
    bdep a0,t5,s3
    sw a0,48(a1)
    li s0, 0x3198b004
    li s6, 0x3afc39d7
    bdep t1,s0,s6
    sw t1,52(a1)
    li s0, 0x4100a21c
    li a4, 0x4fff9f0d
    bdep a2,s0,a4
    sw a2,56(a1)
    li a6, 0x52418001
    li s11, 0x07ffedee
    bdep s6,a6,s11
    sw s6,60(a1)
    li a6, 0x556eebb3
    li t2, 0xc1ffffff
    bdep a7,a6,t2
    sw a7,64(a1)
    li a6, 0x5dcdf7ff
    li t4, 0x5cd2fff7
    bdep s1,a6,t4
    sw s1,68(a1)
    li s11, 0x65bd8936
    li s2, 0x6d691480
    bdep s5,s11,s2
    sw s5,72(a1)
    li t2, 0x7303a419
    li s9, 0x7303fdd8
    bdep s11,t2,s9
    sw s11,76(a1)
    li t1, 0x81008001
    li s10, 0x885d59ad
    bdep a3,t1,s10
    sw a3,80(a1)
    li a3, 0x819fdb06
    li a7, 0xffffffff
    bdep s10,a3,a7
    sw s10,84(a1)
    li s0, 0x82826344
    li t2, 0xd8fff61d
    bdep s6,s0,t2
    sw s6,88(a1)
    li t1, 0x90044501
    li t5, 0x00efb8ff
    bdep t6,t1,t5
    sw t6,92(a1)
    li s1, 0xa0bc0ecf
    li s8, 0xd3cbfdfe
    bdep s2,s1,s8
    sw s2,96(a1)
    li s6, 0xaf59b587
    li t5, 0x39ff8156
    bdep s2,s6,t5
    sw s2,100(a1)
    li s9, 0xba730f6e
    li s11, 0xfffff06a
    bdep s3,s9,s11
    sw s3,104(a1)
    li s0, 0xbeb30450
    li a4, 0xbbbd38f0
    bdep a3,s0,a4
    sw a3,108(a1)
    li s3, 0xd93f1362
    li a7, 0xd93f15f4
    bdep s10,s3,a7
    sw s10,112(a1)
    li s2, 0xdee2b284
    li s5, 0xfeafffff
    bdep t1,s2,s5
    sw t1,116(a1)
    li s6, 0xe37a0104
    li s11, 0x1d01ffff
    bdep s9,s6,s11
    sw s9,120(a1)
    li s7, 0xebcd54d6
    li s8, 0x0160ffff
    bdep a7,s7,s8
    sw a7,124(a1)
    li s2, 0xfeb971d4
    li a7, 0xb7ffffe7
    bdep a4,s2,a7
    sw a4,128(a1)
    sw zero,132(a1)
    sw zero,136(a1)
    sw zero,140(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 36,4,-1
RV_COMPLIANCE_DATA_END
