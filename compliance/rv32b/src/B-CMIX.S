#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s5, 0x5dd79cfa
    li a2, 0xc4ed4893
    li s7, 0x987a10dd
    cmix a5,s5,a2,s7
    sw a5,0(a1)
    li s10, 0x9c6f7aa2
    li s4, 0xfcae8655
    li t6, 0x02a2826c
    cmix s11,s10,s4,t6
    sw s11,4(a1)
    li s11, 0xa8a22391
    li t5, 0x1b4286dd
    li s7, 0x988c0022
    cmix a6,s11,t5,s7
    sw a6,8(a1)
    li s3, 0x430b3272
    li s5, 0x2b77485c
    li a5, 0x8b8e8f3e
    cmix s7,s3,s5,a5
    sw s7,12(a1)
    li t0, 0xadd85909
    li s4, 0x116023b7
    li s7, 0x29d882a1
    cmix a4,t0,s4,s7
    sw a4,16(a1)
    li t4, 0x00000000
    li a5, 0x2ba53005
    li s2, 0xb208965f
    cmix s6,t4,a5,s2
    sw s6,20(a1)
    li s5, 0xeb29f6d6
    li s8, 0x0039ff79
    li t3, 0xe8b7098a
    cmix t1,s5,s8,t3
    sw t1,24(a1)
    li t3, 0x2e8e213f
    li t4, 0x0131d6ea
    li t5, 0x00000000
    cmix s7,t3,t4,t5
    sw s7,28(a1)
    li a3, 0x0978be09
    li a4, 0x08800000
    li t1, 0x80010001
    cmix a0,a3,a4,t1
    sw a0,32(a1)
    li s10, 0xb735c043
    li a2, 0x08c83aa0
    li t6, 0x40020082
    cmix a4,s10,a2,t6
    sw a4,36(a1)
    li s0, 0x14b5e101
    li t4, 0x3867b8a7
    li t2, 0x0ff1097e
    cmix a2,s0,t4,t2
    sw a2,40(a1)
    li s9, 0x50002023
    li t1, 0x40000410
    li s1, 0x00000100
    cmix s5,s9,t1,s1
    sw s5,44(a1)
    li t6, 0xa5a832a3
    li t5, 0x68810625
    li a2, 0x288913fb
    cmix a0,t6,t5,a2
    sw a0,48(a1)
    li a0, 0x2d280704
    li s9, 0x8017d9d9
    li a2, 0x12ef4a58
    cmix a4,a0,s9,a2
    sw a4,52(a1)
    li a0, 0x43bda82c
    li s2, 0x87b2a825
    li a3, 0x1ba7f686
    cmix s7,a0,s2,a3
    sw s7,56(a1)
    li s7, 0x0a3b9fe9
    li s6, 0x9288ff06
    li s11, 0x0961b8b5
    cmix s0,s7,s6,s11
    sw s0,60(a1)
    li s10, 0x00090e19
    li s1, 0x92f4b235
    li a4, 0x0103b20e
    cmix a5,s10,s1,a4
    sw a5,64(a1)
    li t3, 0xf8e67357
    li s4, 0x96397276
    li t5, 0x71e40a26
    cmix a6,t3,s4,t5
    sw a6,68(a1)
    li t1, 0x5dd656a2
    li s7, 0xb001085f
    li t4, 0xa9610018
    cmix t5,t1,s7,t4
    sw t5,72(a1)
    li s0, 0xa0ca9fe8
    li t1, 0xca800015
    li t3, 0xac800fe8
    cmix a0,s0,t1,t3
    sw a0,76(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 20,4,-1
RV_COMPLIANCE_DATA_END
