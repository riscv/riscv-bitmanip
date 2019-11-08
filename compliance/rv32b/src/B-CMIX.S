#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a6, 0x5dd79cfa
    li t5, 0xc4ed4893
    li t6, 0x987a10dd
    cmix s4,a6,t5,t6
    sw s4,0(a1)
    li t4, 0x9c6f7aa2
    li s7, 0xfcae8655
    li s6, 0x02a2826c
    cmix a0,t4,s7,s6
    sw a0,4(a1)
    li s11, 0xa8a22391
    li s10, 0x1b4286dd
    li s6, 0x988c0022
    cmix a3,s11,s10,s6
    sw a3,8(a1)
    li s10, 0x430b3272
    li a2, 0x2b77485c
    li s2, 0x8b8e8f3e
    cmix s7,s10,a2,s2
    sw s7,12(a1)
    li t2, 0xadd85909
    li t6, 0x116023b7
    li s3, 0x29d882a1
    cmix s1,t2,t6,s3
    sw s1,16(a1)
    li a0, 0x00000000
    li t1, 0x2ba53005
    li t4, 0xb208965f
    cmix a6,a0,t1,t4
    sw a6,20(a1)
    li s2, 0xeb29f6d6
    li a0, 0x0039ff79
    li t5, 0xe8b7098a
    cmix s0,s2,a0,t5
    sw s0,24(a1)
    li s1, 0x2e8e213f
    li s2, 0x0131d6ea
    li a2, 0x00000000
    cmix s8,s1,s2,a2
    sw s8,28(a1)
    li s6, 0x0978be09
    li s8, 0x08800000
    li a3, 0x80010001
    cmix a2,s6,s8,a3
    sw a2,32(a1)
    li t0, 0xb735c043
    li t4, 0x08c83aa0
    li s8, 0x40020082
    cmix t1,t0,t4,s8
    sw t1,36(a1)
    li s2, 0x14b5e101
    li t0, 0x3867b8a7
    li s3, 0x0ff1097e
    cmix t6,s2,t0,s3
    sw t6,40(a1)
    li s9, 0x50002023
    li a2, 0x40000410
    li s8, 0x00000100
    cmix a7,s9,a2,s8
    sw a7,44(a1)
    li t5, 0xa5a832a3
    li s7, 0x68810625
    li a0, 0x288913fb
    cmix t0,t5,s7,a0
    sw t0,48(a1)
    li s4, 0x2d280704
    li t1, 0x8017d9d9
    li t2, 0x12ef4a58
    cmix t4,s4,t1,t2
    sw t4,52(a1)
    li s0, 0x43bda82c
    li t4, 0x87b2a825
    li s5, 0x1ba7f686
    cmix s9,s0,t4,s5
    sw s9,56(a1)
    li a3, 0x0a3b9fe9
    li t6, 0x9288ff06
    li t1, 0x0961b8b5
    cmix t4,a3,t6,t1
    sw t4,60(a1)
    li t3, 0x00090e19
    li t0, 0x92f4b235
    li t4, 0x0103b20e
    cmix s10,t3,t0,t4
    sw s10,64(a1)
    li s8, 0xf8e67357
    li a0, 0x96397276
    li s9, 0x71e40a26
    cmix s10,s8,a0,s9
    sw s10,68(a1)
    li s0, 0x5dd656a2
    li s2, 0xb001085f
    li t0, 0xa9610018
    cmix s4,s0,s2,t0
    sw s4,72(a1)
    li s7, 0xa0ca9fe8
    li a4, 0xca800015
    li t3, 0xac800fe8
    cmix t0,s7,a4,t3
    sw t0,76(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 20,4,-1
RV_COMPLIANCE_DATA_END
