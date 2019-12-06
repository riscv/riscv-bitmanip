#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a6, 0x00000000
    pcnt t1,a6
    sw t1,0(a1)
    li a3, 0xffffffff
    pcnt s8,a3
    sw s8,4(a1)
    li s4, 0xd77b6ecd
    pcnt t3,s4
    sw t3,8(a1)
    li s1, 0x36a9a6d7
    pcnt t2,s1
    sw t2,12(a1)
    li s4, 0x219954ae
    pcnt s10,s4
    sw s10,16(a1)
    li s0, 0x91f3a75b
    pcnt t2,s0
    sw t2,20(a1)
    li a3, 0x6723f89c
    pcnt a7,a3
    sw a7,24(a1)
    li s7, 0x6042e65d
    pcnt s0,s7
    sw s0,28(a1)
    li s3, 0x0000000a
    pcnt s6,s3
    sw s6,32(a1)
    li t0, 0x00000011
    pcnt s5,t0
    sw s5,36(a1)
    li a0, 0x00500002
    pcnt a2,a0
    sw a2,40(a1)
    li t2, 0x01000000
    pcnt s10,t2
    sw s10,44(a1)
    li a4, 0x01960000
    pcnt s9,a4
    sw s9,48(a1)
    li s5, 0x02d80096
    pcnt a7,s5
    sw a7,52(a1)
    li a5, 0x05180400
    pcnt s4,a5
    sw s4,56(a1)
    li a3, 0x0800000a
    pcnt t3,a3
    sw t3,60(a1)
    li s6, 0x317ff49a
    pcnt a2,s6
    sw a2,64(a1)
    li s9, 0x40800429
    pcnt a7,s9
    sw a7,68(a1)
    li s0, 0x86400000
    pcnt s9,s0
    sw s9,72(a1)
    li s8, 0xc4434000
    pcnt s10,s8
    sw s10,76(a1)
    li a5, 0xcbcd6a07
    pcnt s5,a5
    sw s5,80(a1)
    li t2, 0xffffebff
    pcnt s5,t2
    sw s5,84(a1)
    sw zero,88(a1)
    sw zero,92(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 24,4,-1
RV_COMPLIANCE_DATA_END
