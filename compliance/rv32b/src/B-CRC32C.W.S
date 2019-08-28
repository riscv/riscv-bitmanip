#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li s4, 0xd77b6ecd
    crc32c.w s9,s4
    sw s9,0(a1)
    li s8, 0x36a9a6d7
    crc32c.w a6,s8
    sw a6,4(a1)
    li s8, 0x219954ae
    crc32c.w s4,s8
    sw s4,8(a1)
    li a7, 0x91f3a75b
    crc32c.w t2,a7
    sw t2,12(a1)
    li t0, 0x6723f89c
    crc32c.w s0,t0
    sw s0,16(a1)
    li s4, 0x6042e65d
    crc32c.w a5,s4
    sw a5,20(a1)
    li s7, 0x00000000
    crc32c.w s0,s7
    sw s0,24(a1)
    li a0, 0x00000004
    crc32c.w t0,a0
    sw t0,28(a1)
    li s10, 0x0000002d
    crc32c.w s4,s10
    sw s4,32(a1)
    li t2, 0x00000a80
    crc32c.w t1,t2
    sw t1,36(a1)
    li t0, 0x00000dd7
    crc32c.w s0,t0
    sw s0,40(a1)
    li a7, 0x00156892
    crc32c.w s5,a7
    sw s5,44(a1)
    li t4, 0x0020aa01
    crc32c.w s10,t4
    sw s10,48(a1)
    li a3, 0x002f74a0
    crc32c.w t3,a3
    sw t3,52(a1)
    li a4, 0x00f03303
    crc32c.w s3,a4
    sw s3,56(a1)
    li t3, 0x020010d3
    crc32c.w a3,t3
    sw a3,60(a1)
    li s7, 0x020010db
    crc32c.w a4,s7
    sw a4,64(a1)
    li s2, 0x04000004
    crc32c.w t6,s2
    sw t6,68(a1)
    li t3, 0x06652557
    crc32c.w s10,t3
    sw s10,72(a1)
    li a7, 0x06807dd5
    crc32c.w s10,a7
    sw s10,76(a1)
    li t4, 0x08000ef5
    crc32c.w s9,t4
    sw s9,80(a1)
    li s6, 0x08015886
    crc32c.w s0,s6
    sw s0,84(a1)
    li a0, 0x0806a022
    crc32c.w s3,a0
    sw s3,88(a1)
    li s11, 0x0810691e
    crc32c.w s10,s11
    sw s10,92(a1)
    li a0, 0x10080084
    crc32c.w a7,a0
    sw a7,96(a1)
    li t2, 0x1c48c7c4
    crc32c.w t1,t2
    sw t1,100(a1)
    li s9, 0x27f33a8a
    crc32c.w t3,s9
    sw t3,104(a1)
    li a3, 0x28083074
    crc32c.w a6,a3
    sw a6,108(a1)
    li a2, 0x29a94208
    crc32c.w s4,a2
    sw s4,112(a1)
    li s10, 0x42050184
    crc32c.w s0,s10
    sw s0,116(a1)
    li a4, 0x561a6628
    crc32c.w s11,a4
    sw s11,120(a1)
    li s9, 0x5ffbac3e
    crc32c.w a2,s9
    sw a2,124(a1)
    li a6, 0x72a10106
    crc32c.w a0,a6
    sw a0,128(a1)
    li t5, 0x809ffe48
    crc32c.w s0,t5
    sw s0,132(a1)
    li s7, 0x80a27fee
    crc32c.w s0,s7
    sw s0,136(a1)
    li s1, 0x820417c0
    crc32c.w t1,s1
    sw t1,140(a1)
    li t1, 0xa9000610
    crc32c.w s9,t1
    sw s9,144(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 37,4,-1
RV_COMPLIANCE_DATA_END
