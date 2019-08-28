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
    li t4, 0x36a9a6d7
    ctz s0,t4
    sw s0,12(a1)
    li s1, 0x219954ae
    ctz t2,s1
    sw t2,16(a1)
    li s4, 0x91f3a75b
    ctz s8,s4
    sw s8,20(a1)
    li s3, 0x6723f89c
    ctz s4,s3
    sw s4,24(a1)
    li s2, 0x6042e65d
    ctz s3,s2
    sw s3,28(a1)
    li t3, 0x0000000a
    ctz a6,t3
    sw a6,32(a1)
    li a3, 0x00500002
    ctz s6,a3
    sw s6,36(a1)
    li s0, 0x01000000
    ctz a2,s0
    sw a2,40(a1)
    li a6, 0x01960000
    ctz s1,a6
    sw s1,44(a1)
    li t1, 0x02d80096
    ctz a3,t1
    sw a3,48(a1)
    li t1, 0x0800000a
    ctz t6,t1
    sw t6,52(a1)
    li s9, 0x317ff49a
    ctz s3,s9
    sw s3,56(a1)
    li s2, 0x40800429
    ctz t1,s2
    sw t1,60(a1)
    li s2, 0x86400000
    ctz a4,s2
    sw a4,64(a1)
    li t6, 0xc4434000
    ctz a2,t6
    sw a2,68(a1)
    li s10, 0xcbcd6a07
    ctz a5,s10
    sw a5,72(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 19,4,-1
RV_COMPLIANCE_DATA_END
