#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s0, 0x5dd79cfa
    li s4, 0xc4ed4893
    fsri s2,s0,s4,3
    sw s2,0(a1)
    li s1, 0x9c6f7aa2
    li s0, 0xfcae8655
    fsri s3,s1,s0,5
    sw s3,4(a1)
    li s6, 0xa8a22391
    li a6, 0x1b4286dd
    fsri a5,s6,a6,17
    sw a5,8(a1)
    li a2, 0x430b3272
    li a3, 0x2b77485c
    fsri a7,a2,a3,24
    sw a7,12(a1)
    li a2, 0xadd85909
    li s6, 0x116023b7
    fsri a0,a2,s6,25
    sw a0,16(a1)
    li t5, 0x81c0d967
    li s6, 0x2ba53005
    fsri a7,t5,s6,31
    sw a7,20(a1)
    li a6, 0x4227bfff
    li s3, 0x5003b62a
    fsri a4,a6,s3,25
    sw a4,24(a1)
    li a0, 0xe3040043
    li a7, 0x48134b70
    fsri t1,a0,a7,0
    sw t1,28(a1)
    li t0, 0xffffff07
    li s8, 0xba4e154b
    fsri a2,t0,s8,31
    sw a2,32(a1)
    sw zero,36(a1)
    sw zero,40(a1)
    sw zero,44(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 12,4,-1
RV_COMPLIANCE_DATA_END
