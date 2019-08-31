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
    li t0, 0xeb29f6d6
    li s11, 0x0039ff79
    li t1, 0xe8b7098a
    cmix s2,t0,s11,t1
    sw s2,24(a1)
    li t2, 0x2e8e213f
    li s7, 0x0131d6ea
    li a3, 0x00000000
    cmix a2,t2,s7,a3
    sw a2,28(a1)
    li s3, 0x0978be09
    li s4, 0x08800000
    li a5, 0x80010001
    cmix s6,s3,s4,a5
    sw s6,32(a1)
    li a4, 0xb735c043
    li s6, 0x08c83aa0
    li s4, 0x40020082
    cmix t1,a4,s6,s4
    sw t1,36(a1)
    li a3, 0x14b5e101
    li s9, 0x3867b8a7
    li s3, 0x0ff1097e
    cmix t3,a3,s9,s3
    sw t3,40(a1)
    li t0, 0x50002023
    li a3, 0x40000410
    li s11, 0x00000100
    cmix s5,t0,a3,s11
    sw s5,44(a1)
    li s9, 0xa5a832a3
    li s11, 0x68810625
    li t2, 0x288913fb
    cmix a7,s9,s11,t2
    sw a7,48(a1)
    li t1, 0x2d280704
    li t0, 0x8017d9d9
    li a7, 0x12ef4a58
    cmix a0,t1,t0,a7
    sw a0,52(a1)
    li a0, 0x43bda82c
    li s5, 0x87b2a825
    li s0, 0x1ba7f686
    cmix a2,a0,s5,s0
    sw a2,56(a1)
    li s5, 0x0a3b9fe9
    li s4, 0x9288ff06
    li s1, 0x0961b8b5
    cmix s10,s5,s4,s1
    sw s10,60(a1)
    li a4, 0x00090e19
    li t1, 0x92f4b235
    li a2, 0x0103b20e
    cmix s3,a4,t1,a2
    sw s3,64(a1)
    li t2, 0xf8e67357
    li a5, 0x96397276
    li s4, 0x71e40a26
    cmix s10,t2,a5,s4
    sw s10,68(a1)
    li a6, 0x5dd656a2
    li t1, 0xb001085f
    li s11, 0xa9610018
    cmix s10,a6,t1,s11
    sw s10,72(a1)
    li t3, 0xa0ca9fe8
    li a0, 0xca800015
    li a2, 0xac800fe8
    cmix a4,t3,a0,a2
    sw a4,76(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 20,4,-1
RV_COMPLIANCE_DATA_END
