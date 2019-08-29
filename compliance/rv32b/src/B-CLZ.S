#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s2, 0x00000000
    clz s7,s2
    sw s7,0(a1)
    li s3, 0xffffffff
    clz s0,s3
    sw s0,4(a1)
    li t6, 0xd77b6ecd
    clz s5,t6
    sw s5,8(a1)
    li s11, 0x36a9a6d7
    clz a4,s11
    sw a4,12(a1)
    li s3, 0x219954ae
    clz t3,s3
    sw t3,16(a1)
    li s3, 0x91f3a75b
    clz s11,s3
    sw s11,20(a1)
    li s4, 0x6723f89c
    clz s10,s4
    sw s10,24(a1)
    li s10, 0x6042e65d
    clz t0,s10
    sw t0,28(a1)
    li s6, 0x0000000a
    clz s2,s6
    sw s2,32(a1)
    li s3, 0x00500002
    clz s10,s3
    sw s10,36(a1)
    li s7, 0x01000000
    clz a7,s7
    sw a7,40(a1)
    li a0, 0x01960000
    clz a5,a0
    sw a5,44(a1)
    li s1, 0x02d80096
    clz a5,s1
    sw a5,48(a1)
    li s4, 0x0800000a
    clz t2,s4
    sw t2,52(a1)
    li t2, 0x317ff49a
    clz s10,t2
    sw s10,56(a1)
    li t2, 0x40800429
    clz a4,t2
    sw a4,60(a1)
    li s8, 0x86400000
    clz a3,s8
    sw a3,64(a1)
    li s0, 0xc4434000
    clz s10,s0
    sw s10,68(a1)
    li a4, 0xcbcd6a07
    clz t2,a4
    sw t2,72(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 19,4,-1
RV_COMPLIANCE_DATA_END
