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
    li t4, 0x00c106e0
    li s7, 0x096008f1
    bdep a0,t4,s7
    sw a0,24(a1)
    li t0, 0x0118b98f
    li s8, 0x7f0d5000
    bdep a5,t0,s8
    sw a5,28(a1)
    li t6, 0x02900320
    li s11, 0xe8b8f93a
    bdep a5,t6,s11
    sw a5,32(a1)
    li a6, 0x1474e58c
    li s4, 0xa7833f8c
    bdep t1,a6,s4
    sw t1,36(a1)
    li s11, 0x2e00975c
    li s10, 0xbeffffe9
    bdep a3,s11,s10
    sw a3,40(a1)
    li s10, 0x3198b004
    li s5, 0x3afc39d7
    bdep a5,s10,s5
    sw a5,44(a1)
    li a5, 0x4100a21c
    li s11, 0x4fff9f0d
    bdep a0,a5,s11
    sw a0,48(a1)
    li a7, 0x52418001
    li a2, 0x07ffedee
    bdep t4,a7,a2
    sw t4,52(a1)
    li s10, 0x556eebb3
    li a2, 0xc1ffffff
    bdep s7,s10,a2
    sw s7,56(a1)
    li a7, 0x5dcdf7ff
    li a4, 0x5cd2fff7
    bdep t5,a7,a4
    sw t5,60(a1)
    li s2, 0x65bd8936
    li a7, 0x6d691480
    bdep s8,s2,a7
    sw s8,64(a1)
    li a6, 0x7303a419
    li t1, 0x7303fdd8
    bdep s9,a6,t1
    sw s9,68(a1)
    li t2, 0x81008001
    li t6, 0x885d59ad
    bdep s1,t2,t6
    sw s1,72(a1)
    li s2, 0x819fdb06
    li t4, 0xffffffff
    bdep a2,s2,t4
    sw a2,76(a1)
    li s9, 0x82826344
    li t4, 0xd8fff61d
    bdep s7,s9,t4
    sw s7,80(a1)
    li t2, 0x90044501
    li a0, 0x00efb8ff
    bdep s10,t2,a0
    sw s10,84(a1)
    li a0, 0xa0bc0ecf
    li t1, 0xd3cbfdfe
    bdep a6,a0,t1
    sw a6,88(a1)
    li t4, 0xaf59b587
    li t5, 0x39ff8156
    bdep t3,t4,t5
    sw t3,92(a1)
    li s0, 0xba730f6e
    li s4, 0xfffff06a
    bdep s2,s0,s4
    sw s2,96(a1)
    li s1, 0xbeb30450
    li s0, 0xbbbd38f0
    bdep s3,s1,s0
    sw s3,100(a1)
    li s6, 0xd93f1362
    li a6, 0xd93f15f4
    bdep a5,s6,a6
    sw a5,104(a1)
    li a2, 0xdee2b284
    li a3, 0xfeafffff
    bdep a7,a2,a3
    sw a7,108(a1)
    li a2, 0xe37a0104
    li s6, 0x1d01ffff
    bdep a0,a2,s6
    sw a0,112(a1)
    li t5, 0xebcd54d6
    li s6, 0x0160ffff
    bdep a7,t5,s6
    sw a7,116(a1)
    li s7, 0xfeb971d4
    li s4, 0xb7ffffe7
    bdep s2,s7,s4
    sw s2,120(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 31,4,-1
RV_COMPLIANCE_DATA_END
