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
    li s6, 0x0000000a
    pcnt s0,s6
    sw s0,32(a1)
    li s8, 0x00500002
    pcnt s11,s8
    sw s11,36(a1)
    li s10, 0x01000000
    pcnt a7,s10
    sw a7,40(a1)
    li t5, 0x01960000
    pcnt s9,t5
    sw s9,44(a1)
    li s1, 0x02d80096
    pcnt s10,s1
    sw s10,48(a1)
    li t4, 0x0800000a
    pcnt s2,t4
    sw s2,52(a1)
    li s0, 0x317ff49a
    pcnt s11,s0
    sw s11,56(a1)
    li t6, 0x40800429
    pcnt s9,t6
    sw s9,60(a1)
    li s2, 0x86400000
    pcnt t4,s2
    sw t4,64(a1)
    li s4, 0xc4434000
    pcnt t1,s4
    sw t1,68(a1)
    li t0, 0xcbcd6a07
    pcnt s5,t0
    sw s5,72(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 19,4,-1
RV_COMPLIANCE_DATA_END
