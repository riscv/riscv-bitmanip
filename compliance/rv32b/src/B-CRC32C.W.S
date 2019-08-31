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
    li s0, 0x00000000
    crc32c.w s9,s0
    sw s9,24(a1)
    li a5, 0x00000004
    crc32c.w s5,a5
    sw s5,28(a1)
    li s9, 0x0000002d
    crc32c.w s11,s9
    sw s11,32(a1)
    li t6, 0x00000a80
    crc32c.w a6,t6
    sw a6,36(a1)
    li a0, 0x00000dd7
    crc32c.w s6,a0
    sw s6,40(a1)
    li a4, 0x00156892
    crc32c.w t5,a4
    sw t5,44(a1)
    li s4, 0x0020aa01
    crc32c.w t4,s4
    sw t4,48(a1)
    li a6, 0x002f74a0
    crc32c.w a3,a6
    sw a3,52(a1)
    li a2, 0x00f03303
    crc32c.w s4,a2
    sw s4,56(a1)
    li s5, 0x020010d3
    crc32c.w s10,s5
    sw s10,60(a1)
    li t0, 0x020010db
    crc32c.w a6,t0
    sw a6,64(a1)
    li t2, 0x04000004
    crc32c.w s4,t2
    sw s4,68(a1)
    li s9, 0x06652557
    crc32c.w t5,s9
    sw t5,72(a1)
    li a6, 0x06807dd5
    crc32c.w s6,a6
    sw s6,76(a1)
    li a3, 0x08000ef5
    crc32c.w s9,a3
    sw s9,80(a1)
    li s4, 0x08015886
    crc32c.w a4,s4
    sw a4,84(a1)
    li s2, 0x0806a022
    crc32c.w s3,s2
    sw s3,88(a1)
    li a0, 0x0810691e
    crc32c.w s9,a0
    sw s9,92(a1)
    li t0, 0x10080084
    crc32c.w a3,t0
    sw a3,96(a1)
    li a3, 0x1c48c7c4
    crc32c.w a7,a3
    sw a7,100(a1)
    li s7, 0x27f33a8a
    crc32c.w a2,s7
    sw a2,104(a1)
    li t0, 0x28083074
    crc32c.w t5,t0
    sw t5,108(a1)
    li t4, 0x29a94208
    crc32c.w a6,t4
    sw a6,112(a1)
    li t0, 0x42050184
    crc32c.w t4,t0
    sw t4,116(a1)
    li s0, 0x561a6628
    crc32c.w s5,s0
    sw s5,120(a1)
    li a7, 0x5ffbac3e
    crc32c.w t3,a7
    sw t3,124(a1)
    li s6, 0x72a10106
    crc32c.w s8,s6
    sw s8,128(a1)
    li s3, 0x809ffe48
    crc32c.w s8,s3
    sw s8,132(a1)
    li t1, 0x80a27fee
    crc32c.w a7,t1
    sw a7,136(a1)
    li a2, 0x820417c0
    crc32c.w s7,a2
    sw s7,140(a1)
    li t3, 0xa9000610
    crc32c.w s1,t3
    sw s1,144(a1)
    RV_COMPLIANCE_HALT
RV_COMPLIANCE_CODE_END

.data
RV_COMPLIANCE_DATA_BEGIN
test_results:
.fill 37,4,-1
RV_COMPLIANCE_DATA_END
