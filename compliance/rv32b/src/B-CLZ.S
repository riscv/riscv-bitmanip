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
    li s9, 0x0000000a
    clz s5,s9
    sw s5,32(a1)
    li a0, 0x00000011
    clz s7,a0
    sw s7,36(a1)
    li t3, 0x00500002
    clz a6,t3
    sw a6,40(a1)
    li s5, 0x01000000
    clz a0,s5
    sw a0,44(a1)
    li s4, 0x01960000
    clz s2,s4
    sw s2,48(a1)
    li a2, 0x02d80096
    clz s1,a2
    sw s1,52(a1)
    li s10, 0x05180400
    clz s8,s10
    sw s8,56(a1)
    li s4, 0x0800000a
    clz a7,s4
    sw a7,60(a1)
    li t5, 0x317ff49a
    clz s10,t5
    sw s10,64(a1)
    li t2, 0x40800429
    clz s1,t2
    sw s1,68(a1)
    li a4, 0x86400000
    clz t1,a4
    sw t1,72(a1)
    li t6, 0xc4434000
    clz t2,t6
    sw t2,76(a1)
    li s5, 0xcbcd6a07
    clz t1,s5
    sw t1,80(a1)
    li s4, 0xffffebff
    clz s2,s4
    sw s2,84(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 22,4,-1
RV_COMPLIANCE_DATA_END
