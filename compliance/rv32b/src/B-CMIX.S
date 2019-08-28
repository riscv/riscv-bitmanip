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
    li s0, 0x0039ff79
    li a2, 0xeb29f6d6
    li t2, 0xe8b7098a
    cmix s8,s0,a2,t2
    sw s8,24(a1)
    li s4, 0x0131d6ea
    li t4, 0x2e8e213f
    li t1, 0x00000000
    cmix a4,s4,t4,t1
    sw a4,28(a1)
    li a4, 0x08800000
    li t5, 0x0978be09
    li s1, 0x80010001
    cmix t4,a4,t5,s1
    sw t4,32(a1)
    li t5, 0x08c83aa0
    li a2, 0xb735c043
    li t6, 0x40020082
    cmix s0,t5,a2,t6
    sw s0,36(a1)
    li s4, 0x3867b8a7
    li a5, 0x14b5e101
    li s7, 0x0ff1097e
    cmix t1,s4,a5,s7
    sw t1,40(a1)
    li s3, 0x40000410
    li s11, 0x50002023
    li s2, 0x00000100
    cmix s7,s3,s11,s2
    sw s7,44(a1)
    li s10, 0x68810625
    li s9, 0xa5a832a3
    li t6, 0x288913fb
    cmix s0,s10,s9,t6
    sw s0,48(a1)
    li s2, 0x8017d9d9
    li t4, 0x2d280704
    li t2, 0x12ef4a58
    cmix s3,s2,t4,t2
    sw s3,52(a1)
    li t3, 0x87b2a825
    li t2, 0x43bda82c
    li s6, 0x1ba7f686
    cmix a0,t3,t2,s6
    sw a0,56(a1)
    li s7, 0x9288ff06
    li s3, 0x0a3b9fe9
    li s6, 0x0961b8b5
    cmix s0,s7,s3,s6
    sw s0,60(a1)
    li s8, 0x92f4b235
    li s10, 0x00090e19
    li s7, 0x0103b20e
    cmix s11,s8,s10,s7
    sw s11,64(a1)
    li s8, 0x96397276
    li a3, 0xf8e67357
    li s3, 0x71e40a26
    cmix t2,s8,a3,s3
    sw t2,68(a1)
    li s5, 0xb001085f
    li s2, 0x5dd656a2
    li s9, 0xa9610018
    cmix s7,s5,s2,s9
    sw s7,72(a1)
    li a0, 0xca800015
    li s10, 0xa0ca9fe8
    li s0, 0xac800fe8
    cmix s9,a0,s10,s0
    sw s9,76(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 20,4,-1
RV_COMPLIANCE_DATA_END
