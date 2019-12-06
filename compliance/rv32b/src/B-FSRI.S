#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t5, 0x5dd79cfa
    li t3, 0xc4ed4893
    fsri t2,t5,t3,3
    sw t2,0(a1)
    li a3, 0x9c6f7aa2
    li s6, 0xfcae8655
    fsri t0,a3,s6,5
    sw t0,4(a1)
    li t1, 0xa8a22391
    li s1, 0x1b4286dd
    fsri a5,t1,s1,17
    sw a5,8(a1)
    li s3, 0x430b3272
    li t1, 0x2b77485c
    fsri s7,s3,t1,24
    sw s7,12(a1)
    li a3, 0xadd85909
    li s11, 0x116023b7
    fsri s3,a3,s11,25
    sw s3,16(a1)
    li t4, 0x81c0d967
    li s5, 0x2ba53005
    fsri t1,t4,s5,31
    sw t1,20(a1)
    li s7, 0x4227bfff
    li t0, 0x5003b62a
    fsri s9,s7,t0,25
    sw s9,24(a1)
    li t5, 0xe3040043
    li s1, 0x48134b70
    fsri a2,t5,s1,0
    sw a2,28(a1)
    li a5, 0xffffff07
    li s4, 0xba4e154b
    fsri s8,a5,s4,31
    sw s8,32(a1)
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
