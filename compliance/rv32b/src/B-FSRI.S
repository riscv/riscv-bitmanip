#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s10, 0x5dd79cfa
    li s4, 0xc4ed4893
    fsri s11,s10,s4,3
    sw s11,0(a1)
    li a2, 0x9c6f7aa2
    li a0, 0xfcae8655
    fsri s1,a2,a0,5
    sw s1,4(a1)
    li a0, 0xa8a22391
    li a3, 0x1b4286dd
    fsri s6,a0,a3,17
    sw s6,8(a1)
    li s0, 0x430b3272
    li a6, 0x2b77485c
    fsri s2,s0,a6,24
    sw s2,12(a1)
    li s11, 0xadd85909
    li t5, 0x116023b7
    fsri a6,s11,t5,25
    sw a6,16(a1)
    li s4, 0x81c0d967
    li a6, 0x2ba53005
    fsri s1,s4,a6,31
    sw s1,20(a1)
    li s7, 0x4227bfff
    li t6, 0xfffffb64
    fsri t3,s7,t6,4
    sw t3,24(a1)
    li s5, 0xe3040043
    li s11, 0xfffffcf9
    fsri t2,s5,s11,25
    sw t2,28(a1)
    li s10, 0xffffff07
    li s11, 0xfffffe63
    fsri t6,s10,s11,3
    sw t6,32(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 9,4,-1
RV_COMPLIANCE_DATA_END
