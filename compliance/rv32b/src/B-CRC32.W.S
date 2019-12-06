#include "compliance_test.h"
#include "compliance_io.h"
#include "test_macros.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN
    la a1,test_results
    li a6, 0xd77b6ecd
    crc32.w t5,a6
    sw t5,0(a1)
    li s4, 0x36a9a6d7
    crc32.w s3,s4
    sw s3,4(a1)
    li a6, 0x219954ae
    crc32.w t4,a6
    sw t4,8(a1)
    li s3, 0x91f3a75b
    crc32.w s10,s3
    sw s10,12(a1)
    li s2, 0x6723f89c
    crc32.w t4,s2
    sw t4,16(a1)
    li s9, 0x6042e65d
    crc32.w s0,s9
    sw s0,20(a1)
    li s9, 0x00000000
    crc32.w a4,s9
    sw a4,24(a1)
    li t5, 0x00000004
    crc32.w s11,t5
    sw s11,28(a1)
    li t2, 0x0000002d
    crc32.w s1,t2
    sw s1,32(a1)
    li a3, 0x00000a80
    crc32.w a5,a3
    sw a5,36(a1)
    li s4, 0x00000dd7
    crc32.w s6,s4
    sw s6,40(a1)
    li t6, 0x00156892
    crc32.w s3,t6
    sw s3,44(a1)
    li s4, 0x0020aa01
    crc32.w s8,s4
    sw s8,48(a1)
    li t1, 0x002f74a0
    crc32.w t5,t1
    sw t5,52(a1)
    li t4, 0x00f03303
    crc32.w a6,t4
    sw a6,56(a1)
    li s4, 0x020010d3
    crc32.w t1,s4
    sw t1,60(a1)
    li s8, 0x020010db
    crc32.w s11,s8
    sw s11,64(a1)
    li s5, 0x04000004
    crc32.w t5,s5
    sw t5,68(a1)
    li t0, 0x06652557
    crc32.w s5,t0
    sw s5,72(a1)
    li t2, 0x06807dd5
    crc32.w s3,t2
    sw s3,76(a1)
    li s10, 0x08000ef5
    crc32.w s6,s10
    sw s6,80(a1)
    li a0, 0x08015886
    crc32.w a2,a0
    sw a2,84(a1)
    li s2, 0x0806a022
    crc32.w t5,s2
    sw t5,88(a1)
    li s7, 0x0810691e
    crc32.w s5,s7
    sw s5,92(a1)
    li s10, 0x10080084
    crc32.w t6,s10
    sw t6,96(a1)
    li s4, 0x1c48c7c4
    crc32.w s6,s4
    sw s6,100(a1)
    li s6, 0x27f33a8a
    crc32.w s11,s6
    sw s11,104(a1)
    li s5, 0x28083074
    crc32.w t6,s5
    sw t6,108(a1)
    li s8, 0x29a94208
    crc32.w s7,s8
    sw s7,112(a1)
    li s3, 0x42050184
    crc32.w t2,s3
    sw t2,116(a1)
    li a0, 0x561a6628
    crc32.w t3,a0
    sw t3,120(a1)
    li a0, 0x5ffbac3e
    crc32.w s9,a0
    sw s9,124(a1)
    li s5, 0x72a10106
    crc32.w a7,s5
    sw a7,128(a1)
    li s1, 0x809ffe48
    crc32.w s2,s1
    sw s2,132(a1)
    li a7, 0x80a27fee
    crc32.w s4,a7
    sw s4,136(a1)
    li s2, 0x820417c0
    crc32.w t0,s2
    sw t0,140(a1)
    li s1, 0xa9000610
    crc32.w a3,s1
    sw a3,144(a1)
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
