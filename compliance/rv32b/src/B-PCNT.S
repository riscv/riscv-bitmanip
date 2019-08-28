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
    li s7, 0x36a9a6d7
    pcnt s8,s7
    sw s8,12(a1)
    li s10, 0x219954ae
    pcnt t3,s10
    sw t3,16(a1)
    li t2, 0x91f3a75b
    pcnt s6,t2
    sw s6,20(a1)
    li a4, 0x6723f89c
    pcnt s5,a4
    sw s5,24(a1)
    li s0, 0x6042e65d
    pcnt t2,s0
    sw t2,28(a1)
    li a7, 0x0000000a
    pcnt t5,a7
    sw t5,32(a1)
    li t5, 0x00500002
    pcnt a0,t5
    sw a0,36(a1)
    li a6, 0x01000000
    pcnt s6,a6
    sw s6,40(a1)
    li s11, 0x01960000
    pcnt s5,s11
    sw s5,44(a1)
    li a3, 0x02d80096
    pcnt s10,a3
    sw s10,48(a1)
    li s1, 0x0800000a
    pcnt s2,s1
    sw s2,52(a1)
    li s0, 0x317ff49a
    pcnt a3,s0
    sw a3,56(a1)
    li s6, 0x40800429
    pcnt s9,s6
    sw s9,60(a1)
    li a5, 0x86400000
    pcnt s3,a5
    sw s3,64(a1)
    li s8, 0xc4434000
    pcnt t0,s8
    sw t0,68(a1)
    li t2, 0xcbcd6a07
    pcnt a4,t2
    sw a4,72(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 19,4,-1
RV_COMPLIANCE_DATA_END
