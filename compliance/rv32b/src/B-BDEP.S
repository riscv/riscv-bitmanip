#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a4, 0x522a1063
    li s9, 0xd2d6b642
    bdep t0,a4,s9
    sw t0,0(a1)
    li t1, 0x8a671b8c
    li s10, 0x5b4289cf
    bdep s2,t1,s10
    sw s2,4(a1)
    li a5, 0x02eb0801
    li s7, 0x81920806
    bdep a3,a5,s7
    sw a3,8(a1)
    li s4, 0x43737b61
    li s5, 0x57861f11
    bdep s11,s4,s5
    sw s11,12(a1)
    li s2, 0xf20d8a82
    li a0, 0x1ceb0c11
    bdep s7,s2,a0
    sw s7,16(a1)
    li t2, 0x9543c51a
    li s6, 0x9a48a02c
    bdep s0,t2,s6
    sw s0,20(a1)
    li t2, 0x00c106e0
    li t4, 0x096008f1
    bdep s6,t2,t4
    sw s6,24(a1)
    li t4, 0x0118b98f
    li t5, 0x7f0d5000
    bdep s9,t4,t5
    sw s9,28(a1)
    li s3, 0x02900320
    li s7, 0xe8b8f93a
    bdep a5,s3,s7
    sw a5,32(a1)
    li t3, 0x1474e58c
    li t4, 0xa7833f8c
    bdep s11,t3,t4
    sw s11,36(a1)
    li a0, 0x2e00975c
    li a5, 0xbeffffe9
    bdep s4,a0,a5
    sw s4,40(a1)
    li t6, 0x3198b004
    li t2, 0x3afc39d7
    bdep a6,t6,t2
    sw a6,44(a1)
    li s0, 0x4100a21c
    li t3, 0x4fff9f0d
    bdep s3,s0,t3
    sw s3,48(a1)
    li s6, 0x52418001
    li s10, 0x07ffedee
    bdep s0,s6,s10
    sw s0,52(a1)
    li t1, 0x556eebb3
    li s8, 0xc1ffffff
    bdep s9,t1,s8
    sw s9,56(a1)
    li s5, 0x5dcdf7ff
    li s0, 0x5cd2fff7
    bdep a6,s5,s0
    sw a6,60(a1)
    li s7, 0x65bd8936
    li a2, 0x6d691480
    bdep t5,s7,a2
    sw t5,64(a1)
    li a0, 0x7303a419
    li s1, 0x7303fdd8
    bdep s6,a0,s1
    sw s6,68(a1)
    li t5, 0x81008001
    li t4, 0x885d59ad
    bdep s6,t5,t4
    sw s6,72(a1)
    li a0, 0x819fdb06
    li s5, 0xffffffff
    bdep s3,a0,s5
    sw s3,76(a1)
    li s8, 0x82826344
    li s3, 0xd8fff61d
    bdep t5,s8,s3
    sw t5,80(a1)
    li a6, 0x90044501
    li s7, 0x00efb8ff
    bdep a3,a6,s7
    sw a3,84(a1)
    li s0, 0xa0bc0ecf
    li s8, 0xd3cbfdfe
    bdep t3,s0,s8
    sw t3,88(a1)
    li a4, 0xaf59b587
    li s4, 0x39ff8156
    bdep t5,a4,s4
    sw t5,92(a1)
    li s4, 0xba730f6e
    li a2, 0xfffff06a
    bdep t3,s4,a2
    sw t3,96(a1)
    li s11, 0xbeb30450
    li s1, 0xbbbd38f0
    bdep s10,s11,s1
    sw s10,100(a1)
    li t4, 0xd93f1362
    li a5, 0xd93f15f4
    bdep t6,t4,a5
    sw t6,104(a1)
    li s2, 0xdee2b284
    li s3, 0xfeafffff
    bdep t4,s2,s3
    sw t4,108(a1)
    li a2, 0xe37a0104
    li s5, 0x1d01ffff
    bdep t0,a2,s5
    sw t0,112(a1)
    li s4, 0xebcd54d6
    li s1, 0x0160ffff
    bdep t4,s4,s1
    sw t4,116(a1)
    li a7, 0xfeb971d4
    li a6, 0xb7ffffe7
    bdep s1,a7,a6
    sw s1,120(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 31,4,-1
RV_COMPLIANCE_DATA_END
