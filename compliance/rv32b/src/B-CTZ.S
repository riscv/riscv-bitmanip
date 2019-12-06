#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a7, 0x00000000
    ctz s11,a7
    sw s11,0(a1)
    li s6, 0xffffffff
    ctz t5,s6
    sw t5,4(a1)
    li s4, 0xd77b6ecd
    ctz t6,s4
    sw t6,8(a1)
    li s3, 0x36a9a6d7
    ctz t3,s3
    sw t3,12(a1)
    li t2, 0x219954ae
    ctz s6,t2
    sw s6,16(a1)
    li s2, 0x91f3a75b
    ctz s3,s2
    sw s3,20(a1)
    li a6, 0x6723f89c
    ctz s0,a6
    sw s0,24(a1)
    li t5, 0x6042e65d
    ctz t6,t5
    sw t6,28(a1)
    li t2, 0x0000000a
    ctz a2,t2
    sw a2,32(a1)
    li a3, 0x00000011
    ctz t3,a3
    sw t3,36(a1)
    li t1, 0x00500002
    ctz a0,t1
    sw a0,40(a1)
    li a4, 0x01000000
    ctz s3,a4
    sw s3,44(a1)
    li t3, 0x01960000
    ctz a4,t3
    sw a4,48(a1)
    li t3, 0x02d80096
    ctz a3,t3
    sw a3,52(a1)
    li a3, 0x05180400
    ctz s7,a3
    sw s7,56(a1)
    li s7, 0x0800000a
    ctz a4,s7
    sw a4,60(a1)
    li s1, 0x317ff49a
    ctz s8,s1
    sw s8,64(a1)
    li s2, 0x40800429
    ctz t6,s2
    sw t6,68(a1)
    li s4, 0x86400000
    ctz t4,s4
    sw t4,72(a1)
    li t3, 0xc4434000
    ctz s10,t3
    sw s10,76(a1)
    li s7, 0xcbcd6a07
    ctz t0,s7
    sw t0,80(a1)
    li a7, 0xffffebff
    ctz s10,a7
    sw s10,84(a1)
    sw zero,88(a1)
    sw zero,92(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 24,4,-1
RV_COMPLIANCE_DATA_END
