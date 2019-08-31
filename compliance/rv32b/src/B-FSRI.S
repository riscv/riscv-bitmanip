#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t5, 0x5dd79cfa
    li a5, 0xc4ed4893
    fsri s11,t5,a5,3
    sw s11,0(a1)
    li s10, 0x9c6f7aa2
    li t2, 0xfcae8655
    fsri t1,s10,t2,5
    sw t1,4(a1)
    li a6, 0xa8a22391
    li t5, 0x1b4286dd
    fsri s4,a6,t5,17
    sw s4,8(a1)
    li s8, 0x430b3272
    li s5, 0x2b77485c
    fsri s4,s8,s5,24
    sw s4,12(a1)
    li s6, 0xadd85909
    li t3, 0x116023b7
    fsri s4,s6,t3,25
    sw s4,16(a1)
    li s4, 0x81c0d967
    li a3, 0x2ba53005
    fsri t0,s4,a3,31
    sw t0,20(a1)
    li s0, 0x4227bfff
    li s2, 0x5003b62a
    fsri s1,s0,s2,25
    sw s1,24(a1)
    li s9, 0xe3040043
    li s7, 0x48134b70
    fsri a6,s9,s7,0
    sw a6,28(a1)
    li s9, 0xffffff07
    li s4, 0xba4e154b
    fsri a3,s9,s4,31
    sw a3,32(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 9,4,-1
RV_COMPLIANCE_DATA_END
