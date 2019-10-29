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
    li s7, 0x36a9a6d7
    clz s8,s7
    sw s8,12(a1)
    li s4, 0x219954ae
    clz s8,s4
    sw s8,16(a1)
    li s10, 0x91f3a75b
    clz t0,s10
    sw t0,20(a1)
    li t0, 0x6723f89c
    clz s6,t0
    sw s6,24(a1)
    li s1, 0x6042e65d
    clz t5,s1
    sw t5,28(a1)
    li t5, 0x0000000a
    clz s10,t5
    sw s10,32(a1)
    li t2, 0x00000011
    clz s1,t2
    sw s1,36(a1)
    li a4, 0x00500002
    clz t1,a4
    sw t1,40(a1)
    li t6, 0x01000000
    clz t2,t6
    sw t2,44(a1)
    li s5, 0x01960000
    clz t1,s5
    sw t1,48(a1)
    li s4, 0x02d80096
    clz s2,s4
    sw s2,52(a1)
    li t0, 0x05180400
    clz s2,t0
    sw s2,56(a1)
    li a4, 0x0800000a
    clz t1,a4
    sw t1,60(a1)
    li s9, 0x317ff49a
    clz a7,s9
    sw a7,64(a1)
    li s5, 0x40800429
    clz s10,s5
    sw s10,68(a1)
    li a6, 0x86400000
    clz s10,a6
    sw s10,72(a1)
    li s9, 0xc4434000
    clz s10,s9
    sw s10,76(a1)
    li a3, 0xcbcd6a07
    clz t4,a3
    sw t4,80(a1)
    li t5, 0xffffebff
    clz a3,t5
    sw a3,84(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 22,4,-1
RV_COMPLIANCE_DATA_END
