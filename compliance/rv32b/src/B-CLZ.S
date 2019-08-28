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
    li a3, 0x0000000a
    clz a6,a3
    sw a6,32(a1)
    li a3, 0x00500002
    clz s5,a3
    sw s5,36(a1)
    li a2, 0x01000000
    clz s4,a2
    sw s4,40(a1)
    li s11, 0x01960000
    clz t4,s11
    sw t4,44(a1)
    li s10, 0x02d80096
    clz s0,s10
    sw s0,48(a1)
    li s5, 0x0800000a
    clz a0,s5
    sw a0,52(a1)
    li a4, 0x317ff49a
    clz s11,a4
    sw s11,56(a1)
    li a3, 0x40800429
    clz s3,a3
    sw s3,60(a1)
    li s9, 0x86400000
    clz a2,s9
    sw a2,64(a1)
    li s4, 0xc4434000
    clz t5,s4
    sw t5,68(a1)
    li a6, 0xcbcd6a07
    clz a0,a6
    sw a0,72(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 19,4,-1
RV_COMPLIANCE_DATA_END
