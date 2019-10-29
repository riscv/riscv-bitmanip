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
    li a7, 0x0000000a
    pcnt t5,a7
    sw t5,32(a1)
    li s4, 0x00000011
    pcnt s9,s4
    sw s9,36(a1)
    li t3, 0x00500002
    pcnt a4,t3
    sw a4,40(a1)
    li a7, 0x01000000
    pcnt s5,a7
    sw s5,44(a1)
    li a3, 0x01960000
    pcnt a4,a3
    sw a4,48(a1)
    li s11, 0x02d80096
    pcnt t4,s11
    sw t4,52(a1)
    li s3, 0x05180400
    pcnt s6,s3
    sw s6,56(a1)
    li t0, 0x0800000a
    pcnt s5,t0
    sw s5,60(a1)
    li a0, 0x317ff49a
    pcnt a2,a0
    sw a2,64(a1)
    li t2, 0x40800429
    pcnt s10,t2
    sw s10,68(a1)
    li a4, 0x86400000
    pcnt s9,a4
    sw s9,72(a1)
    li s5, 0xc4434000
    pcnt a7,s5
    sw a7,76(a1)
    li a5, 0xcbcd6a07
    pcnt s4,a5
    sw s4,80(a1)
    li a3, 0xffffebff
    pcnt t3,a3
    sw t3,84(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 22,4,-1
RV_COMPLIANCE_DATA_END
