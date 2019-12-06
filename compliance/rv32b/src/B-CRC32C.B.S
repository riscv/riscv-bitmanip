#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a7, 0xd77b6ecd
    crc32c.b s5,a7
    sw s5,0(a1)
    li a3, 0x36a9a6d7
    crc32c.b s10,a3
    sw s10,4(a1)
    li s5, 0x219954ae
    crc32c.b s2,s5
    sw s2,8(a1)
    li a7, 0x91f3a75b
    crc32c.b s2,a7
    sw s2,12(a1)
    li s3, 0x6723f89c
    crc32c.b s1,s3
    sw s1,16(a1)
    li s4, 0x6042e65d
    crc32c.b t4,s4
    sw t4,20(a1)
    li s5, 0x00000000
    crc32c.b a6,s5
    sw a6,24(a1)
    li a6, 0x00000004
    crc32c.b a3,a6
    sw a3,28(a1)
    li s2, 0x0000002d
    crc32c.b t4,s2
    sw t4,32(a1)
    li t0, 0x00000a80
    crc32c.b s0,t0
    sw s0,36(a1)
    li s5, 0x00000dd7
    crc32c.b a4,s5
    sw a4,40(a1)
    li t0, 0x00156892
    crc32c.b a3,t0
    sw a3,44(a1)
    li s6, 0x0020aa01
    crc32c.b s0,s6
    sw s0,48(a1)
    li s10, 0x002f74a0
    crc32c.b a7,s10
    sw a7,52(a1)
    li s1, 0x00f03303
    crc32c.b s10,s1
    sw s10,56(a1)
    li s0, 0x020010d3
    crc32c.b s11,s0
    sw s11,60(a1)
    li s2, 0x020010db
    crc32c.b t4,s2
    sw t4,64(a1)
    li t0, 0x04000004
    crc32c.b s5,t0
    sw s5,68(a1)
    li s3, 0x06652557
    crc32c.b s7,s3
    sw s7,72(a1)
    li s8, 0x06807dd5
    crc32c.b t2,s8
    sw t2,76(a1)
    li t3, 0x08000ef5
    crc32c.b s3,t3
    sw s3,80(a1)
    li s9, 0x08015886
    crc32c.b s6,s9
    sw s6,84(a1)
    li a5, 0x0806a022
    crc32c.b a7,a5
    sw a7,88(a1)
    li a3, 0x0810691e
    crc32c.b a4,a3
    sw a4,92(a1)
    li s8, 0x10080084
    crc32c.b t4,s8
    sw t4,96(a1)
    li t3, 0x1c48c7c4
    crc32c.b s11,t3
    sw s11,100(a1)
    li s1, 0x27f33a8a
    crc32c.b a4,s1
    sw a4,104(a1)
    li s1, 0x28083074
    crc32c.b s6,s1
    sw s6,108(a1)
    li s10, 0x29a94208
    crc32c.b t1,s10
    sw t1,112(a1)
    li t1, 0x42050184
    crc32c.b a4,t1
    sw a4,116(a1)
    li a0, 0x561a6628
    crc32c.b t5,a0
    sw t5,120(a1)
    li s1, 0x5ffbac3e
    crc32c.b s0,s1
    sw s0,124(a1)
    li t0, 0x72a10106
    crc32c.b t1,t0
    sw t1,128(a1)
    li a7, 0x809ffe48
    crc32c.b t0,a7
    sw t0,132(a1)
    li t1, 0x80a27fee
    crc32c.b t6,t1
    sw t6,136(a1)
    li a0, 0x820417c0
    crc32c.b t5,a0
    sw t5,140(a1)
    li a2, 0xa9000610
    crc32c.b s7,a2
    sw s7,144(a1)
    sw zero,148(a1)
    sw zero,152(a1)
    sw zero,156(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 40,4,-1
RV_COMPLIANCE_DATA_END
