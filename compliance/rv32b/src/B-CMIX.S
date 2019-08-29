#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li t0, 0x5dd79cfa
    li a5, 0xc4ed4893
    li a2, 0x987a10dd
    cmix a4,t0,a5,a2
    sw a4,0(a1)
    li t1, 0x9c6f7aa2
    li s1, 0xfcae8655
    li a3, 0x02a2826c
    cmix s3,t1,s1,a3
    sw s3,4(a1)
    li t3, 0xa8a22391
    li a2, 0x1b4286dd
    li t4, 0x988c0022
    cmix t0,t3,a2,t4
    sw t0,8(a1)
    li s11, 0x430b3272
    li a3, 0x2b77485c
    li t6, 0x8b8e8f3e
    cmix s3,s11,a3,t6
    sw s3,12(a1)
    li a4, 0xadd85909
    li a7, 0x116023b7
    li s0, 0x29d882a1
    cmix t6,a4,a7,s0
    sw t6,16(a1)
    li s2, 0x00000000
    li s0, 0x2ba53005
    li t4, 0xb208965f
    cmix t5,s2,s0,t4
    sw t5,20(a1)
    li s4, 0xeb29f6d6
    li a3, 0x0039ff79
    li s1, 0xe8b7098a
    cmix t2,s4,a3,s1
    sw t2,24(a1)
    li s3, 0x2e8e213f
    li t0, 0x0131d6ea
    li t4, 0x00000000
    cmix s0,s3,t0,t4
    sw s0,28(a1)
    li s4, 0x0978be09
    li t0, 0x08800000
    li a3, 0x80010001
    cmix s2,s4,t0,a3
    sw s2,32(a1)
    li t2, 0xb735c043
    li a5, 0x08c83aa0
    li t4, 0x40020082
    cmix s10,t2,a5,t4
    sw s10,36(a1)
    li s9, 0x14b5e101
    li a0, 0x3867b8a7
    li t0, 0x0ff1097e
    cmix t2,s9,a0,t0
    sw t2,40(a1)
    li s9, 0x50002023
    li t2, 0x40000410
    li a4, 0x00000100
    cmix s0,s9,t2,a4
    sw s0,44(a1)
    li t2, 0xa5a832a3
    li s8, 0x68810625
    li s3, 0x288913fb
    cmix a4,t2,s8,s3
    sw a4,48(a1)
    li t0, 0x2d280704
    li t2, 0x8017d9d9
    li s1, 0x12ef4a58
    cmix s9,t0,t2,s1
    sw s9,52(a1)
    li s2, 0x43bda82c
    li a5, 0x87b2a825
    li s7, 0x1ba7f686
    cmix a3,s2,a5,s7
    sw a3,56(a1)
    li s8, 0x0a3b9fe9
    li a7, 0x9288ff06
    li s9, 0x0961b8b5
    cmix a3,s8,a7,s9
    sw a3,60(a1)
    li s7, 0x00090e19
    li s6, 0x92f4b235
    li s2, 0x0103b20e
    cmix a7,s7,s6,s2
    sw a7,64(a1)
    li s4, 0xf8e67357
    li s0, 0x96397276
    li s5, 0x71e40a26
    cmix a3,s4,s0,s5
    sw a3,68(a1)
    li s0, 0x5dd656a2
    li s1, 0xb001085f
    li a3, 0xa9610018
    cmix s10,s0,s1,a3
    sw s10,72(a1)
    li a0, 0xa0ca9fe8
    li s8, 0xca800015
    li t1, 0xac800fe8
    cmix s10,a0,s8,t1
    sw s10,76(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 20,4,-1
RV_COMPLIANCE_DATA_END
