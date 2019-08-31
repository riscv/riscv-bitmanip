#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s1, 0x522a1063
    li t2, 0xd2d6b642
    bdep s0,s1,t2
    sw s0,0(a1)
    li s2, 0x8a671b8c
    li a2, 0x5b4289cf
    bdep s7,s2,a2
    sw s7,4(a1)
    li a0, 0x02eb0801
    li s5, 0x81920806
    bdep s6,a0,s5
    sw s6,8(a1)
    li s3, 0x43737b61
    li s1, 0x57861f11
    bdep a2,s3,s1
    sw a2,12(a1)
    li a0, 0xf20d8a82
    li a6, 0x1ceb0c11
    bdep a5,a0,a6
    sw a5,16(a1)
    li a0, 0x9543c51a
    li t0, 0x9a48a02c
    bdep s7,a0,t0
    sw s7,20(a1)
    li s0, 0x00446020
    li s4, 0x800cbfff
    bdep s2,s0,s4
    sw s2,24(a1)
    li s1, 0x00c106e0
    li s0, 0x096008f1
    bdep s3,s1,s0
    sw s3,28(a1)
    li s6, 0x0118b98f
    li a6, 0x7f0d5000
    bdep a5,s6,a6
    sw a5,32(a1)
    li a2, 0x02900320
    li a3, 0xe8b8f93a
    bdep a7,a2,a3
    sw a7,36(a1)
    li a2, 0x0396d751
    li s6, 0xaefc6000
    bdep a0,a2,s6
    sw a0,40(a1)
    li t5, 0x1474e58c
    li s6, 0xa7833f8c
    bdep a7,t5,s6
    sw a7,44(a1)
    li s7, 0x2e00975c
    li s4, 0xbeffffe9
    bdep s2,s7,s4
    sw s2,48(a1)
    li a5, 0x3198b004
    li s3, 0x3afc39d7
    bdep a4,a5,s3
    sw a4,52(a1)
    li s2, 0x4100a21c
    li a6, 0x4fff9f0d
    bdep t3,s2,a6
    sw t3,56(a1)
    li a0, 0x52418001
    li t4, 0x07ffedee
    bdep t5,a0,t4
    sw t5,60(a1)
    li t0, 0x556eebb3
    li s1, 0xc1ffffff
    bdep s3,t0,s1
    sw s3,64(a1)
    li a7, 0x5dcdf7ff
    li a2, 0x5cd2fff7
    bdep s8,a7,a2
    sw s8,68(a1)
    li s5, 0x65bd8936
    li s1, 0x6d691480
    bdep s9,s5,s1
    sw s9,72(a1)
    li t4, 0x7303a419
    li t3, 0x7303fdd8
    bdep a5,t4,t3
    sw a5,76(a1)
    li a0, 0x81008001
    li s11, 0x885d59ad
    bdep t4,a0,s11
    sw t4,80(a1)
    li s2, 0x819fdb06
    li s6, 0xffffffff
    bdep a0,s2,s6
    sw a0,84(a1)
    li t0, 0x82826344
    li s11, 0xd8fff61d
    bdep t3,t0,s11
    sw t3,88(a1)
    li s11, 0x90044501
    li t5, 0x00efb8ff
    bdep s10,s11,t5
    sw s10,92(a1)
    li t5, 0xa0bc0ecf
    li t3, 0xd3cbfdfe
    bdep t2,t5,t3
    sw t2,96(a1)
    li a3, 0xaf59b587
    li s6, 0x39ff8156
    bdep t0,a3,s6
    sw t0,100(a1)
    li t1, 0xba730f6e
    li s1, 0xfffff06a
    bdep a5,t1,s1
    sw a5,104(a1)
    li s3, 0xbeb30450
    li t1, 0xbbbd38f0
    bdep s7,s3,t1
    sw s7,108(a1)
    li a3, 0xd93f1362
    li s11, 0xd93f15f4
    bdep s3,a3,s11
    sw s3,112(a1)
    li t4, 0xdee2b284
    li s5, 0xfeafffff
    bdep t1,t4,s5
    sw t1,116(a1)
    li a0, 0xe37a0104
    li s11, 0x1d01ffff
    bdep s9,a0,s11
    sw s9,120(a1)
    li a6, 0xebcd54d6
    li t3, 0x0160ffff
    bdep a3,a6,t3
    sw a3,124(a1)
    li t3, 0xfeb971d4
    li s8, 0xb7ffffe7
    bdep a6,t3,s8
    sw a6,128(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 33,4,-1
RV_COMPLIANCE_DATA_END
