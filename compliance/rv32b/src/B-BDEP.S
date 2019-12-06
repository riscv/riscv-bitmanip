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
    li s1, 0x00446020
    li s8, 0x800cbfff
    bdep s2,s1,s8
    sw s2,24(a1)
    li s6, 0x00c106e0
    li t5, 0x096008f1
    bdep s2,s6,t5
    sw s2,28(a1)
    li s9, 0x0118b98f
    li s11, 0x7f0d5000
    bdep s3,s9,s11
    sw s3,32(a1)
    li s0, 0x02900320
    li a4, 0xe8b8f93a
    bdep a3,s0,a4
    sw a3,36(a1)
    li s3, 0x0396d751
    li a7, 0xaefc6000
    bdep s10,s3,a7
    sw s10,40(a1)
    li s2, 0x1474e58c
    li s5, 0xa7833f8c
    bdep t1,s2,s5
    sw t1,44(a1)
    li s6, 0x2e00975c
    li s11, 0xbeffffe9
    bdep s9,s6,s11
    sw s9,48(a1)
    li s7, 0x3198b004
    li s8, 0x3afc39d7
    bdep a7,s7,s8
    sw a7,52(a1)
    li s2, 0x4100a21c
    li a7, 0x4fff9f0d
    bdep a4,s2,a7
    sw a4,56(a1)
    li a5, 0x52418001
    li a2, 0x07ffedee
    bdep s3,a5,a2
    sw s3,60(a1)
    li a0, 0x556eebb3
    li t2, 0xc1ffffff
    bdep a5,a0,t2
    sw a5,64(a1)
    li t6, 0x5dcdf7ff
    li s8, 0x5cd2fff7
    bdep a2,t6,s8
    sw a2,68(a1)
    li s8, 0x65bd8936
    li s5, 0x6d691480
    bdep t0,s8,s5
    sw t0,72(a1)
    li s1, 0x7303a419
    li s11, 0x7303fdd8
    bdep a5,s1,s11
    sw a5,76(a1)
    li s10, 0x81008001
    li a4, 0x885d59ad
    bdep a5,s10,a4
    sw a5,80(a1)
    li t2, 0x819fdb06
    li a7, 0xffffffff
    bdep a4,t2,a7
    sw a4,84(a1)
    li s4, 0x82826344
    li a3, 0xd8fff61d
    bdep t2,s4,a3
    sw t2,88(a1)
    li s3, 0x90044501
    li t0, 0x00efb8ff
    bdep s0,s3,t0
    sw s0,92(a1)
    li s4, 0xa0bc0ecf
    li t0, 0xd3cbfdfe
    bdep s2,s4,t0
    sw s2,96(a1)
    li t2, 0xaf59b587
    li a5, 0x39ff8156
    bdep s10,t2,a5
    sw s10,100(a1)
    li s9, 0xba730f6e
    li a0, 0xfffff06a
    bdep t2,s9,a0
    sw t2,104(a1)
    li s9, 0xbeb30450
    li t2, 0xbbbd38f0
    bdep s0,s9,t2
    sw s0,108(a1)
    li t2, 0xd93f1362
    li s8, 0xd93f15f4
    bdep a4,t2,s8
    sw a4,112(a1)
    li t0, 0xdee2b284
    li t2, 0xfeafffff
    bdep s9,t0,t2
    sw s9,116(a1)
    li s2, 0xe37a0104
    li a5, 0x1d01ffff
    bdep a3,s2,a5
    sw a3,120(a1)
    li s8, 0xebcd54d6
    li a7, 0x0160ffff
    bdep a3,s8,a7
    sw a3,124(a1)
    li s7, 0xfeb971d4
    li s6, 0xb7ffffe7
    bdep a7,s7,s6
    sw a7,128(a1)
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
