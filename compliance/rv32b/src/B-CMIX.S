#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s9, 0x5dd79cfa
    li t4, 0xc4ed4893
    li s10, 0x987a10dd
    cmix s7,s9,t4,s10
    sw s7,0(a1)
    li s0, 0x9c6f7aa2
    li s4, 0xfcae8655
    li s10, 0x02a2826c
    cmix s2,s0,s4,s10
    sw s2,4(a1)
    li a2, 0xa8a22391
    li s6, 0x1b4286dd
    li s9, 0x988c0022
    cmix a0,a2,s6,s9
    sw a0,8(a1)
    li s2, 0x430b3272
    li a6, 0x2b77485c
    li s6, 0x8b8e8f3e
    cmix t3,s2,a6,s6
    sw t3,12(a1)
    li s5, 0xadd85909
    li s1, 0x116023b7
    li s11, 0x29d882a1
    cmix s9,s5,s1,s11
    sw s9,16(a1)
    li t0, 0x00000000
    li s11, 0x2ba53005
    li s9, 0xb208965f
    cmix t3,t0,s11,s9
    sw t3,20(a1)
    li t2, 0xeb29f6d6
    li a5, 0x0039ff79
    li s11, 0xe8b7098a
    cmix s4,t2,a5,s11
    sw s4,24(a1)
    li s1, 0x2e8e213f
    li t6, 0x0131d6ea
    li t0, 0x00000000
    cmix t2,s1,t6,t0
    sw t2,28(a1)
    li s9, 0x0978be09
    li a3, 0x08800000
    li s5, 0x80010001
    cmix s11,s9,a3,s5
    sw s11,32(a1)
    li t2, 0xb735c043
    li t4, 0x08c83aa0
    li s7, 0x40020082
    cmix s6,t2,t4,s7
    sw s6,36(a1)
    li t4, 0x14b5e101
    li t5, 0x3867b8a7
    li a3, 0x0ff1097e
    cmix s9,t4,t5,a3
    sw s9,40(a1)
    li s3, 0x50002023
    li s7, 0x40000410
    li t0, 0x00000100
    cmix a5,s3,s7,t0
    sw a5,44(a1)
    li t3, 0xa5a832a3
    li t4, 0x68810625
    li a3, 0x288913fb
    cmix s11,t3,t4,a3
    sw s11,48(a1)
    li a0, 0x2d280704
    li a5, 0x8017d9d9
    li a4, 0x12ef4a58
    cmix s4,a0,a5,a4
    sw s4,52(a1)
    li t6, 0x43bda82c
    li t2, 0x87b2a825
    li s1, 0x1ba7f686
    cmix a6,t6,t2,s1
    sw a6,56(a1)
    li s0, 0x0a3b9fe9
    li t3, 0x9288ff06
    li a5, 0x0961b8b5
    cmix s3,s0,t3,a5
    sw s3,60(a1)
    li s6, 0x00090e19
    li s10, 0x92f4b235
    li a2, 0x0103b20e
    cmix s0,s6,s10,a2
    sw s0,64(a1)
    li t1, 0xf8e67357
    li s8, 0x96397276
    li t4, 0x71e40a26
    cmix s9,t1,s8,t4
    sw s9,68(a1)
    li s5, 0x5dd656a2
    li s0, 0xb001085f
    li t1, 0xa9610018
    cmix a6,s5,s0,t1
    sw a6,72(a1)
    li s7, 0xa0ca9fe8
    li a2, 0xca800015
    li a3, 0xac800fe8
    cmix t5,s7,a2,a3
    sw t5,76(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 20,4,-1
RV_COMPLIANCE_DATA_END
