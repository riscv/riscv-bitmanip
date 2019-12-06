#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s8, 0xd77b6ecd
    crc32c.w s4,s8
    sw s4,0(a1)
    li a7, 0x36a9a6d7
    crc32c.w t2,a7
    sw t2,4(a1)
    li t0, 0x219954ae
    crc32c.w s0,t0
    sw s0,8(a1)
    li s4, 0x91f3a75b
    crc32c.w a5,s4
    sw a5,12(a1)
    li a3, 0x6723f89c
    crc32c.w a6,a3
    sw a6,16(a1)
    li a5, 0x6042e65d
    crc32c.w s11,a5
    sw s11,20(a1)
    li a6, 0x00000000
    crc32c.w a3,a6
    sw a3,24(a1)
    li a2, 0x00000004
    crc32c.w s4,a2
    sw s4,28(a1)
    li s5, 0x0000002d
    crc32c.w s10,s5
    sw s10,32(a1)
    li t0, 0x00000a80
    crc32c.w a6,t0
    sw a6,36(a1)
    li t2, 0x00000dd7
    crc32c.w s4,t2
    sw s4,40(a1)
    li s9, 0x00156892
    crc32c.w t5,s9
    sw t5,44(a1)
    li a6, 0x0020aa01
    crc32c.w s6,a6
    sw s6,48(a1)
    li a3, 0x002f74a0
    crc32c.w s9,a3
    sw s9,52(a1)
    li s4, 0x00f03303
    crc32c.w a4,s4
    sw a4,56(a1)
    li s2, 0x020010d3
    crc32c.w s3,s2
    sw s3,60(a1)
    li a0, 0x020010db
    crc32c.w s9,a0
    sw s9,64(a1)
    li t0, 0x04000004
    crc32c.w a3,t0
    sw a3,68(a1)
    li a3, 0x06652557
    crc32c.w a7,a3
    sw a7,72(a1)
    li s7, 0x06807dd5
    crc32c.w a2,s7
    sw a2,76(a1)
    li t0, 0x08000ef5
    crc32c.w t5,t0
    sw t5,80(a1)
    li t4, 0x08015886
    crc32c.w a6,t4
    sw a6,84(a1)
    li t0, 0x0806a022
    crc32c.w t4,t0
    sw t4,88(a1)
    li s0, 0x0810691e
    crc32c.w s5,s0
    sw s5,92(a1)
    li a7, 0x10080084
    crc32c.w t3,a7
    sw t3,96(a1)
    li s6, 0x1c48c7c4
    crc32c.w s8,s6
    sw s8,100(a1)
    li s3, 0x27f33a8a
    crc32c.w s8,s3
    sw s8,104(a1)
    li t1, 0x28083074
    crc32c.w a7,t1
    sw a7,108(a1)
    li a2, 0x29a94208
    crc32c.w s7,a2
    sw s7,112(a1)
    li t3, 0x42050184
    crc32c.w s1,t3
    sw s1,116(a1)
    li a4, 0x561a6628
    crc32c.w t5,a4
    sw t5,120(a1)
    li a6, 0x5ffbac3e
    crc32c.w t5,a6
    sw t5,124(a1)
    li s4, 0x72a10106
    crc32c.w s7,s4
    sw s7,128(a1)
    li t2, 0x809ffe48
    crc32c.w a6,t2
    sw a6,132(a1)
    li t1, 0x80a27fee
    crc32c.w t3,t1
    sw t3,136(a1)
    li s9, 0x820417c0
    crc32c.w a6,s9
    sw a6,140(a1)
    li s11, 0xa9000610
    crc32c.w s4,s11
    sw s4,144(a1)
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
